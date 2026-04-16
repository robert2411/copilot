---
id: TASK-16
title: Backlog CLI - Create AI agent integration guide
status: To Do
assignee: []
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:11'
labels:
  - documentation
  - ai-agents
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create guide for AI agents (Claude, Copilot, etc.) on how to use Backlog CLI for autonomous task management
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 AI agent workflow patterns documented with examples
- [ ] #2 --plain flag usage explained for machine-readable output
- [ ] #3 AC scope boundary principles explained for agents
- [ ] #4 Phase discipline enforced (plan before code)
- [ ] #5 Multi-tool vs CLI mode patterns shown
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 AI Agent Workflow section; read AGENTS.md fully for agent-specific patterns
2. Create backlog/docs/ai-agent-integration-guide.md
3. Document AI agent workflow: identify -> read -> assign+status -> plan -> implement -> check-ac -> final-summary -> Done
4. Explain --plain flag: why machine-readable output matters, which commands support it, format differences
5. AC scope boundaries: only implement what AC specifies, how to extend AC before coding extra scope
6. Phase discipline for agents: plan-before-code enforcement, waiting for approval pattern
7. Multi-tool vs CLI mode: when to use MCP tool calls vs shell CLI, --integration-mode cli vs mcp
8. Annotated example: full agent session from task read to Done with inline explanations
9. Commit file to git
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Sources: doc-7 AI Agent Workflow, AGENTS.md, doc-6.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
