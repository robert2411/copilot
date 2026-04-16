---
id: TASK-6
title: Implement Manager Agent
status: Done
assignee:
  - '@copilot'
created_date: '2026-04-16 18:14'
updated_date: '2026-04-16 18:26'
labels:
  - manager
  - orchestration
milestone: Agent Workflow Orchestration System
dependencies: []
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the Manager agent file that orchestrates the full workflow. The Manager scans the backlog for the next available milestone, routes it to the Analyse agent, then hands off to Implementation when analysis is complete. After implementation it decides: loop to next milestone, ask Analyse to group orphan tasks into milestones, or exit when all work is done. See doc-6 for full workflow spec.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Agent file created at .claude/agents/manager.md with correct frontmatter and system prompt
- [x] #2 Manager scans backlog using backlog task list and backlog milestone list --plain
- [x] #3 Manager routes milestone to Analyse agent as the first step of every cycle
- [x] #4 Manager reads task notes to detect blocker flags set by Analyse before routing to Implementation
- [x] #5 Manager routes to Implementation agent only after Analyse confirms no blockers
- [x] #6 Manager handles end-of-milestone decision: more milestones available, orphan tasks exist, or project complete
- [x] #7 When no milestones but tasks exist, Manager delegates to Analyse agent to group tasks into logical milestones
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create .claude/agents/ directory
2. Write manager.md agent file with frontmatter + full system prompt per doc-6 spec
3. System prompt covers: scan backlog, route to analyse, check blockers, route to implementation, end-of-milestone decisions, orphan task handling
4. Verify AC coverage
5. Proceed to task 7 (Analyse), 8 (Implementation), 9 (QA) sequentially
6. Commit all agents together
<!-- SECTION:PLAN:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created .claude/agents/manager.md — the orchestrator agent.

Covers:
- Milestone scanning via backlog CLI
- Routing to Analyse agent with full context
- Blocker detection from task notes
- Routing to Implementation after clear analysis
- End-of-milestone decisions (next milestone / orphan grouping / exit)
- Orphan task → Analyse grouping path
<!-- SECTION:FINAL_SUMMARY:END -->
