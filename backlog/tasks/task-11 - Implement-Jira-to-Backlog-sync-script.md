---
id: TASK-11
title: Implement Jira-to-Backlog sync script
status: To Do
assignee: []
created_date: '2026-04-16 18:51'
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
- [ ] #1 Reads config from external YAML or env vars
- [ ] #2 Queries Jira REST API with configured JQL
- [ ] #3 Creates milestone per Jira issue with jira_key in frontmatter
- [ ] #4 Skips if jira_key exists already (idempotent)
- [ ] #5 Logs created and skipped milestones
- [ ] #6 requirements.txt with dependencies
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
