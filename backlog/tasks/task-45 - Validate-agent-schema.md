---
id: task-45
title: Validate agent schema in tests
status: To Do
assignee: []
labels: [tests,agents,schema]
milestone: Milestone: Add agent validation tests
---

## Description

Define a minimal schema for Copilot agent files (required fields, types) and implement tests that validate each agent file against this schema, reporting missing/invalid fields.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Schema defined in tests (fields: id, name/title, system prompt, actions/subagents list if present)
- [ ] #2 Tests validate each agent against schema and report failures
- [ ] #3 Clear guidance in failure output listing missing fields

- [ ] #4 Tests implemented as shunit2 shell tests (e.g. `tests/agents/test_validate_agent_schema.sh`) and use `tests/agents/helpers.sh` to load files

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Schema and tests committed
- [ ] #2 Tests pass for known valid agents

## Notes

Schema validation will be performed by shell-based tests (shunit2) that call a small validator helper in `tests/agents/helpers.sh`. Test filename suggestion: `tests/agents/test_validate_agent_schema.sh`.

<!-- DOD:END -->


