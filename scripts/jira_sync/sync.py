#!/usr/bin/env python3
"""Jira-to-Backlog one-way sync: creates Backlog.md milestones from Jira issues."""

from __future__ import annotations

import argparse
import logging
import os
import re
import sys
from pathlib import Path
from typing import Optional

import requests
import yaml

logger = logging.getLogger("jira_sync")


def load_config(config_path: str | None = None) -> dict:
    """Load config from YAML file with env var overrides.

    Priority: env vars > YAML file > defaults.
    """
    cfg = {}

    # Load from YAML if path given
    if config_path:
        p = Path(config_path)
        if not p.exists():
            raise FileNotFoundError(f"Config file not found: {config_path}")
        with open(p) as f:
            cfg = yaml.safe_load(f) or {}

    # Env var overrides
    env_map = {
        "JIRA_URL": "jira_url",
        "JIRA_EMAIL": "jira_email",
        "JIRA_TOKEN": "jira_token",
        "JIRA_JQL": "jql_query",
        "BACKLOG_MILESTONES_PATH": "backlog_milestones_path",
    }
    for env_key, cfg_key in env_map.items():
        val = os.environ.get(env_key)
        if val:
            cfg[cfg_key] = val

    # Defaults
    cfg.setdefault("backlog_milestones_path", "backlog/milestones")

    # Validate required fields
    required = ["jira_url", "jira_email", "jira_token", "jql_query"]
    missing = [k for k in required if not cfg.get(k)]
    if missing:
        raise ValueError(f"Missing required config fields: {', '.join(missing)}")

    return cfg


def sanitize_filename(summary: str) -> str:
    """Convert Jira summary to safe milestone filename component."""
    # Replace non-alphanumeric (except spaces/hyphens) with empty
    name = re.sub(r"[^\w\s-]", "", summary)
    # Replace whitespace runs with hyphens
    name = re.sub(r"\s+", "-", name.strip())
    # Truncate to 80 chars
    return name[:80]


def query_jira(cfg: dict) -> list[dict]:
    """Query Jira REST API with configured JQL. Handles pagination."""
    url = cfg["jira_url"].rstrip("/") + "/rest/api/2/search"
    auth = (cfg["jira_email"], cfg["jira_token"])
    issues: list[dict] = []
    start_at = 0
    max_results = 50

    while True:
        params = {
            "jql": cfg["jql_query"],
            "startAt": start_at,
            "maxResults": max_results,
            "fields": "summary,description,status",
        }
        resp = requests.get(url, params=params, auth=auth, timeout=30)
        resp.raise_for_status()
        data = resp.json()

        batch = data.get("issues", [])
        issues.extend(batch)

        total = data.get("total", 0)
        start_at += len(batch)
        if start_at >= total or not batch:
            break

    return issues


def scan_existing_jira_keys(milestones_dir: Path) -> set[str]:
    """Scan milestone files for jira_key in YAML frontmatter."""
    keys: set[str] = set()
    if not milestones_dir.exists():
        return keys

    for f in milestones_dir.glob("*.md"):
        try:
            text = f.read_text()
        except OSError:
            continue
        # Parse YAML frontmatter between --- markers
        match = re.match(r"^---\s*\n(.*?)\n---", text, re.DOTALL)
        if match:
            try:
                fm = yaml.safe_load(match.group(1))
                if isinstance(fm, dict) and fm.get("jira_key"):
                    keys.add(str(fm["jira_key"]))
            except yaml.YAMLError:
                continue
    return keys


def create_milestone(issue: dict, milestones_dir: Path) -> Path:
    """Create a milestone markdown file from a Jira issue."""
    key = issue["key"]
    fields = issue.get("fields", {})
    summary = fields.get("summary", key)
    description = fields.get("description") or ""

    filename = f"{key}-{sanitize_filename(summary)}.md"
    filepath = milestones_dir / filename

    frontmatter = {
        "name": summary,
        "jira_key": key,
    }

    content = "---\n"
    content += yaml.dump(frontmatter, default_flow_style=False).strip()
    content += "\n---\n\n"
    content += description.strip() + "\n"

    filepath.write_text(content)
    return filepath


def sync(cfg: dict) -> dict:
    """Run sync. Returns counts dict with 'created' and 'skipped'."""
    milestones_dir = Path(cfg["backlog_milestones_path"])
    milestones_dir.mkdir(parents=True, exist_ok=True)

    logger.info("Querying Jira: %s", cfg["jql_query"])
    issues = query_jira(cfg)
    logger.info("Found %d Jira issues", len(issues))

    existing_keys = scan_existing_jira_keys(milestones_dir)
    created = 0
    skipped = 0

    for issue in issues:
        key = issue["key"]
        summary = issue.get("fields", {}).get("summary", key)

        if key in existing_keys:
            logger.info("SKIP: %s — %s (already exists)", key, summary)
            skipped += 1
            continue

        path = create_milestone(issue, milestones_dir)
        logger.info("CREATED: %s — %s → %s", key, summary, path.name)
        existing_keys.add(key)
        created += 1

    logger.info("Sync complete: %d created, %d skipped", created, skipped)
    return {"created": created, "skipped": skipped}


def main() -> None:
    parser = argparse.ArgumentParser(description="Sync Jira issues to Backlog milestones")
    parser.add_argument("-c", "--config", help="Path to YAML config file")
    parser.add_argument("-v", "--verbose", action="store_true", help="Debug logging")
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )

    try:
        cfg = load_config(args.config)
    except (FileNotFoundError, ValueError) as e:
        logger.error("Config error: %s", e)
        sys.exit(1)

    try:
        sync(cfg)
    except requests.HTTPError as e:
        logger.error("Jira API error: %s", e)
        sys.exit(1)
    except requests.ConnectionError as e:
        logger.error("Connection error: %s", e)
        sys.exit(1)
    except requests.Timeout as e:
        logger.error("Request timed out: %s", e)
        sys.exit(1)


if __name__ == "__main__":
    main()




