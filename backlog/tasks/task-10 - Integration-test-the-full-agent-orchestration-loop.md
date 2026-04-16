---
id: TASK-10
title: Integration test the full agent orchestration loop
status: To Do
assignee: []
created_date: '2026-04-16 18:17'
updated_date: '2026-04-16 18:17'
labels:
  - integration
  - orchestration
milestone: Agent Workflow Orchestration System
dependencies:
  - TASK-9
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Run the full orchestration loop end-to-end to validate all four agents work together correctly. Use a real milestone with at least 2 tasks as a test case. Verify the complete flow: Manager → Analyse → Implementation → QA → Manager. Document any gaps or mismatches found against doc-6.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager correctly identifies and assigns first available milestone to Analyse
- [ ] #2 Analyse produces implementation plans and no-blocker confirmation for all tasks
- [ ] #3 Manager correctly routes milestone to Implementation after Analyse completes
- [ ] #4 Implementation marks tasks In Progress, implements with tests, and hands to QA
- [ ] #5 QA reviews and provides structured feedback or approval via task notes
- [ ] #6 Implementation fixes QA issues, commits, and marks tasks Done
- [ ] #7 Manager loops to next milestone or exits correctly when all work is done
- [ ] #8 The no-milestones-but-tasks path correctly routes to Analyse for grouping
<!-- AC:END -->
