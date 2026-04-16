---
id: TASK-17
title: Backlog CLI - Create advanced features guide
status: To Do
assignee: []
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:11'
labels:
  - documentation
  - advanced
milestone: Backlog CLI Documentation
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document advanced features: search, board export, sequences, milestones, drafts, and configuration
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Search functionality and fuzzy matching patterns explained
- [ ] #2 Board visualization and export options (markdown, README)
- [ ] #3 Dependency sequences and topological ordering
- [ ] #4 Draft workflow and promotion patterns
- [ ] #5 Configuration management (set/get/list)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 sections: Search, Board, Sequence, Draft Management, Milestone Management, Configuration
2. Create backlog/docs/advanced-features-guide.md
3. Search section: backlog search with fuzzy matching, --type, --status, --priority filters; --plain for AI output
4. Board section: backlog board (terminal kanban), backlog browser (web UI), board export to markdown/README
5. Sequence section: backlog sequence command, topological sort of dependencies, how to read output
6. Draft workflow: backlog task create --draft, backlog draft list, backlog task promote, use cases for drafts
7. Configuration: backlog config get/set/list, key config fields (statuses, DoD defaults, zero-padded-ids, web-port)
8. Milestones: create, assign tasks, view milestone progress
9. Commit file to git
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
