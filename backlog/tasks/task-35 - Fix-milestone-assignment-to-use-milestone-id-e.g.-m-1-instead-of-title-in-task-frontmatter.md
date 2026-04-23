---
id: TASK-35
title: >-
  Fix milestone assignment to use milestone id (e.g. m-1) instead of title in
  task frontmatter
status: To Do
assignee: []
created_date: '2026-04-23 09:28'
labels: []
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently, the script assigns milestones to tasks using the milestone title (e.g. 'Research: Jira API & Backlog CLI'), but the UI expects the milestone id (e.g. 'm-1'). Update the script so that when assigning a milestone to a task, it uses the milestone id in the 'milestone:' field in the task frontmatter, ensuring consistency with the UI and other tools.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Script assigns milestone using milestone id (e.g. m-1) in task frontmatter
- [ ] #2 Milestone assignment is consistent between CLI, UI, and scripts
- [ ] #3 Regression tests for milestone assignment pass
- [ ] #4 Documentation updated if needed
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
