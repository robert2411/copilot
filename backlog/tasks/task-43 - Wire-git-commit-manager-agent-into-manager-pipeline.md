---
id: TASK-43
title: Wire git commit manager agent into manager pipeline
status: To Do
assignee: []
created_date: '2026-04-24 22:20'
updated_date: '2026-04-24 22:21'
labels:
  - git
  - agent
  - orchestration
dependencies:
  - TASK-42
  - TASK-44
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the manager agent to invoke the git commit manager agent as the final step after documentation is complete for a task. The git commit manager ensures all changes (source, backlog, docs) are staged and committed with the canonical message, then calls squash-task-commits.sh to collapse any consecutive same-task commits in history.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager invokes git-commit-manager agent via run_subagent after documentation agent completes
<!-- AC:END -->
