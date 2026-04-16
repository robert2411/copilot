"""Tests for Jira-to-Backlog sync script."""

import os
import textwrap
from pathlib import Path
from unittest.mock import patch, MagicMock

import pytest
import yaml

# Import the module under test
import sys
sys.path.insert(0, str(Path(__file__).parent))
from sync import (
    load_config,
    sanitize_filename,
    query_jira,
    scan_existing_jira_keys,
    create_milestone,
    sync,
)


# ---------------------------------------------------------------------------
# Unit tests: config loading (AC#1)
# ---------------------------------------------------------------------------

class TestLoadConfig:
    def test_load_from_yaml(self, tmp_path):
        cfg_file = tmp_path / "config.yml"
        cfg_file.write_text(textwrap.dedent("""\
            jira_url: https://test.atlassian.net
            jira_email: a@b.com
            jira_token: tok123
            jql_query: "project = TEST"
        """))
        cfg = load_config(str(cfg_file))
        assert cfg["jira_url"] == "https://test.atlassian.net"
        assert cfg["jira_token"] == "tok123"
        assert cfg["backlog_milestones_path"] == "backlog/milestones"

    def test_env_var_overrides(self, tmp_path):
        cfg_file = tmp_path / "config.yml"
        cfg_file.write_text(textwrap.dedent("""\
            jira_url: https://old.atlassian.net
            jira_email: old@b.com
            jira_token: oldtok
            jql_query: "project = OLD"
        """))
        env = {
            "JIRA_URL": "https://new.atlassian.net",
            "JIRA_EMAIL": "new@b.com",
            "JIRA_TOKEN": "newtok",
            "JIRA_JQL": "project = NEW",
        }
        with patch.dict(os.environ, env, clear=False):
            cfg = load_config(str(cfg_file))
        assert cfg["jira_url"] == "https://new.atlassian.net"
        assert cfg["jql_query"] == "project = NEW"

    def test_env_only_no_yaml(self):
        env = {
            "JIRA_URL": "https://x.atlassian.net",
            "JIRA_EMAIL": "x@b.com",
            "JIRA_TOKEN": "xtok",
            "JIRA_JQL": "project = X",
        }
        with patch.dict(os.environ, env, clear=False):
            cfg = load_config(None)
        assert cfg["jira_url"] == "https://x.atlassian.net"

    def test_missing_required_raises(self, monkeypatch):
        for key in ("JIRA_URL", "JIRA_EMAIL", "JIRA_TOKEN", "JIRA_JQL"):
            monkeypatch.delenv(key, raising=False)
        with pytest.raises(ValueError, match="Missing required config"):
            load_config(None)

    def test_file_not_found(self):
        with pytest.raises(FileNotFoundError):
            load_config("/nonexistent/config.yml")


# ---------------------------------------------------------------------------
# Unit tests: dedup logic (AC#1)
# ---------------------------------------------------------------------------

class TestDedup:
    def test_scan_existing_jira_keys(self, tmp_path):
        (tmp_path / "a.md").write_text("---\nname: A\njira_key: PROJ-1\n---\nBody\n")
        (tmp_path / "b.md").write_text("---\nname: B\njira_key: PROJ-2\n---\nBody\n")
        (tmp_path / "c.md").write_text("---\nname: C\n---\nNo jira key\n")
        keys = scan_existing_jira_keys(tmp_path)
        assert keys == {"PROJ-1", "PROJ-2"}

    def test_scan_empty_dir(self, tmp_path):
        keys = scan_existing_jira_keys(tmp_path)
        assert keys == set()

    def test_scan_nonexistent_dir(self, tmp_path):
        keys = scan_existing_jira_keys(tmp_path / "nope")
        assert keys == set()


class TestSanitizeFilename:
    def test_basic(self):
        assert sanitize_filename("Hello World") == "Hello-World"

    def test_special_chars(self):
        assert sanitize_filename("Fix: bug #42 (urgent!)") == "Fix-bug-42-urgent"

    def test_truncation(self):
        long = "A" * 100
        assert len(sanitize_filename(long)) == 80


# ---------------------------------------------------------------------------
# Integration test: mocked Jira API (AC#2)
# ---------------------------------------------------------------------------

def _make_jira_response(issues):
    """Helper to build a Jira search API response."""
    return {
        "startAt": 0,
        "maxResults": 50,
        "total": len(issues),
        "issues": issues,
    }


def _make_issue(key, summary, description=""):
    return {
        "key": key,
        "fields": {
            "summary": summary,
            "description": description,
            "status": {"name": "To Do"},
        },
    }


class TestSyncIntegration:
    def _cfg(self, tmp_path):
        return {
            "jira_url": "https://test.atlassian.net",
            "jira_email": "a@b.com",
            "jira_token": "tok",
            "jql_query": "project = TEST",
            "backlog_milestones_path": str(tmp_path),
        }

    @patch("sync.requests.get")
    def test_creates_milestones(self, mock_get, tmp_path):
        issues = [
            _make_issue("TEST-1", "First feature", "Do the thing"),
            _make_issue("TEST-2", "Second feature"),
        ]
        mock_resp = MagicMock()
        mock_resp.json.return_value = _make_jira_response(issues)
        mock_resp.raise_for_status = MagicMock()
        mock_get.return_value = mock_resp

        result = sync(self._cfg(tmp_path))

        assert result["created"] == 2
        assert result["skipped"] == 0
        files = list(tmp_path.glob("*.md"))
        assert len(files) == 2

        # Verify frontmatter
        for f in files:
            text = f.read_text()
            assert "jira_key:" in text

    @patch("sync.requests.get")
    def test_idempotent_skips_existing(self, mock_get, tmp_path):
        """Run sync twice — second run skips all."""
        issues = [_make_issue("TEST-1", "Feature")]
        mock_resp = MagicMock()
        mock_resp.json.return_value = _make_jira_response(issues)
        mock_resp.raise_for_status = MagicMock()
        mock_get.return_value = mock_resp

        cfg = self._cfg(tmp_path)
        r1 = sync(cfg)
        assert r1["created"] == 1

        r2 = sync(cfg)
        assert r2["created"] == 0
        assert r2["skipped"] == 1

    @patch("sync.requests.get")
    def test_api_error_propagates(self, mock_get, tmp_path):
        import requests as req
        mock_resp = MagicMock()
        mock_resp.raise_for_status.side_effect = req.HTTPError("401 Unauthorized")
        mock_get.return_value = mock_resp

        with pytest.raises(req.HTTPError):
            sync(self._cfg(tmp_path))

    @patch("sync.requests.get")
    def test_pagination(self, mock_get, tmp_path):
        """Verify pagination — two pages of results."""
        page1_issues = [_make_issue(f"TEST-{i}", f"Issue {i}") for i in range(1, 4)]
        page2_issues = [_make_issue("TEST-4", "Issue 4")]

        resp1 = MagicMock()
        resp1.json.return_value = {"startAt": 0, "maxResults": 3, "total": 4, "issues": page1_issues}
        resp1.raise_for_status = MagicMock()

        resp2 = MagicMock()
        resp2.json.return_value = {"startAt": 3, "maxResults": 3, "total": 4, "issues": page2_issues}
        resp2.raise_for_status = MagicMock()

        mock_get.side_effect = [resp1, resp2]

        # Use query_jira directly to test pagination
        cfg = self._cfg(tmp_path)
        issues = query_jira(cfg)
        assert len(issues) == 4


