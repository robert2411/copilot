---
name: Jira-to-Backlog Sync Setup and Usage
---

# Jira-to-Backlog One-Way Sync

Syncs Jira issues into Backlog.md milestone files. One-way: Jira → Backlog. Idempotent — safe to run repeatedly.

## Prerequisites

- Python 3.9+
- pip

## Installation

```bash
cd scripts/jira_sync
pip install -r requirements.txt
```

## Configuration

Copy the example config and fill in your values:

```bash
cp config.example.yml config.yml
```

### Config fields

| Field | Env Override | Description |
|---|---|---|
| `jira_url` | `JIRA_URL` | Jira instance URL (e.g. `https://org.atlassian.net`) |
| `jira_email` | `JIRA_EMAIL` | Jira account email |
| `jira_token` | `JIRA_TOKEN` | Jira API token ([create one](https://id.atlassian.com/manage-profile/security/api-tokens)) |
| `jql_query` | `JIRA_JQL` | JQL query to select issues |
| `backlog_milestones_path` | `BACKLOG_MILESTONES_PATH` | Path to milestones dir (default: `backlog/milestones`) |

Environment variables override YAML values. You can skip the YAML file entirely and use only env vars.

## Usage

```bash
# With config file
python scripts/jira_sync/sync.py -c scripts/jira_sync/config.yml

# With env vars only
JIRA_URL=https://org.atlassian.net \
JIRA_EMAIL=you@example.com \
JIRA_TOKEN=your-token \
JIRA_JQL="project = PROJ AND status != Done" \
python scripts/jira_sync/sync.py

# Verbose logging
python scripts/jira_sync/sync.py -c config.yml -v
```

## What it does

1. Reads config from YAML file and/or environment variables
2. Queries Jira REST API with the configured JQL (handles pagination)
3. For each issue, creates a milestone file: `{JIRA_KEY}-{Sanitized-Summary}.md`
4. Milestone files include `jira_key` in YAML frontmatter for deduplication
5. Skips issues that already have a matching milestone (idempotent)
6. Logs created/skipped counts

## Example milestone output

```markdown
---
jira_key: PROJ-42
name: Implement user authentication
---

Full description from Jira issue body.
```

## Running tests

```bash
cd scripts/jira_sync
pip install pytest
pytest test_sync.py -v
```

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `Missing required config fields` | Config incomplete | Set missing fields in YAML or env vars |
| `401 Unauthorized` | Bad credentials | Check email + API token |
| `Connection error` | Can't reach Jira | Check URL and network |
| `Request timed out` | Jira slow/unreachable | Retry, check network |


