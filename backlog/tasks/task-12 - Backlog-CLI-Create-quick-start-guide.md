---
id: TASK-12
title: Backlog CLI - Create quick-start guide
status: Done
assignee:
  - '@implementation'
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:18'
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
- [x] #1 Installation and initialization steps documented
- [x] #2 5-10 most common workflows with examples provided
- [x] #3 Troubleshooting section for common issues
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Source: doc-7 sections Installation, Task Management, Common Issues.

❌ QA ISSUES:
- [Medium] Broken Next Steps references in `backlog/docs/doc-9 - Backlog-CLI-Quick-Start-Guide.md` lines 213-215: docs `doc-10`, `doc-13`, and `doc-14` are referenced but do not exist in `backlog/docs/`. This creates dead links for readers.

✅ QA APPROVED
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created doc-9: Backlog CLI Quick-Start Guide.

Covers installation (npm/brew), backlog init, project structure, 10 common workflows with examples, and troubleshooting section for common issues.

File: backlog/docs/doc-9 - Backlog-CLI-Quick-Start-Guide.md
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
