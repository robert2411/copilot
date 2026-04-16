---
id: TASK-13
title: Backlog CLI - Create task management tutorial
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:19'
labels:
  - documentation
  - tutorial
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create detailed tutorial on managing tasks: creation, editing, acceptance criteria, DoD, and lifecycle
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Step-by-step tutorial for creating tasks with all options
- [x] #2 Guide for editing and managing task lifecycle fields
- [x] #3 Examples of AC and DoD management patterns
- [x] #4 Tutorial on dependencies and subtasks
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 task management sections: Creating, Editing, AC, DoD, Lifecycle, Dependencies
2. Create backlog/docs/task-management-tutorial.md as a guided walkthrough
3. Step-by-step tutorial: backlog task create with all flags (-d, --ac, -l, -a, --priority, --ref, --doc)
4. Editing tutorial: status transitions, assignee, labels, plan, notes, final-summary
5. AC management: add, check, uncheck, remove; include multi-AC single-command patterns
6. DoD management: add, check, uncheck, remove; link to project-level DoD config
7. Dependencies: --dep flag, subtask creation with -p, backlog sequence output
8. Include concrete before/after examples for each operation
9. Commit file to git
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Source: doc-7 sections Crebacklog task edit 13 --plan $'1. Recd /Users/robertstevens/Projects/copilot-agents && backlog task edit 14 --plan $'1. Read doc-7 MCP Server section (backlog mcp start, tool call interface)\n2. Read doc-3 (Sub-Agents-and-MCP-Servers) for AI tool integration context\n3. Create backlog/docs/mcp-integration-guide.md\n4. Document MCP server startup: backlog mcp start, port config, --integration-mode setting\n5. Document tool call interface: list of available MCP tools, input schemas, response formats\n6. Show integration patterns for Claude Desktop (claude_desktop_config.json), Copilot, other MCP clients\n7. Document --integration-mode options: mcp vs cli vs none, when to use each\n8. Include example tool call sequences for common workflows\n9. Commit file to git'
q
exit
cd /Users/robertstevens/Projects/copilot-agents && backlog task 13 --plain | head -5
'

❌ QA ISSUES:
- [Medium] Incorrect config key for DoD defaults in tutorial: references `definitionOfDone`, but project config and documented CLI defaults use `definition_of_done` (`backlog/docs/doc-10 - Backlog-CLI-Task-Management-Tutorial.md:247-258`, `backlog/config.yml:5`). This can mislead users configuring DoD defaults.

Verdict: Fix required before approval.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created doc-10: Backlog CLI Task Management Tutorial.

Covers full task creation with all flags, editing lifecycle fields, status transitions, AC/DoD management with before/after examples, and dependency/subtask patterns.

File: backlog/docs/doc-10 - Backlog-CLI-Task-Management-Tutorial.md
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
