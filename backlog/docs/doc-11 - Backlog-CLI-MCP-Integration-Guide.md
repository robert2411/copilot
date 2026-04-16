---
id: doc-11
title: Backlog CLI - MCP Integration Guide
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — MCP Integration Guide

How to integrate Backlog with AI tools via the **Model Context Protocol (MCP)**.

---

## Table of Contents

1. [Overview](#overview)
2. [MCP Server Startup](#mcp-server-startup)
3. [Integration Mode Configuration](#integration-mode-configuration)
4. [Available MCP Tools](#available-mcp-tools)
5. [Integration Patterns](#integration-patterns)
   - [Claude Desktop](#claude-desktop)
   - [GitHub Copilot](#github-copilot)
   - [Other MCP Clients](#other-mcp-clients)
6. [Example Tool Call Sequences](#example-tool-call-sequences)

---

## Overview

Backlog supports two modes of AI tool integration:

| Mode | Description |
|---|---|
| **CLI mode** | AI agent runs shell commands: `backlog task list --plain` |
| **MCP mode** | AI agent calls structured tool calls: `list_tasks({status: "To Do"})` |

MCP mode is preferred when your AI client supports the Model Context Protocol natively — it provides structured input/output without shell parsing.

---

## MCP Server Startup

```bash
# Start on stdio (standard MCP transport)
backlog mcp start

# With debug logging
backlog mcp start --debug

# Override working directory
backlog mcp start --cwd /path/to/project

# Via environment variable
BACKLOG_CWD=/path/to/project backlog mcp start
```

The server communicates over **stdio** using the MCP JSON-RPC protocol. AI clients connect by spawning the process and piping stdio.

---

## Integration Mode Configuration

Set integration mode during initialization or via config:

```bash
# During init
backlog init "My Project" --integration-mode mcp

# Or via config
backlog config set integrationMode mcp
```

### Mode Options

| Mode | Description | When to Use |
|---|---|---|
| `mcp` | AI uses structured tool calls | MCP-capable clients (Claude Desktop, Cursor) |
| `cli` | AI runs shell CLI commands | Agents with shell access but no MCP support |
| `none` | No AI-specific integration | Manual use only |

In `cli` mode, agent instruction files (CLAUDE.md, AGENTS.md) embed the CLI reference so agents know how to interact. In `mcp` mode, the AI client discovers available tools directly from the running MCP server.

---

## Available MCP Tools

When running `backlog mcp start`, the server exposes these tools:

### Task Operations

| Tool | Description |
|---|---|
| `create_task` | Create a new task with all options |
| `edit_task` | Update task fields, AC, DoD, notes, status |
| `list_tasks` | List tasks with filters (status, assignee, priority) |
| `view_task` | Get full details of a single task |
| `archive_task` | Archive a task |
| `demote_task` | Demote task back to draft |

### Acceptance Criteria & DoD

| Tool | Description |
|---|---|
| `check_ac` | Mark an acceptance criterion complete |
| `uncheck_ac` | Unmark an acceptance criterion |
| `check_dod` | Mark a DoD item complete |
| `uncheck_dod` | Unmark a DoD item |

### Search & Navigation

| Tool | Description |
|---|---|
| `search` | Fuzzy search across tasks, docs, decisions |
| `list_milestones` | List milestones with completion percentages |
| `sequence_list` | Get topological execution order |

### Documents & Decisions

| Tool | Description |
|---|---|
| `create_document` | Create a project document |
| `list_documents` | List all documents |
| `create_decision` | Create an ADR |

---

## Integration Patterns

### Claude Desktop

Add Backlog as an MCP server in Claude Desktop's config file.

**Config location:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start"],
      "env": {
        "BACKLOG_CWD": "/path/to/your/project"
      }
    }
  }
}
```

After saving, restart Claude Desktop. The Backlog tools will appear in the tools panel.

**With debug logging:**

```json
{
  "mcpServers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start", "--debug"],
      "env": {
        "BACKLOG_CWD": "/path/to/your/project"
      }
    }
  }
}
```

### GitHub Copilot

For GitHub Copilot agents using CLI mode (shell access), set integration mode to `cli`:

```bash
backlog init "My Project" --integration-mode cli --agent-instructions copilot
```

This generates `.github/copilot-instructions.md` with the Backlog CLI usage guide embedded. Copilot agents read this file to learn how to interact with the project.

For MCP-capable Copilot agents, add to your MCP configuration:

```json
{
  "servers": {
    "backlog": {
      "type": "stdio",
      "command": "backlog",
      "args": ["mcp", "start"],
      "env": {
        "BACKLOG_CWD": "${workspaceFolder}"
      }
    }
  }
}
```

### Cursor

In Cursor's MCP settings (`~/.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start"],
      "env": {
        "BACKLOG_CWD": "/path/to/your/project"
      }
    }
  }
}
```

### Other MCP Clients

Any MCP-compliant client can integrate by:

1. Spawning: `backlog mcp start [--cwd <path>]`
2. Communicating over stdio using JSON-RPC 2.0
3. Calling tools listed in the `tools/list` response

---

## Example Tool Call Sequences

### Sequence 1: Find and claim a task

```
# AI client calls:
list_tasks({ status: "To Do", plain: true })
→ Returns list of tasks

view_task({ id: "task-42", plain: true })
→ Returns full task details

edit_task({ id: "task-42", status: "In Progress", assignee: "@agent" })
→ Task claimed
```

### Sequence 2: Implement and complete a task

```
# After claiming:
edit_task({ id: "task-42", plan: "1. Analyse\n2. Implement\n3. Test" })
→ Plan recorded

# During work:
edit_task({ id: "task-42", appendNotes: "- Implemented handler\n- Tests added" })
→ Notes appended

# Mark complete:
check_ac({ id: "task-42", index: 1 })
check_ac({ id: "task-42", index: 2 })
check_dod({ id: "task-42", index: 1 })
edit_task({ id: "task-42", finalSummary: "Implemented X. Changed Y. Tests pass.", status: "Done" })
→ Task done
```

### Sequence 3: Search and triage

```
search({ query: "authentication", type: "task", plain: true })
→ Returns matching tasks

list_tasks({ priority: "high", status: "To Do", plain: true })
→ Returns high-priority work
```

---

## CLI vs MCP: When to Use Which

| Scenario | Use |
|---|---|
| AI agent with shell access, no MCP client | CLI mode (`backlog task edit ...`) |
| Claude Desktop or Cursor integration | MCP mode (`backlog mcp start`) |
| CI/CD pipeline scripts | CLI mode |
| Human interactive use | CLI mode or Browser UI |
| Automated agent workflows at scale | MCP mode |

**Key difference:** CLI mode requires the agent to parse plain text output. MCP mode returns structured JSON, making it easier to process programmatically and less error-prone.

