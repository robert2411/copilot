---
id: TASK-11
title: Backlog CLI - Create comprehensive reference guide
status: To Do
assignee: []
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:07'
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
- [ ] #1 All CLI commands documented with options and examples
- [ ] #2 Multi-line input patterns explained for all shells
- [ ] #3 AI agent workflow with annotated examples provided
- [ ] #4 Golden rules and best practices included
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

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
