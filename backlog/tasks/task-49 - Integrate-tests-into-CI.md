---
id: task-49
title: Integrate tests/agents into CI
status: To Do
assignee: []
labels: [ci,tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Add or update CI workflow to run `pytest tests/agents` (or the chosen test command) on push and pull requests. Ensure failures block merges.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 CI workflow runs tests/agents on push and PR
- [ ] #2 Failures mark job as failed and are visible in PR checks
- [ ] #3 Workflow documentation updated with run instructions

- [ ] #4 CI runs shunit2-based tests by invoking the shell test files (example step: `bash tests/agents/test_discover_agents.sh`)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Workflow committed and job appears in CI runs

## Notes

CI integration should call the same shunit2 shell test scripts used locally. Example job step:

  - name: Run agent validation tests
	run: |
	  bash tests/agents/test_discover_agents.sh
	  bash tests/agents/test_parse_agents.sh
	  bash tests/agents/test_validate_agent_schema.sh

Ensure the runner has shunit2 installed or fetches it in the workflow before running tests.

<!-- DOD:END -->


