---
id: task-51
title: Document tests/agents usage and troubleshooting
status: To Do
assignee: []
labels: [docs,tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Add `tests/agents/README.md` documenting how to run the agent validation tests locally, interpret failures, and update fixtures. Include quick CI troubleshooting steps.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 README includes run commands and expected output
- [ ] #2 Troubleshooting tips for common failures (parse, schema, secrets)

- [ ] #3 README documents how to run shunit2-based tests locally (example: `bash tests/agents/test_discover_agents.sh`) and in CI

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 README committed under tests/agents

## Notes

README should include exact commands to run the shunit2 shell tests, how to install shunit2 on macOS and Debian/Ubuntu, and how to interpret typical failures.

<!-- DOD:END -->


