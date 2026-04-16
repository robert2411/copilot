---
id: TASK-15
title: Backlog CLI - Create best practices documentation
status: To Do
assignee: []
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:11'
labels:
  - documentation
  - best-practices
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document best practices, patterns, and anti-patterns for using Backlog CLI effectively
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Phase discipline guide (create → implement → complete)
- [ ] #2 AC writing best practices and examples
- [ ] #3 Multi-task workflow patterns documented
- [ ] #4 Common anti-patterns and how to avoid them
- [ ] #5 Git integration and branching strategies with Backlog
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 Golden Rules and AI Agent Workflow sections; read AGENTS.md for phase discipline patterns
2. Create backlog/docs/best-practices.md
3. Phase discipline section: creation (title/desc/AC only) -> In Progress (plan) -> implementation (notes) -> done (final-summary, AC checks, status)
4. AC writing best practices: outcome-oriented, testable, user-focused; good vs bad examples from doc-7
5. Multi-task workflow patterns: dependency ordering, board usage, search-driven triage
6. Anti-patterns section: direct file editing, skipping plan, marking Done without all ACs, mixing phases
7. Git integration: how backlog commits on every CLI write, branch-aware task states, check-branches config
8. Commit file to git
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Sources: doc-7 Golden Rules + AI Workflow, AGENTS.md phase discipline.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
