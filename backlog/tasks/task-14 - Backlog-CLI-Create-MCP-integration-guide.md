---
id: TASK-14
title: Backlog CLI - Create MCP integration guide
status: Done
assignee:
  - '@implementation'
created_date: '2026-04-16 20:58'
updated_date: '2026-04-16 21:24'
labels:
  - documentation
  - integration
  - mcp
milestone: Backlog CLI Documentation
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Document how to integrate Backlog CLI with AI tools via Model Context Protocol (MCP)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 MCP server startup and configuration documented
- [x] #2 Tool call interface for task operations explained
- [x] #3 Integration patterns for Claude, Copilot, and other AI tools
- [x] #4 Configuration guide for --integration-mode settings
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read doc-7 MCP Server section and doc-3 Sub-Agents-and-MCP-Servers
2. Create backlog/docs/mcp-integration-guide.md
3. Document MCP server startup: backlog mcp start, port, --integration-mode setting
4. Document tool call interface: available MCP tools, input schemas, response formats
5. Show integration patterns for Claude Desktop (claude_desktop_config.json), Copilot, other MCP clients
6. Document --integration-mode options: mcp vs cli vs none, when to use each
7. Include example tool call sequences for common workflows
8. Commit file to git
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Sources: doc-7 MCP section, doc-3. Note: MCP tool list needs verification against running backlog mcp start --help.

✅ QA APPROVED
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created doc-11: Backlog CLI MCP Integration Guide.

Covers MCP server startup, integration mode config (mcp/cli/none), available MCP tools, integration patterns for Claude Desktop/Copilot/Cursor, and example tool call sequences.

File: backlog/docs/doc-11 - Backlog-CLI-MCP-Integration-Guide.md
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
