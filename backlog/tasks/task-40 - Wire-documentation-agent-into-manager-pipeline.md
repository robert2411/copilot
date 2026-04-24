---
id: TASK-40
title: Wire documentation agent into manager pipeline
status: To Do
assignee: []
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:15'
labels:
  - documentation
  - agent
  - orchestration
dependencies:
  - TASK-39
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the manager agent to invoke the documentation agent after implementation and security are approved for each task. The documentation agent runs as the final step before marking a task Done, ensuring outcomes are persisted to backlog docs/decisions.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager invokes documentation agent via run_subagent after security approves each task
- [ ] #2 Documentation agent receives task ID, changed files, and final summary in the subagent call
- [ ] #3 Manager waits for documentation agent to emit doc-complete signal before marking task Done
- [ ] #4 Manager step 4b (after security) updated in agent file to include documentation step
- [ ] #5 Pipeline order documented: Implementation -> QA -> Security -> Documentation -> Done
<!-- AC:END -->
