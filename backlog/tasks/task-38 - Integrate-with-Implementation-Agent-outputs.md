---
id: task-38
title: Integrate with Implementation Agent outputs
status: To Do
assignee: []
labels: [integration,agents]
milestone: Documentation Agent: verify & author docs
---

## Description

Define how the Documentation Agent consumes Implementation Agent outputs. Include parsing rules for FINAL_SUMMARY sections, preferred inputs (final summary vs git diff vs PR metadata), and fallback order. Provide sample commands to call from the pipeline.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Integration spec references FINAL_SUMMARY marker format and git diff usage
- [ ] #2 Fallback behavior defined (summary → PR metadata → git diff)
- [ ] #3 Example command sequences for creating docs/ADRs documented

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Integration spec committed and referenced from agent spec
- [ ] #2 Sample run documented with expected outputs

<!-- DOD:END -->

