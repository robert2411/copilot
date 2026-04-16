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
- [ ] #4 Agent writes unit tests for all implemented code targeting 80%+ coverage per task
- [ ] #5 Combined test coverage across all milestone tasks meets 80% minimum
- [ ] #6 Agent checks all AC before handoff: backlog task edit <id> --check-ac for each criterion
- [ ] #7 Agent checks all DoD before handoff: backlog task edit <id> --check-dod for each item
- [ ] #8 Agent hands each completed task to QA and fixes all reported issues before committing
- [ ] #9 Agent adds final summary after QA approval using backlog task edit --final-summary
- [ ] #10 Agent commits with descriptive message and marks task Done using backlog task edit -s Done
- [ ] #11 Agent requests clarification from Analyse via --append-notes with question marker when blocked
- [ ] #12 After all milestone tasks done, agent reports completion to Manager
<!-- AC:END -->
