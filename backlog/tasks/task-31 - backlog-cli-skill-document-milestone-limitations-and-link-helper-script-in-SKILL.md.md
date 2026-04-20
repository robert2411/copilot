---
id: TASK-31
title: >-
  backlog-cli skill: document milestone limitations and link helper script in
  SKILL.md
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
labels:
  - backlog-cli
  - skills
  - docs
dependencies:
  - TASK-30
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SKILL.md currently notes milestone CLI limitations inline but does not reference the helper script or scripts/ folder. This task adds a scripts/ reference and proper documentation of the workaround pattern, linking to milestone-helper.sh once task-30 is complete.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 SKILL.md Milestones section references the scripts/ folder and milestone-helper.sh
- [ ] #2 SKILL.md explains the two operations the script covers: create milestone and assign task to milestone
- [ ] #3 A scripts/ folder exists at .github/skills/backlog-cli/scripts/ and is referenced from the SKILL.md resources/links section
- [ ] #4 References section at bottom of SKILL.md includes milestone-helper.sh link
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
