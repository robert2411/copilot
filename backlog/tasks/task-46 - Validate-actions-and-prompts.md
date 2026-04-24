---
id: task-46
title: Validate actions, prompts, and capabilities
status: To Do
assignee: []
labels: [tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Add tests verifying agent actions, capabilities, and prompt templates follow expected conventions: action ids present, prompts non-empty, noop placeholders flagged.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Each action has an id and non-empty name/description if present
- [ ] #2 System prompt and key prompts are non-empty strings
- [ ] #3 Tests flag suspicious placeholder prompts (e.g., "TODO", "<insert prompt>")

- [ ] #4 Tests implemented as shunit2 shell tests (e.g. `tests/agents/test_validate_prompts.sh`) and use helpers in `tests/agents/helpers.sh`

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Tests committed and used by test suite

## Notes

Prompt and action checks should be implemented in bash/shunit2 tests to match the project's testing approach.

<!-- DOD:END -->


