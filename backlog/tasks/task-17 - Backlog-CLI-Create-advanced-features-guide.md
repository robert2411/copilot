---
id: TASK-17
title: Backlog CLI - Create advanced features guide
status: Done
assignee:
  - '@implementation'
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:40'
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
- [x] #1 Search functionality and fuzzy matching patterns explained
- [x] #2 Board visualization and export options (markdown, README)
- [x] #3 Dependency sequences and topological ordering
- [x] #4 Draft workflow and promotion patterns
- [x] #5 Configuration management (set/get/list)
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Source: doc-7 sections Search, Board, Sequence, Drafts, Milestones, Config.

✅ QA APPROVED
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created doc-14: Backlog CLI Advanced Features Guide.

Covers search (fuzzy matching, all filters, practical patterns), board visualization and export (terminal kanban, markdown export, README injection), dependency sequences (topological sort, sprint planning usage), draft workflow (create/list/promote/demote), milestone management (list, assign, archive), and configuration management (get/set/list, key fields table).

File: backlog/docs/doc-14 - Backlog-CLI-Advanced-Features-Guide.md
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
