---
id: task-50
title: Add test harness utilities for agent validation tests
status: To Do
assignee: []
labels: [tests,utils,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Add helper utilities under `tests/agents/helpers.py` (or .sh) to load agent files, normalize fields, and provide consistent error reporting for tests.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Helper module provides functions to load and validate agent files
- [ ] #2 Helpers used by discovery, parse, schema, and secrets tests

- [ ] #3 Helpers implemented as a bash helper script `tests/agents/helpers.sh` and intended for use from shunit2 tests

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Helpers committed and referenced by tests

## Notes

Create `tests/agents/helpers.sh` providing common functions (file discovery, frontmatter extraction, simple validators) that all shunit2 tests can source.

<!-- DOD:END -->


