---
id: TASK-3
title: Implement the create-copilot-agent skill file
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 07:25'
updated_date: '2026-04-16 17:03'
labels:
  - agents
  - skill
  - implementation
milestone: Copilot Agent Creation Skill
dependencies:
  - TASK-1
  - TASK-2
documentation:
  - >-
    backlog/docs/doc-1 -
    GitHub-Copilot-Custom-Agents-Overview-and-Getting-Started.md
  - backlog/docs/doc-2 - GitHub-Copilot-Custom-Agents-Tool-Calls-Reference.md
  - >-
    backlog/docs/doc-3 -
    GitHub-Copilot-Custom-Agents-Sub-Agents-and-MCP-Servers.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create .github/agents/create-copilot-agent.agent.md — a full Claude agent file with valid frontmatter and a system prompt that guides an AI to author new Copilot custom agent files. Use doc-1, doc-2, and doc-3 as the source of truth.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [] #1 Agent file has valid frontmatter: name, description with usage examples, color
- [] #2 System prompt instructs the skill to gather: agent purpose, required tools, sub-agents needed, MCP servers
- [] #3 System prompt includes AGENTS.md authoring guidance from doc-1
- [] #4 System prompt includes built-in tool call best practices from doc-2
- [] #5 System prompt includes sub-agent and MCP patterns from doc-3
- [] #6 Agent file is self-contained and usable without additional context
- [] #7 Generated agents follow the anatomy established in task-1
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created .github/agents/create-copilot-agent.agent.md.

Frontmatter: name=create-copilot-agent, description with trigger examples, color=#7B5EA7.
System prompt covers: role/scope, 8-point requirements gathering, built-in tool best practices (doc-2), sub-agent delegation patterns (doc-3), MCP tool usage patterns (doc-3), quality checklist, output format, hard constraints.
Includes AGENTS.md snippet and .mcp.json snippet templates for when sub-agents/MCP are used.
File is self-contained and immediately usable.
<!-- SECTION:FINAL_SUMMARY:END -->
