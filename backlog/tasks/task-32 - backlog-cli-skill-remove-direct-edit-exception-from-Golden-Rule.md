---
id: TASK-32
title: 'backlog-cli skill: remove direct-edit exception from Golden Rule'
status: To Do
assignee: []
created_date: '2026-04-20 21:07'
labels:
  - backlog-cli
  - skills
  - docs
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SKILL.md currently has an Exception callout under the Golden Rule (around line 40) that permits direct frontmatter editing for milestone assignment. This is no longer needed — milestone-helper.sh now covers both milestone creation and task assignment. The exception should be removed and replaced with a reference to the two supported methods: (1) backlog CLI commands, (2) milestone-helper.sh script.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Exception callout under the Golden Rule is removed from SKILL.md
- [ ] #2 Golden Rule section states only two supported methods: backlog CLI commands and milestone-helper.sh
- [ ] #3 Reference or link to .github/skills/backlog-cli/scripts/milestone-helper.sh is present near the Golden Rule section
- [ ] #4 No other location in SKILL.md instructs the reader to edit task or milestone files directly
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
