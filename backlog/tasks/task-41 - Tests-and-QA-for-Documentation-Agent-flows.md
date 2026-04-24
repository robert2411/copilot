---
id: task-41
title: Tests and QA for Documentation Agent flows
status: To Do
assignee: []
labels: [tests,qa]
milestone: Documentation Agent: verify & author docs
---

## Description

Add unit and integration tests for the Documentation Agent: parsing FINAL_SUMMARY, mapping rules, template rendering, CLI command sequences, and one end-to-end sample where a missing doc/ADR is created and task notes are updated.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Tests defined for parsing FINAL_SUMMARY and git-diff mapping
- [ ] #2 Template rendering tested with example inputs
- [ ] #3 One E2E integration test demonstrating doc/ADR creation and task-note update

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Tests added to `tests/` and runnable locally
- [ ] #2 CI configuration updated (or CI test instructions added)

<!-- DOD:END -->

