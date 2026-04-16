---
id: TASK-11
title: Implement Jira-to-Backlog sync script
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:51'
updated_date: '2026-04-16 19:00'
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

🔍 QA REVIEW FINDINGS:

- Issue #1: [Medium] Security — `scripts/jira_sync/config.yml` not in `.gitignore`. Users who copy `config.example.yml` to `config.yml` (as instructed) risk committing Jira credentials. Add `scripts/jira_sync/config.yml` to `.gitignore`. (file: .gitignore)

- Issue #2: [Medium] Filename collision — Two Jira issues with identical summaries produce the same filename. Second call to `create_milestone` silently overwrites the first. Should include jira_key in filename or check for file existence. (file: sync.py, line 127)

- Issue #3: [Medium] CVE — `requests>=2.28.0` has 4 known CVEs (CVE-2023-32681, CVE-2024-35195, CVE-2024-47081, CVE-2026-25645). Bump minimum to `requests>=2.33.0`. (file: requirements.txt, line 1)

- Issue #4: [Low] Env var empty-string handling — Line 42: `if val:` means setting `JIRA_URL=""` silently falls through to YAML value instead of erroring. Acceptable but worth a comment. (file: sync.py, line 42)

- Issue #5: [Low] `requests.Timeout` not caught — `timeout=30` is set but `requests.Timeout` exception is not handled in `main()`. Only `HTTPError` and `ConnectionError` are caught. (file: sync.py, line 194-198)

Verdict: Fix Issues #1, #2, #3, #5 before approval. #4 is optional.

✅ QA RE-REVIEW APPROVED: All 4 required fixes verified.
- #1 config.yml in .gitignore ✅
- #2 Filename includes jira_key prefix ✅
- #3 requests>=2.33.0 ✅
- #5 requests.Timeout caught in main() ✅
- #4 (Low, skipped) unchanged, acceptable.

Code quality: Good. Security: No issues. Spelling: Clean.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
