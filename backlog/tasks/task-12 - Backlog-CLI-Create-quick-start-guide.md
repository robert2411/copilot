---
id: TASK-12
title: Backlog CLI - Create quick-start guide
status: To Do
assignee: []
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:07'
labels:
  - documentation
  - guide
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Write an introductory guide for users new to Backlog CLI with common workflows
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Installation and initialization steps documented
- [ ] #2 5-10 most common workflows with examples provided
- [ ] #3 Troubleshooting section for common issues
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 installation and initialization sections
2. Create backlog/docs/quick-start-guide.md
3. Document: install via npm/brew, backlog init options, project structure
4. Write 5-10 common workflows: create task, list/view, edit status, manage AC, search, board view, archive
5. Each workflow: one-liner description + minimal CLI example
6. Add troubleshooting section: task not found, AC index errors, metadata sync issues (map from doc-7 Common Issues)
7. Commit file to git
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
