---
id: TASK-7
title: Implement Analyse Agent
status: To Do
assignee: []
created_date: '2026-04-16 18:15'
updated_date: '2026-04-16 18:15'
labels:
  - analyse
  - orchestration
dependencies:
  - TASK-6
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the Analyse agent file responsible for planning and blocker detection. The Analyse agent receives a milestone from the Manager, reads all tasks and relevant backlog docs/decisions, creates a detailed implementation plan per task using backlog task edit --plan, and flags any blockers via --append-notes. When no milestones exist but tasks do, it groups them into logical milestones. Reports status back to Manager.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->



## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file created at .claude/agents/analyse.md with correct frontmatter and system prompt
- [ ] #2 Analyse reads all tasks in the milestone using backlog task <id> --plain
- [ ] #3 Analyse reads backlog/docs/ and backlog/decisions/ for relevant context
- [ ] #4 Analyse creates implementation plan for each task using backlog task edit <id> --plan
- [ ] #5 Analyse flags blockers with a clearly marked note: backlog task edit <id> --append-notes with BLOCKER prefix
- [ ] #6 Analyse reports ready status per task: backlog task edit <id> --append-notes confirming no blockers
<!-- AC:END -->
