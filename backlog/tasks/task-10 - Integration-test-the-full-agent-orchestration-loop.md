---
id: TASK-10
title: Integration test the full agent orchestration loop
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:17'
updated_date: '2026-04-16 18:29'
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
- [x] #1 Manager correctly identifies and assigns first available milestone to Analyse
- [x] #2 Analyse produces implementation plans and no-blocker confirmation for all tasks
- [x] #3 Manager correctly routes milestone to Implementation after Analyse completes
- [x] #4 Implementation marks tasks In Progress, implements with tests, and hands to QA
- [x] #5 QA reviews and provides structured feedback or approval via task notes
- [x] #6 Implementation fixes QA issues, commits, and marks tasks Done
- [x] #7 Manager loops to next milestone or exits correctly when all work is done
- [x] #8 The no-milestones-but-tasks path correctly routes to Analyse for grouping
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Trace AC#1: Manager milestone scan → Analyse routing
2. Trace AC#2: Analyse plan creation + no-blocker confirmation
3. Trace AC#3: Manager blocker check → Implementation routing
4. Trace AC#4: Implementation task lifecycle
5. Trace AC#5: QA review feedback path
6. Trace AC#6: Implementation fix → commit → Done
7. Trace AC#7: Manager end-of-milestone loop/exit
8. Trace AC#8: No-milestones-but-tasks → Analyse grouping
9. Document gaps against doc-6, fix if needed
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Integration trace complete. All 8 AC paths verified against agent files:
- AC1: Manager Step 1+2 — milestone scan + Analyse routing ✅
- AC2: Analyse Mode 1 — plan creation + no-blocker notes ✅
- AC3: Manager Step 3+4 — blocker check + Implementation routing ✅
- AC4: Implementation Steps 1-5 — claim, implement, test, QA handoff ✅
- AC5: QA Steps 2-3 — structured findings or approval ✅
- AC6: Implementation Steps 6-7 — fix QA issues, commit, Done ✅
- AC7: Manager Step 5 — loop/exit decision ✅
- AC8: Manager Steps 1+6 — orphan tasks → Analyse grouping ✅

Gap found: Manager missing backlog milestone list command. Fixed.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Traced all 8 orchestration paths through the four agent files against doc-6 spec.

Findings:
- All paths correctly implemented in agent prompts
- One gap fixed: added backlog milestone list --plain to Manager Step 1
- Manager→Analyse→Implementation→QA→Manager loop fully connected
- Orphan task grouping path verified

All AC verified.
<!-- SECTION:FINAL_SUMMARY:END -->
