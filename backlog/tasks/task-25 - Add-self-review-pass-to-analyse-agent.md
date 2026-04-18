---
id: TASK-25
title: Add self-review pass to analyse agent
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-18 21:19'
updated_date: '2026-04-18 21:30'
labels:
  - agent
  - analyse
milestone: Security Agent & Agent Pipeline Improvements
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the analyse agent to perform a devil's advocate self-review of its own implementation plan before handing off to implementation. The self-review checks for gaps in AC coverage, unverified assumptions, ambiguous steps, and missing error handling. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Analyse agent performs a self-review pass of the implementation plan before signalling ready
- [x] #2 Self-review checks for: gaps in AC coverage, unverified assumptions, ambiguous steps, missing error handling
- [x] #3 Task notes updated with confirmation of self-review completion before handoff
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
