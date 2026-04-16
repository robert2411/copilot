---
id: TASK-4
title: Test the create-copilot-agent skill
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 07:25'
updated_date: '2026-04-16 08:35'
labels:
  - agents
  - skill
  - testing
milestone: Copilot Agent Creation Skill
dependencies:
  - TASK-3
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Manually invoke the create-copilot-agent skill to generate a sample agent (e.g. a code-reviewer agent). Verify the output is valid and complete against the anatomy checklist. Iterate on the skill prompt if gaps are found.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Sample agent generated using the skill
- [ ] #2 Generated agent passes the anatomy checklist from task-1
- [ ] #3 Generated agent frontmatter is valid and complete
- [ ] #4 Skill prompt updated with any gaps found during testing
<!-- AC:END -->
