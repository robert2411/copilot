---
id: TASK-8
title: Implement Implementation Agent
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:16'
updated_date: '2026-04-16 18:27'
labels:
  - implementation
  - orchestration
milestone: Agent Workflow Orchestration System
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
- [x] #1 Agent file created at .claude/agents/implementation.md with correct frontmatter and system prompt
- [x] #2 First action per task is: backlog task edit <id> -s 'In Progress' -a @myself
- [x] #3 Agent reads Analyse-provided implementation plan before writing any code
- [x] #4 Agent writes unit tests for all implemented code targeting 80%+ coverage per task
- [x] #5 Combined test coverage across all milestone tasks meets 80% minimum
- [x] #6 Agent checks all AC before handoff: backlog task edit <id> --check-ac for each criterion
- [x] #7 Agent checks all DoD before handoff: backlog task edit <id> --check-dod for each item
- [x] #8 Agent hands each completed task to QA and fixes all reported issues before committing
- [x] #9 Agent adds final summary after QA approval using backlog task edit --final-summary
- [x] #10 Agent commits with descriptive message and marks task Done using backlog task edit -s Done
- [x] #11 Agent requests clarification from Analyse via --append-notes with question marker when blocked
- [x] #12 After all milestone tasks done, agent reports completion to Manager
<!-- AC:END -->
