---
id: TASK-29
title: 'Fix Backlog CLI skill doc: document correct milestone assignment method'
status: To Do
assignee: []
created_date: '2026-04-19 20:04'
labels:
  - docs
  - backlog-skill
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The skill doc incorrectly implies milestone assignment can be done via CLI flag (--milestone). Validated: no such flag exists on task create or task edit. Must document the correct approach: edit task frontmatter directly to add milestone field, or set it in the milestone file itself.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Skill doc updated to remove any reference to --milestone CLI flag
- [ ] #2 Skill doc documents correct method: add 'milestone: <name>' to task frontmatter directly
- [ ] #3 Skill doc notes milestone CLI only supports: list and archive commands
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
