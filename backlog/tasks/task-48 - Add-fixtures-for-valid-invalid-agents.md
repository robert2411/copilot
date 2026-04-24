---
id: task-48
title: Add fixtures for valid and invalid agents
status: To Do
assignee: []
labels: [tests,fixtures,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Create fixture agent files under `tests/agents/fixtures/` representing minimal valid agents and several invalid cases (parse error, missing fields, secret present) to drive unit tests.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `tests/agents/fixtures/` contains at least one valid and three invalid agent fixtures
- [ ] #2 Tests consume fixtures and assert expected failures

- [ ] #3 Fixtures are in `tests/agents/fixtures/` and used by shunit2 tests (bash)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Fixtures committed under tests/agents/fixtures

## Notes

Provide minimal valid and invalid agent fixtures in markdown under `tests/agents/fixtures/`. Tests will be shunit2-based and should reference fixtures by path.

<!-- DOD:END -->


