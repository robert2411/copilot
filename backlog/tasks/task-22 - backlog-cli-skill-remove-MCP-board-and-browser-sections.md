---
id: TASK-22
title: 'backlog-cli skill: remove MCP, board, and browser sections'
status: Done
assignee:
  - '@copilot'
created_date: '2026-04-16 22:05'
updated_date: '2026-04-16 22:07'
labels:
  - skill
  - documentation
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The backlog-cli SKILL.md and USAGE.md contain sections for MCP integration, board visualization, and browser UI. These should be removed from the skill to keep it focused on core task management workflows.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 MCP integration section removed from SKILL.md
- [x] #2 Board visualization section removed from SKILL.md
- [x] #3 MCP server usage section removed from USAGE.md
- [x] #4 Search and Board section in USAGE.md updated to remove board/browser content
- [x] #5 References to MCP tools removed from AI agent integration patterns
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Removed MCP, board, and browser sections from SKILL.md and USAGE.md.

Changes:
- SKILL.md: Removed MCP Integration section; removed Board Visualization section; updated description and When to Use to drop MCP/kanban keywords
- USAGE.md: Removed MCP Server Usage section; renamed "Search and Board" to "Search" with board/browser commands removed; removed MCP troubleshooting rows; updated quick reference card
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
