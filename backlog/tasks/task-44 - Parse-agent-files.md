---
id: task-44
title: Parse agent files in tests and fail on parse errors
status: To Do
assignee: []
labels: [tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Add tests that attempt to parse each agent file under `.github/agents/` as YAML (or JSON if applicable) and fail the test if any file has parse errors.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Each file under `.github/agents/` is parsed without exception
- [ ] #2 Parser supports YAML and JSON agent file formats
- [ ] #3 Test outputs file name and parse error when failing

- [ ] #4 Tests implemented as shunit2 shell tests (e.g. `tests/agents/test_parse_agents.sh`) and use `tests/agents/helpers.sh` for file discovery

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Tests committed and pass locally

## Notes

Parser tests should be shell/shunit2-based to remain consistent with existing test-suite conventions. See `tests/agents/test_parse_agents.sh` as the canonical test file name.

<!-- DOD:END -->


