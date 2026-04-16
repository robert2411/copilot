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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Generated code-reviewer agent using the create-copilot-agent skill process.

Sample agent: .claude/agents/code-reviewer.md
Verified against anatomy checklist (doc-4 §5): all 10 items pass.
- Frontmatter valid (name, description with triggers, color)
- System prompt: persona, requirements gathering, tool usage (doc-2 best practices), output format (Markdown review report via show_content), hard constraints
- Self-contained
No gaps found — create-copilot-agent skill prompt requires no updates.
<!-- SECTION:FINAL_SUMMARY:END -->
