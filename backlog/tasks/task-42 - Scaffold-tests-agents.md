---
id: task-42
title: Scaffold tests/agents directory and initial discovery test
status: To Do
assignee: []
labels: [tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Create `tests/agents/` and an initial test `tests/agents/test_discover_agents.py` (or .sh) that enumerates files under `.github/agents/` and asserts discovery returns at least one file.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `tests/agents/` directory created with initial test file
- [ ] #2 Discovery test lists files in `.github/agents/` and asserts count > 0
 - [ ] #3 Test runnable locally using shunit2 (bash); include example command in README (e.g. `bash tests/agents/test_discover_agents.sh`)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Files committed
- [ ] #2 README entry added describing how to run the discovery test

## Notes

Tests in this milestone should use shunit2 (bash) to match existing project tests (see `tests/skills/backlog-cli/test-milestone-helper.sh`). Initial helper and discovery test filenames:

- `tests/agents/helpers.sh` (bash helper functions)
- `tests/agents/test_discover_agents.sh` (discovery test using shunit2)

<!-- DOD:END -->


