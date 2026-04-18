---
id: TASK-24
title: Update manager agent to route through security after QA approves
status: To Do
assignee: []
created_date: '2026-04-18 21:19'
labels:
  - agent
  - manager
  - security
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the manager agent to include a security audit gate in the pipeline. After QA emits its approval signal, manager routes the task to the security agent. If security finds issues, manager routes to implementation to fix, then back to QA, then back to security for re-audit. Task is only marked Done after security approves. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager routes each task to security agent after QA emits ✅ QA APPROVED signal
- [ ] #2 After security findings, manager routes back to implementation with findings list
- [ ] #3 After implementation fixes, manager routes back to QA for re-verification
- [ ] #4 After QA re-approves, manager routes back to security for scoped re-audit
- [ ] #5 Manager only marks task Done after security approves (verdict: approved or empty findings)
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
