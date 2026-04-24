---
id: TASK-35
title: Create agent file validation test suite
status: To Do
assignee: []
created_date: '2026-04-24 21:48'
labels:
  - testing
  - agents
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build a shunit2 bash test suite under tests/agents/ that discovers every .github/agents/*.agent.md file and validates it is a well-formed Copilot agent. Covers frontmatter schema, required fields, non-empty prompt body, and no raw secrets.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All .github/agents/*.agent.md files are discovered and tested
- [ ] #2 Each agent file is validated for required frontmatter fields: name, description, color, user-invocable
- [ ] #3 Each agent file is validated to have a non-empty prompt body (content after frontmatter)
- [ ] #4 Tests fail clearly when a field is missing or empty
- [ ] #5 Test runner script exits non-zero when any test fails
- [ ] #6 Tests use shunit2 consistent with existing test-milestone-helper.sh pattern
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
