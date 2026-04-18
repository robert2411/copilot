---
id: TASK-28
title: Create plan-reviewer agent or incorporate plan review into analyse
status: To Do
assignee: []
created_date: '2026-04-18 21:19'
milestone: Security Agent & Agent Pipeline Improvements
labels:
  - agent
  - analyse
  - manager
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add a plan review step between analyse and implementation. Either create a separate plan-reviewer agent that pokes holes in the plan and loops with analyse until approved, or incorporate a structured review into the analyse agent itself. Manager must route through plan review before routing to implementation. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A plan review step exists between analyse and implementation in the pipeline
- [ ] #2 Plan reviewer checks for: gaps in plan, unverified assumptions, ambiguous scope, missing error cases
- [ ] #3 Manager routes to plan review after analyse completes and before routing to implementation
- [ ] #4 Implementation only starts after plan review approves
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
