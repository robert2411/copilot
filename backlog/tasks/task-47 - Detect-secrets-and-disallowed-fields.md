---
id: task-47
title: Detect secrets and disallowed fields in agent files
status: To Do
assignee: []
labels: [security,tests,agents]
milestone: Milestone: Add agent validation tests
---

## Description

Implement tests that scan agent files for obvious secrets (API keys, private key blocks) and disallowed fields. Fail tests if secrets or disallowed fields are found.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Scan detects common secret patterns (API keys, AWS keys, private key PEM blocks)
- [ ] #2 Disallowed fields list defined and tested (e.g., shell eval, raw exec commands)
- [ ] #3 Tests fail with filename and matched pattern details

- [ ] #4 Tests implemented as shunit2 shell tests (e.g. `tests/agents/test_scan_secrets.sh`) and use `tests/agents/helpers.sh` for file listing

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Tests committed and pass on a known-good repository

## Notes

Implement secrets scanning as a shell script invoked by shunit2 so patterns and outputs remain consistent with other project tests.

<!-- DOD:END -->


