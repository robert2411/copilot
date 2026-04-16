---
id: TASK-20
title: Backlog CLI skill - Write usage documentation
status: To Do
assignee: []
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:49'
labels:
  - documentation
  - skill
milestone: Backlog CLI Skill
dependencies:
  - TASK-19
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create final documentation on how to use the Backlog CLI skill, including examples and integration
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Skill installation and activation documented
- [ ] #2 Common use patterns with examples provided
- [ ] #3 Troubleshooting guide created
- [ ] #4 Contributing guidelines for skill improvements
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Confirm task-19 is Done; collect any gaps or corrections noted during testing
2. Create doc file at .github/skills/backlog-cli/references/USAGE.md (or backlog/docs/doc-15)
3. Section: Installation & Activation — how to place skill in .github/skills/, how Copilot picks it up, required backlog CLI install
4. Section: Common Use Patterns with examples:
   - Full task lifecycle (create → in progress → done)
   - AC/DoD workflows with exact CLI flags
   - Multi-shell newline patterns ($\\, printf, PowerShell)\n   - Search and board commands\n   - MCP server usage\n5. Section: Troubleshooting — table of issues/solutions drawn from task-19 findings and doc-12 best practices\n6. Section: Contributing — how to update SKILL.md, what sections to extend, validation checklist from make-skill-template\n7. Review doc for accuracy against skill content; cross-link to backlog/docs/doc-7 through doc-14\n8. git commit
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
