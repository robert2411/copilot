---
id: TASK-39
title: Create documentation agent file
status: To Do
assignee: []
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:14'
labels:
  - documentation
  - agent
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the documentation agent that runs after implementation completes. The agent inspects each completed task's final summary, implementation notes, and changed files, then ensures all significant decisions, patterns, and outcomes are captured in backlog/docs or backlog/decisions. If a relevant doc/decision already exists it updates it; otherwise it creates a new one.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file exists at .github/agents/documentation.agent.md with correct frontmatter
- [ ] #2 Agent reads completed task details via backlog task <id> --plain
- [ ] #3 Agent lists existing docs via backlog doc list --plain and scans backlog/decisions/
- [ ] #4 Agent updates an existing doc when the content is relevant to a completed task
- [ ] #5 Agent creates a new backlog doc when no relevant doc exists
<!-- AC:END -->
