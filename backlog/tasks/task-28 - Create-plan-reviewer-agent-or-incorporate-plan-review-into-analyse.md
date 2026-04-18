---
id: TASK-28
title: Create plan-reviewer agent or incorporate plan review into analyse
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-18 21:19'
updated_date: '2026-04-18 21:32'
labels:
  - agent
  - analyse
  - manager
milestone: Security Agent & Agent Pipeline Improvements
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add a plan review step between analyse and implementation. Either create a separate plan-reviewer agent that pokes holes in the plan and loops with analyse until approved, or incorporate a structured review into the analyse agent itself. Manager must route through plan review before routing to implementation. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 A plan review step exists between analyse and implementation in the pipeline
- [x] #2 Plan reviewer checks for: gaps in plan, unverified assumptions, ambiguous scope, missing error cases
- [x] #3 Manager routes to plan review after analyse completes and before routing to implementation
- [x] #4 Implementation only starts after plan review approves
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created .github/agents/plan-reviewer.agent.md — independent plan audit agent that loops with Analyse via Manager until zero concerns. Updated manager agent: added Step 3b (plan review gate before implementation), added plan-reviewer to sub-agents list.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
