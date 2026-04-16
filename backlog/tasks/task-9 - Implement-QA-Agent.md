---
id: TASK-9
title: Implement QA Agent
status: To Do
assignee: []
created_date: '2026-04-16 18:16'
updated_date: '2026-04-16 18:17'
labels:
  - qa
  - orchestration
dependencies:
  - TASK-8
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the QA agent file that reviews completed tasks before they are committed. QA receives a task from the Implementation agent, reads it via backlog task --plain, verifies all AC and DoD are ticked, then reviews the code for: duplication, general quality, spelling/documentation errors, and security issues. Reports findings via --append-notes. Approves or requests rework.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file created at .claude/agents/qa.md with correct frontmatter and system prompt
<!-- AC:END -->
