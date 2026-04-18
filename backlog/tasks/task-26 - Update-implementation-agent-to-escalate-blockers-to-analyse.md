---
id: TASK-26
title: Update implementation agent to escalate blockers to analyse
status: Done
assignee:
  - '@implementation'
created_date: '2026-04-18 21:19'
updated_date: '2026-04-18 21:30'
labels:
  - agent
  - implementation
milestone: Security Agent & Agent Pipeline Improvements
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the implementation agent to explicitly escalate unexpected situations to analyse (via manager) rather than guessing or skipping. When implementation hits something not covered by the plan, it flags a blocker in task notes and signals manager to route back to analyse for clarification before resuming. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Implementation agent explicitly flags blockers in task notes when hitting unexpected situations during coding
- [x] #2 Implementation agent does NOT guess or skip — it stops and escalates
- [x] #3 Agent instructions include an escalation step: signal manager to route back to analyse with blocker description
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Replaced passive 'Requesting Clarification' section with explicit 'Blocker Escalation' workflow. Added clear stop/flag/escalate/resume loop. Includes examples of when to and when not to escalate.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
