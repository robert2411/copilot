---
id: TASK-41
title: Update implementation agent to signal documentation agent on task completion
status: To Do
assignee: []
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:15'
labels:
  - documentation
  - agent
  - implementation
dependencies:
  - TASK-39
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the implementation agent system prompt so it knows the documentation agent runs after security approval. The implementation agent should pass the task ID, list of changed files, and final summary to the manager for routing to documentation.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Implementation agent constraints updated to not mark task Done until documentation step is complete
- [ ] #2 Implementation agent final-summary step notes that summary will be passed to documentation agent
- [ ] #3 Implementation agent sub-agent delegation section lists documentation agent role
<!-- AC:END -->
