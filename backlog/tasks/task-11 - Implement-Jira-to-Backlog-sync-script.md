---
id: TASK-11
title: Implement Jira-to-Backlog sync script
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:51'
updated_date: '2026-04-16 18:58'
labels:
  - jira
  - sync
  - python
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Python script for one-way Jira to Backlog milestone sync. Connects to Jira REST API, runs configurable JQL query, creates Backlog.md milestone per Jira task with jira_key metadata for dedup.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Reads config from external YAML or env vars
- [x] #2 Queries Jira REST API with configured JQL
- [x] #3 Creates milestone per Jira issue with jira_key in frontmatter
- [x] #4 Skips if jira_key exists already (idempotent)
- [x] #5 Logs created and skipped milestones
- [x] #6 requirements.txt with dependencies
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create `scripts/jira_sync/` directory for the sync script
2. Create `scripts/jira_sync/config.example.yml` with: jira_url, jira_email, jira_token (or env var refs), jql_query, backlog_milestones_path
3. Implement `scripts/jira_sync/sync.py`:
   a. Load config from YAML file (path via CLI arg or env var), with env var overrides (JIRA_URL, JIRA_EMAIL, JIRA_TOKEN, JIRA_JQL) — satisfies AC#1
   b. Query Jira REST API (`/rest/api/2/search`) with configured JQL, paginate results — satisfies AC#2
   c. For each Jira issue, generate milestone filename from summary, write markdown with `jira_key: PROJ-123` in YAML frontmatter + description body — satisfies AC#3
   d. Before creating, scan existing milestone files for matching `jira_key` in frontmatter; skip if found — satisfies AC#4
   e. Use Python logging module: INFO for created/skipped, summary counts at end — satisfies AC#5
4. Create `scripts/jira_sync/requirements.txt` with: requests, pyyaml — satisfies AC#6
5. Use `requests` for HTTP, `pyyaml` for config parsing, `pathlib` for file ops
6. Sanitize Jira summary for filename (replace special chars, truncate length)
7. Handle API errors gracefully (auth failures, network errors, invalid JQL)
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers.

- Created scripts/jira_sync/sync.py with config loading, Jira API query, milestone creation, dedup, logging
- Created config.example.yml
- Created requirements.txt
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
