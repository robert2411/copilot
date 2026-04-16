---
id: TASK-8
title: Implement Implementation Agent
status: To Do
assignee: []
created_date: '2026-04-16 18:16'
updated_date: '2026-04-16 18:16'
labels:
  - implementation
  - orchestration
dependencies:
  - TASK-7
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the Implementation agent file that executes tasks one by one within a milestone. For each task: mark In Progress, read plan from Analyse, implement code with unit tests (min 80% coverage), verify all AC and DoD, hand off to QA, fix issues from QA, add final summary, commit, mark Done. If missing info, request from Analyse. Report milestone completion to Manager.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file created at .claude/agents/implementation.md with correct frontmatter and system prompt
- [ ] #2 First action per task is: backlog task edit <id> -s 'In Progress' -a @myself
- [ ] #3 Agent reads Analyse-provided implementation plan before writing any code
<!-- AC:END -->
