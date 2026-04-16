---
id: TASK-6
title: Implement Manager Agent
status: To Do
assignee: []
created_date: '2026-04-16 18:14'
updated_date: '2026-04-16 18:14'
labels: []
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the Manager agent file that orchestrates the full workflow. The Manager scans the backlog for the next available milestone, routes it to the Analyse agent, then hands off to Implementation when analysis is complete. After implementation it decides: loop to next milestone, ask Analyse to group orphan tasks into milestones, or exit when all work is done. See doc-6 for full workflow spec.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
