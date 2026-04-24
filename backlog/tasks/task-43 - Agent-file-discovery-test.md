---
id: task-43
title: Implement agent file discovery test
status: To Do
assignee: []
labels: [tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Implement a test that enumerates files in `.github/agents/` and fails if the directory is missing or empty. Provide clear failure output listing expected path and suggestions.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Test enumerates `.github/agents/` and asserts at least one file
- [ ] #2 Failure message explains how to add agents or locate path
 - [ ] #3 Test implemented as a shunit2 shell test: `tests/agents/test_discover_agents.sh`
 - [ ] #4 Test uses `tests/agents/helpers.sh` for common path resolution

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Test committed and passes locally

## Notes

Use shunit2 (bash) for tests to match existing test style. Discovery test name: `tests/agents/test_discover_agents.sh`.

<!-- DOD:END -->


