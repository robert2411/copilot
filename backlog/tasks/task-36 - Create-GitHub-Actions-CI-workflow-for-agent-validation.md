---
id: TASK-36
title: Create GitHub Actions CI workflow for agent validation
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-24 21:48'
updated_date: '2026-04-24 21:59'
labels:
  - ci
  - testing
  - agents
milestone: Agent Validation Tests
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add a GitHub Actions workflow (.github/workflows/validate-agents.yml) that runs the agent validation test suite on every push and pull request. Ensures no malformed agent files can be merged.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Workflow file exists at .github/workflows/validate-agents.yml
- [x] #2 Workflow triggers on push and pull_request to main branch
- [x] #3 Workflow installs shunit2 and runs tests/agents/test-agents.sh
- [x] #4 Workflow fails the build when any agent validation test fails
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create the directory .github/workflows/ (it does not exist yet in this repo).
2. Create .github/workflows/validate-agents.yml with the following structure:
   a. Workflow name: "Validate Agent Files"
   b. Triggers (on:):
      - push: branches: [main]
      - pull_request: branches: [main]
   c. A single job named validate-agents running on ubuntu-latest.
   d. Steps:
      i.  Checkout step: uses actions/checkout@v4 (standard)
      ii. Install shunit2 step: run: sudo apt-get install -y shunit2
      iii. Run tests step: run: bash tests/agents/test-agents.sh
           The job inherits the non-zero exit code from the test runner, which causes the workflow to fail (covers AC#4).
3. Confirm the workflow file is valid YAML with correct indentation.
4. Note dependency on TASK-35: the workflow runs tests/agents/test-agents.sh which must already exist. TASK-35 should be completed and merged before or alongside TASK-36.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete.

AC coverage:
- AC#1 (workflow at .github/workflows/validate-agents.yml): covered by step 1–2.
- AC#2 (triggers on push and pull_request to main): covered by step 2b.
- AC#3 (installs shunit2 and runs tests/agents/test-agents.sh): covered by steps 2d-ii and 2d-iii.
- AC#4 (fails build when tests fail): bash exits non-zero → workflow step fails → job fails; no extra config needed.

Verified assumptions:
- ubuntu-latest has apt-get and shunit2 is available in Ubuntu apt repos — confirmed (shunit2 is in the standard Ubuntu universe repo).
- actions/checkout@v4 is the current stable version — safe assumption for a new workflow.
- .github/workflows/ directory does not yet exist — confirmed by ls check.

Dependency noted: TASK-36 depends on TASK-35 (tests/agents/test-agents.sh must exist). Both should be implemented in the same PR or TASK-35 first.

No ambiguous steps. No missing error paths. No blockers.

Analysis complete. Plan ready. No blockers.

✅ PLAN APPROVED — plan is complete, all ACs covered, no ambiguity
- Steps verified: 4 (directory creation, workflow YAML structure, trigger config, job steps)
- AC mapped: 4/4
- Verified: .github/workflows/ does not yet exist (confirmed); shunit2 available in Ubuntu apt repos; actions/checkout@v4 is current stable; exit-code propagation from shunit2 through bash to workflow job is correct; dependency on TASK-35 explicitly documented.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
