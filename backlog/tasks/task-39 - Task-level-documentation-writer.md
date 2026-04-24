---
id: task-39
title: Task-level documentation writer (sample run)
status: To Do
assignee: []
labels: [docs,automation]
milestone: Documentation Agent: verify & author docs
---

## Description

Define and implement the exact document the agent will produce per completed task. Create a sample run: choose one recently completed task and have the agent produce a doc in `backlog/docs/` summarising the change, files changed, usage notes, and links to ADRs; append a note to the originating task.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 Sample doc generated for one completed task with Summary, Files Changed, How to Use, and Links
- [ ] #2 Originating task updated with note: '✅ DOCS CREATED: <path>' or an explicit warning if manual review required
- [ ] #3 Agent output format specified in agent spec

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 Sample doc and task note committed
- [ ] #2 Example included in agent README

<!-- DOD:END -->

