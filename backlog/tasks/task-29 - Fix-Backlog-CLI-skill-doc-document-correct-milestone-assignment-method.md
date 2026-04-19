---
id: TASK-29
title: 'Fix Backlog CLI skill doc: document correct milestone assignment method'
status: To Do
assignee: []
created_date: '2026-04-19 20:04'
updated_date: '2026-04-19 20:07'
labels:
  - docs
  - backlog-skill
milestone: Backlog Skill Doc Fixes
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

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open SKILL.md at .github/skills/backlog-cli/SKILL.md
2. AC1 — Search for any "--milestone" flag references in task create/edit examples or tables; remove them if found (none visible in current doc, but confirm with grep)
3. AC2 — Clarify the "Golden rule" on line 38 which states "Never edit task .md files directly" — add an explicit exception note: milestone assignment is done by adding `milestone: <name>` to task frontmatter directly (since no CLI flag exists for this)
4. AC2 — In the Milestones section, ensure the frontmatter example is clear and prominent: show a code block with `milestone: <name>` in YAML frontmatter
5. AC3 — Ensure the Milestones section clearly states that the `backlog milestone` CLI only supports `list` and `archive` commands (no `create`, no task-assignment flags)
6. AC3 — Add a note in the Task Content Reference table (or the Milestones section) that milestone is set via frontmatter, not a CLI flag
7. Verify no other section (Task Lifecycle, AI Agent Patterns, Troubleshooting) introduces a --milestone flag by grepping the file
8. Commit changes to git (Definition of Done)
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
