---
id: TASK-44
title: Write squash-consecutive-commits shell helper script
status: To Do
assignee: []
created_date: '2026-04-24 22:20'
updated_date: '2026-04-24 22:21'
labels:
  - git
  - agent
  - scripts
dependencies:
  - TASK-42
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Write a shell script squash-task-commits.sh (alongside milestone-helper.sh) that the git commit manager agent calls. The script reads the git log, identifies consecutive runs of commits with the same task-id prefix (format: task-<id>: ...), and squashes each consecutive run into a single commit. Non-consecutive occurrences of the same task-id are left independent. Uses git rebase --onto or git reset + commit to rewrite history cleanly.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
