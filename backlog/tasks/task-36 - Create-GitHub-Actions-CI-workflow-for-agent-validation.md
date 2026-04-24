---
id: TASK-36
title: Create GitHub Actions CI workflow for agent validation
status: To Do
assignee: []
created_date: '2026-04-24 21:48'
labels:
  - ci
  - testing
  - agents
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add a GitHub Actions workflow (.github/workflows/validate-agents.yml) that runs the agent validation test suite on every push and pull request. Ensures no malformed agent files can be merged.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Workflow file exists at .github/workflows/validate-agents.yml
- [ ] #2 Workflow triggers on push and pull_request to main branch
- [ ] #3 Workflow installs shunit2 and runs tests/agents/test-agents.sh
- [ ] #4 Workflow fails the build when any agent validation test fails
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
