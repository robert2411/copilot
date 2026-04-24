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
- [ ] #2 Git commit manager agent receives task ID and task title to form the commit message
- [ ] #3 Manager marks task Done only after git commit manager emits commit-complete signal
- [ ] #4 Pipeline order in manager agent file updated: Implementation -> QA -> Security -> Documentation -> Git Commit -> Done
- [ ] #5 Manager passes --dry-run capability reference so agent can verify before writing history
<!-- AC:END -->
