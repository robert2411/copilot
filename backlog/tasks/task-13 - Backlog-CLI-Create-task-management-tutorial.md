---
id: TASK-13
title: Backlog CLI - Create task management tutorial
status: To Do
assignee: []
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:10'
labels:
  - documentation
  - tutorial
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create detailed tutorial on managing tasks: creation, editing, acceptance criteria, DoD, and lifecycle
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Step-by-step tutorial for creating tasks with all options
- [ ] #2 Guide for editing and managing task lifecycle fields
- [ ] #3 Examples of AC and DoD management patterns
- [ ] #4 Tutorial on dependencies and subtasks
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 task management sections: Creating, Editing, AC, DoD, Lifecycle, Dependencies
2. Create backlog/docs/task-management-tutorial.md as a guided walkthrough
3. Step-by-step tutorial: backlog task create with all flags (-d, --ac, -l, -a, --priority, --ref, --doc)
4. Editing tutorial: status transitions, assignee, labels, plan, notes, final-summary
5. AC management: add, check, uncheck, remove; include multi-AC single-command patterns
6. DoD management: add, check, uncheck, remove; link to project-level DoD config
7. Dependencies: --dep flag, subtask creation with -p, backlog sequence output
8. Include concrete before/after examples for each operation
9. Commit file to git
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
