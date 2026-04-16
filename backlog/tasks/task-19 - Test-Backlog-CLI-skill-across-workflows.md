---
id: TASK-19
title: Test Backlog CLI skill across workflows
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:53'
labels:
  - skill
  - qa
  - testing
milestone: Backlog CLI Skill
dependencies:
  - TASK-18
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Thoroughly test the Backlog skill with real-world scenarios and AI agent interactions
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Task creation workflow tested end-to-end
- [ ] #2 AC and DoD management patterns validated
- [ ] #3 AI agent workflow tested with MCP
- [ ] #4 Search and board features verified
- [ ] #5 Multi-shell input patterns tested
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Confirm task-18 is Done and .github/skills/backlog-cli/SKILL.md exists
2. Test task creation workflow: run `backlog task create` with various options, verify output
3. Test AC management: add, check, uncheck, remove ACs via CLI; confirm metadata sync
4. Test DoD management: same pattern as AC
5. Test multi-shell newline patterns: bash $\\, POSIX printf, verify literal newlines preserved in description/plan/notes\n6. Test search: `backlog search "<term>" --plain`, fuzzy matching, type/status filters\n7. Test board: `backlog board` renders Kanban columns correctly\n8. Test MCP integration: register backlog as MCP server, invoke task ops via MCP tool calls, validate responses\n9. Document any skill prompt gaps found during testing as notes on task-18 for potential skill update\n10. git commit test results or notes
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. Hard dependency on task-18. Cannot start until skill file exists. No other blockers — backlog CLI is available, MCP integration docs present in backlog/docs/.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
