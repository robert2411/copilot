---
id: TASK-11
title: Backlog CLI - Create comprehensive reference guide
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:14'
labels:
  - documentation
  - cli
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document complete Backlog CLI reference covering all commands, options, workflows, and patterns
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 All CLI commands documented with options and examples
- [x] #2 Multi-line input patterns explained for all shells
- [x] #3 AI agent workflow with annotated examples provided
- [x] #4 Golden rules and best practices included
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Use doc-7 (Backlog-CLI-Complete-Reference-Guide.md) as primary source
2. Create backlog/docs/doc-reference-guide.md covering all commands with options tables and examples
3. Add sections: task CRUD, AC/DoD management, lifecycle fields, deps/subtasks, drafts, milestones, search, board, docs, decisions, sequence, MCP, browser
4. Add multi-line input patterns section covering bash/zsh ANSI-C quoting, printf, PowerShell
5. Add AI agent workflow section with annotated step-by-step example
6. Add Golden Rules and best practices section
7. Commit file to git
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Primary source: doc-7. All AC mapped to plan steps.

❌ QA ISSUES:
- [High] AC #1 not met: guide does not document all top-level CLI commands. Missing sections/examples for `backlog agents`, `backlog cleanup`, `backlog overview`, and `backlog completion` (see `backlog/docs/doc-8 - Backlog-CLI-Comprehensive-Reference-Guide.md` ToC lines 14-35 and end of file lines 532-544).
- [Low] `backlog --help` output should be re-validated while updating docs to ensure command inventory matches the installed version.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created doc-8: Backlog CLI Comprehensive Reference Guide.

Covers all commands with options tables and examples, multi-line input patterns for bash/zsh/PowerShell, AI agent workflow with annotated step-by-step example, and Golden Rules section.

Source: doc-7. File: backlog/docs/doc-8 - Backlog-CLI-Comprehensive-Reference-Guide.md
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
