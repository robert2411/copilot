---
id: TASK-12
title: Test and document Jira sync script
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:51'
updated_date: '2026-04-16 19:02'
labels:
  - jira
  - sync
  - python
milestone: Jira to Backlog One-Way Sync
dependencies:
  - TASK-11
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Write tests and usage docs for the Jira-to-Backlog sync script. Verify idempotency, error handling, and config validation.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Unit tests for config loading and milestone dedup logic
- [x] #2 Integration test with mocked Jira API responses
- [x] #3 README or doc in backlog/docs describing setup and usage
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create `scripts/jira_sync/test_sync.py` with pytest:
   a. Unit test: config loading from YAML + env var overrides — satisfies AC#1
   b. Unit test: dedup logic — scan milestones dir, detect existing jira_key, skip correctly — satisfies AC#1
   c. Integration test: mock Jira API with `responses` or `unittest.mock.patch` on requests.get, verify milestone files created with correct frontmatter — satisfies AC#2
   d. Test idempotency: run sync twice with same mock data, assert no duplicates
   e. Test error handling: invalid config, API 401/500, malformed response
2. Add `pytest`, `responses` to requirements.txt (or separate test-requirements.txt)
3. Create `backlog/docs/doc-N - Jira-to-Backlog-Sync-Setup-and-Usage.md` — satisfies AC#3:
   a. Prerequisites (Python 3.x, pip)
   b. Installation (pip install -r requirements.txt)
   c. Configuration (YAML file fields, env var overrides)
   d. Usage examples (basic run, dry-run if implemented, JQL examples)
   e. Troubleshooting (common errors)
4. Register doc via backlog CLI if needed
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Depends on TASK-11 (already declared).

- 15 tests passing: config loading (5), dedup (3), filename (3), integration with mocked API (4)
- Created doc-7 usage guide
- Fixed Python 3.9 compat (added __future__ annotations)
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
