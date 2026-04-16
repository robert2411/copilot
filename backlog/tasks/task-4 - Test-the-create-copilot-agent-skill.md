---
id: TASK-4
title: Test the create-copilot-agent skill
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 07:25'
updated_date: '2026-04-16 08:36'
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
- [x] #1 Sample agent generated using the skill
- [x] #2 Generated agent passes the anatomy checklist from task-1
- [x] #3 Generated agent frontmatter is valid and complete
- [x] #4 Skill prompt updated with any gaps found during testing
<!-- AC:END -->
