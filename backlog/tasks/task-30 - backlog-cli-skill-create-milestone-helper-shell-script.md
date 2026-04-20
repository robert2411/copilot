---
id: TASK-30
title: 'backlog-cli skill: create milestone helper shell script'
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
labels:
  - backlog-cli
  - skills
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The backlog CLI has no milestone create command and no --milestone flag for task create/edit. Milestone files must be created manually and task milestone assignment requires direct frontmatter editing. A helper shell script should be added to the backlog-cli skill's scripts/ folder to automate both operations.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Script supports creating a new milestone file in backlog/milestones/ with correct frontmatter (id, title, description, status, created_date)
- [ ] #2 Script supports assigning an existing task to a milestone by patching the task file's frontmatter milestone field
- [ ] #3 Script is placed at .github/skills/backlog-cli/scripts/milestone-helper.sh
- [ ] #4 Script is executable and includes usage instructions as inline comments
- [ ] #5 Script handles edge cases: duplicate milestone names, missing task file, invalid task ID
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
