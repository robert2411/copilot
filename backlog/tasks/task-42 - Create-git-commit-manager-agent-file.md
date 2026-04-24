---
id: TASK-42
title: Create git commit manager agent file
status: To Do
assignee: []
created_date: '2026-04-24 22:19'
updated_date: '2026-04-24 22:20'
labels:
  - git
  - agent
  - commits
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the git commit manager agent responsible for guaranteeing clean git history per task. After a task is fully done (Implementation + QA + Security + Documentation approved), this agent: (1) stages ALL unstaged/untracked changes including backlog/, docs, and source files, (2) commits with the canonical message format 'task-<id>: <title>', (3) inspects the recent git log for consecutive commits belonging to the same task-id and squashes them into one — but only consecutive runs; if another task's commit sits between two task-<id> commits they are NOT squashed.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file exists at .github/agents/git-commit-manager.agent.md with correct frontmatter
- [ ] #2 Agent stages all changes (git add -A) before committing, including backlog/ and docs/
- [ ] #3 Agent commits using canonical format: 'task-<id>: <title>'
- [ ] #4 Agent parses recent git log to detect consecutive commits sharing the same task-id prefix
- [ ] #5 Agent squashes consecutive same-task commits into a single commit via git rebase -i or reset+commit
- [ ] #6 Agent does NOT squash non-consecutive same-task commits (another task commit in between preserves the boundary)
- [ ] #7 Squash example: [task1, task1, task3, task1] becomes [task1, task3, task1]
- [ ] #8 Squash example: [task1, task1, task1, task3] becomes [task1, task3]
<!-- AC:END -->
