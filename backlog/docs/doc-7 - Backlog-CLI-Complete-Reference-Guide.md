---
id: doc-7
title: Backlog CLI - Complete Reference Guide
type: other
created_date: '2026-04-16 20:36'
---

# Backlog CLI — Complete Reference Guide

> Version: **1.44.0**  
> CLI binary: `backlog`

---

## Table of Contents

1. [Overview](#overview)
2. [Installation & Initialization](#installation--initialization)
3. [Project Structure](#project-structure)
4. [Configuration](#configuration)
5. [Task Management](#task-management)
   - [Creating Tasks](#creating-tasks)
   - [Listing Tasks](#listing-tasks)
   - [Viewing Tasks](#viewing-tasks)
   - [Editing Tasks](#editing-tasks)
   - [Acceptance Criteria](#acceptance-criteria)
   - [Definition of Done](#definition-of-done)
   - [Task Lifecycle Fields](#task-lifecycle-fields)
   - [Dependencies & Relationships](#dependencies--relationships)
   - [Archiving & Demoting](#archiving--demoting)
6. [Draft Management](#draft-management)
7. [Milestone Management](#milestone-management)
8. [Search](#search)
9. [Board](#board)
10. [Documents](#documents)
11. [Decisions](#decisions)
12. [Sequence (Dependency Execution Order)](#sequence)
13. [Overview & Metrics](#overview--metrics)
14. [Cleanup](#cleanup)
15. [Agents](#agents)
16. [MCP Server](#mcp-server)
17. [Browser UI](#browser-ui)
18. [Shell Completion](#shell-completion)
19. [Multi-line Input Patterns](#multi-line-input-patterns)
20. [AI Agent Workflow](#ai-agent-workflow)
21. [Golden Rules](#golden-rules)

---

## Overview

Backlog.md is a **Git-native, file-based project management system** operated entirely through its CLI. Tasks,
documents, decisions, and milestones are stored as Markdown files inside a `backlog/` directory that lives alongside the
codebase. Because the files are plain Markdown committed to Git, every change is version-controlled, diff-able, and
branch-aware.

Key design principles:

- **CLI is the only interface for writes.** Never edit task files directly — the CLI manages metadata synchronisation,
  Git commits, and inter-task relationships.
- **Plain-text first.** All listing/viewing commands support `--plain` for machine-readable, AI-friendly output.
- **Statuses are fully configurable.** Default: `To Do → In Progress → Done`, but any set of statuses can be configured.
- **MCP-server mode** allows AI tools (Claude, Copilot, etc.) to call Backlog operations as structured tool calls.

---

## Installation & Initialization

### Initialize a project

```bash
backlog init [projectName] [options]
```

| Option                        | Description                                                                              |
|-------------------------------|------------------------------------------------------------------------------------------|
| `--agent-instructions <list>` | Generate AI instruction files: `claude`, `agents`, `gemini`, `copilot`, `cursor`, `none` |
| `--check-branches <bool>`     | Track task states across Git branches (default: `true`)                                  |
| `--include-remote <bool>`     | Include remote branches (default: `true`)                                                |
| `--branch-days <n>`           | Days before a branch is considered inactive (default: `30`)                              |
| `--bypass-git-hooks <bool>`   | Skip Git hooks on commits (default: `false`)                                             |
| `--zero-padded-ids <n>`       | Zero-pad task IDs to `n` digits (e.g. `3` → `task-001`)                                  |
| `--default-editor <cmd>`      | Editor used when opening tasks interactively                                             |
| `--web-port <n>`              | Default port for the browser UI (default: `6420`)                                        |
| `--auto-open-browser <bool>`  | Auto-launch browser when running `backlog browser` (default: `true`)                     |
| `--integration-mode <mode>`   | `mcp`, `cli`, or `none` — how AI tools connect                                           |
| `--backlog-dir <path>`        | Folder for the backlog directory (`backlog`, `.backlog`, or custom)                      |
| `--task-prefix <prefix>`      | Custom prefix for task IDs, letters only (default: `task`)                               |
| `--defaults`                  | Accept all defaults non-interactively                                                    |

---

## Project Structure

```
backlog/
  config.yml            ← project configuration
  tasks/                ← active tasks (task-<id> - <title>.md)
  drafts/               ← draft tasks not yet promoted
  completed/            ← tasks moved here by `backlog cleanup`
  archive/
    tasks/              ← manually archived tasks
    drafts/
    milestones/
  milestones/           ← milestone definition files
  decisions/            ← architectural decision records (ADRs)
  docs/                 ← project documentation
```

**File naming convention:** `task-<id> - <title-with-dashes>.md`  
The CLI manages naming automatically. Never rename files manually.

---

## Configuration

```bash
backlog config list                  # print all config values
backlog config get <key>             # read a single value
backlog config set <key> <value>     # update a value
```

### Key config fields

| Key                   | Description                               |
|-----------------------|-------------------------------------------|
| `projectName`         | Human-readable project name               |
| `defaultEditor`       | Editor launched for interactive editing   |
| `defaultStatus`       | Status applied to new tasks               |
| `statuses`            | Ordered list of valid statuses            |
| `labels`              | Project-level label definitions           |
| `milestones`          | Milestone list                            |
| `definitionOfDone`    | Default DoD items added to every new task |
| `dateFormat`          | Date format string (e.g. `yyyy-mm-dd`)    |
| `maxColumnWidth`      | Max column width in board view            |
| `autoOpenBrowser`     | Auto-launch browser on `backlog browser`  |
| `defaultPort`         | Web UI port                               |
| `remoteOperations`    | Push/pull with remote Git                 |
| `autoCommit`          | Auto-commit task changes to Git           |
| `bypassGitHooks`      | Skip hooks on auto-commits                |
| `zeroPaddedIds`       | Digits for zero-padded IDs                |
| `checkActiveBranches` | Scan branches for task state              |
| `activeBranchDays`    | Age threshold for "active" branches       |

---

## Task Management

### Creating Tasks

```bash
backlog task create "Task title" [options]
```

| Option                     | Description                                      |
|----------------------------|--------------------------------------------------|
| `-d, --description <text>` | Task description (supports multi-line)           |
| `--desc <text>`            | Alias for `--description`                        |
| `-a, --assignee <name>`    | Assign to a person (`@alice`)                    |
| `-s, --status <status>`    | Initial status (default from config)             |
| `-l, --labels <labels>`    | Comma-separated labels                           |
| `--priority <level>`       | `high`, `medium`, or `low`                       |
| `--ac <text>`              | Add acceptance criterion (repeatable)            |
| `--dod <text>`             | Add Definition of Done item (repeatable)         |
| `--no-dod-defaults`        | Skip project-level DoD defaults                  |
| `--plan <text>`            | Implementation plan                              |
| `--notes <text>`           | Implementation notes                             |
| `--final-summary <text>`   | PR-style final summary                           |
| `-p, --parent <taskId>`    | Set parent task (creates a subtask)              |
| `--dep <taskId>`           | Add task dependency (repeatable)                 |
| `--ref <path/url>`         | Attach a file path or URL reference (repeatable) |
| `--doc <path/url>`         | Attach documentation (repeatable)                |
| `--draft`                  | Create as a draft instead of active task         |
| `--plain`                  | Print plain-text output after creation           |

**Example — full creation:**

```bash
backlog task create "Add OAuth login" \
  -d "Implement OAuth 2.0 login via GitHub" \
  -a @alice \
  --priority high \
  --ac "User can log in with GitHub" \
  --ac "Session persists across page reloads" \
  --dod "All tests pass" \
  --dod "Docs updated" \
  -l auth,backend
```

---

### Listing Tasks

```bash
backlog task list [options]
```

| Option                   | Description                           |
|--------------------------|---------------------------------------|
| `-s, --status <status>`  | Filter by status (case-insensitive)   |
| `-a, --assignee <name>`  | Filter by assignee                    |
| `-m, --milestone <name>` | Filter by milestone (fuzzy match)     |
| `-p, --parent <taskId>`  | Filter by parent task (list subtasks) |
| `--priority <level>`     | Filter by priority                    |
| `--sort <field>`         | Sort by `priority` or `id`            |
| `--plain`                | Machine-readable plain-text output    |

**Examples:**

```bash
backlog task list --plain                          # all tasks
backlog task list -s "In Progress" --plain         # in-progress only
backlog task list -a @alice --priority high --plain
backlog task list -p task-42 --plain               # subtasks of task-42
```

---

### Viewing Tasks

```bash
backlog task view <taskId> [--plain]
# or shorthand:
backlog task <taskId> [--plain]
```

`--plain` suppresses interactive TUI and prints raw text — required for AI agent use.

---

### Editing Tasks

```bash
backlog task edit <taskId> [options]
```

All `task create` options are available plus:

| Option                          | Description                                   |
|---------------------------------|-----------------------------------------------|
| `-t, --title <title>`           | Rename task                                   |
| `--add-label <label>`           | Append a label without removing existing ones |
| `--remove-label <label>`        | Remove a specific label                       |
| `--ordinal <n>`                 | Set custom sort ordinal                       |
| `--notes <text>`                | Replace implementation notes                  |
| `--append-notes <text>`         | Append to implementation notes (repeatable)   |
| `--append-final-summary <text>` | Append to final summary (repeatable)          |
| `--clear-final-summary`         | Remove the final summary entirely             |

---

### Acceptance Criteria

Acceptance criteria (AC) are numbered checkboxes. Indices are **1-based**.

```bash
# Add criteria
backlog task edit 42 --ac "User sees error on invalid input" --ac "Rate limit applied"

# Check (complete) criteria
backlog task edit 42 --check-ac 1 --check-ac 2

# Uncheck criteria
backlog task edit 42 --uncheck-ac 1

# Remove criteria (processed high-to-low to preserve indices)
backlog task edit 42 --remove-ac 3

# Mixed operations in one command
backlog task edit 42 --check-ac 1 --uncheck-ac 2 --remove-ac 4 --ac "New criterion"
```

> ⚠️ **No comma-separated ranges.** Use separate `--check-ac` flags per index.

---

### Definition of Done

DoD items are a second checklist. Defaults come from `config.yml → definitionOfDone`.

```bash
# Add items
backlog task edit 42 --dod "Performance benchmarks pass"

# Check/uncheck
backlog task edit 42 --check-dod 1
backlog task edit 42 --uncheck-dod 1

# Remove
backlog task edit 42 --remove-dod 2

# Disable defaults on creation
backlog task create "Title" --no-dod-defaults
```

---

### Task Lifecycle Fields

| Field                | CLI flag                                     | Purpose                              |
|----------------------|----------------------------------------------|--------------------------------------|
| Description          | `-d` / `--desc`                              | The "why" — context and goal         |
| Implementation Plan  | `--plan`                                     | The "how" — steps to implement       |
| Implementation Notes | `--notes` / `--append-notes`                 | Progress log during implementation   |
| Final Summary        | `--final-summary` / `--append-final-summary` | PR description written at completion |

**Phase discipline:**

1. **Creation** — Title, Description, AC, labels, priority, assignee
2. **Start work** — Set In Progress, assign, add Implementation Plan
3. **During work** — Append Implementation Notes progressively
4. **Completion** — Check all AC/DoD, write Final Summary, set Done

---

### Dependencies & Relationships

```bash
# Set dependencies (task must wait for these)
backlog task edit 42 --dep task-10 --dep task-11

# Create a subtask
backlog task create "Sub-feature" -p 42

# List subtasks
backlog task list -p 42 --plain

# Inspect execution sequences from dependencies
backlog sequence list --plain
```

---

### Archiving & Demoting

```bash
backlog task archive <taskId>    # move to backlog/archive/tasks/
backlog task demote <taskId>     # move active task back to drafts
```

---

## Draft Management

Drafts are tasks not yet ready to be tracked as active work.

```bash
backlog draft list [--plain]              # list all drafts
backlog draft create "Title" [options]    # create a draft (same flags as task create)
backlog draft view <taskId> [--plain]     # view draft details
backlog draft promote <taskId>            # promote draft → active task
backlog draft archive <taskId>            # archive a draft
```

Alternatively, create a task directly as draft:

```bash
backlog task create "Title" --draft
```

---

## Milestone Management

```bash
backlog milestone list [--plain]     # list milestones with completion %
backlog milestone archive <name>     # archive a milestone by id or title
```

Milestones group tasks. Associate a task with a milestone via the config or task metadata.

---

## Search

Fuzzy full-text search across tasks, documents, and decisions:

```bash
backlog search "auth" --plain
backlog search "login" --type task --plain
backlog search "api" --status "In Progress" --plain
backlog search "bug" --priority high --plain
backlog search "oauth" --limit 10 --plain
```

| Option                  | Description                          |
|-------------------------|--------------------------------------|
| `--type <type>`         | `task`, `document`, or `decision`    |
| `--status <status>`     | Filter task results by status        |
| `--priority <priority>` | Filter by `high`, `medium`, or `low` |
| `--limit <n>`           | Cap total results                    |
| `--plain`               | Plain-text output for AI/scripting   |

Search uses fuzzy matching — searching `"auth"` will find `"authentication"`.

---

## Board

Terminal Kanban board and export:

```bash
backlog board                              # interactive horizontal board
backlog board --vertical                   # vertical layout
backlog board -m                           # group by milestone
backlog board export [filename]            # export to markdown file
backlog board export --readme              # inject into README.md with markers
backlog board export --force               # overwrite without confirmation
backlog board export --export-version 1.0  # embed version in export
```

---

## Documents

Project documentation files stored in `backlog/docs/`.

```bash
backlog doc create "Title" [-p <path>] [-t <type>]   # create a document
backlog doc list [--plain]                            # list all documents
backlog doc view <docId>                              # view a document
```

Documents support:

- `--path` to specify a sub-path within `backlog/docs/`
- `--type` to categorise (e.g. `api`, `architecture`, `guide`, `other`)

Documents are plain Markdown files. After creation, write content directly into the file — the CLI creates the stub with
frontmatter, body is free-form Markdown.

---

## Decisions

Architectural Decision Records (ADRs) stored in `backlog/decisions/`.

```bash
backlog decision create "Title" [options]   # create an ADR
```

ADRs capture the context, options considered, and rationale behind significant architectural choices.

---

## Sequence

Computes execution order from task dependencies using topological sort:

```bash
backlog sequence list --plain    # list dependency chains in execution order
```

Useful for understanding which tasks must complete before others can start, especially in complex task graphs.

---

## Overview & Metrics

```bash
backlog overview    # project statistics: task counts by status, assignee distribution, etc.
```

---

## Cleanup

Moves completed/done tasks to `backlog/completed/` based on age:

```bash
backlog cleanup
```

Keeps the active task list lean while preserving history.

---

## Agents

Manages AI agent instruction files (CLAUDE.md, AGENTS.md, GEMINI.md, `.github/copilot-instructions.md`):

```bash
backlog agents                         # show current agent files
backlog agents --update-instructions   # regenerate/update all agent instruction files
```

These files embed the Backlog CLI usage guide so AI agents know how to interact with the project.

---

## MCP Server

Backlog can run as a **Model Context Protocol (MCP) server**, exposing all task operations as structured tool calls
consumable by AI tools:

```bash
backlog mcp start             # start MCP server on stdio
backlog mcp start --debug     # with debug logging
backlog mcp start --cwd <path>  # resolve backlog root from custom path
```

The `BACKLOG_CWD` environment variable can also set the working directory.

**Integration mode** is set during `backlog init --integration-mode mcp` or via config.  
In MCP mode, AI assistants call operations like `create_task`, `edit_task`, `list_tasks`, etc. as tool calls instead of
running CLI commands.

---

## Browser UI

Web-based interface for task management:

```bash
backlog browser              # open browser UI (default port 6420)
backlog browser --port 8080  # custom port
```

Press `Ctrl+C` / `Cmd+C` to stop the server.  
Config: `autoOpenBrowser` controls whether the browser launches automatically.

---

## Shell Completion

```bash
backlog completion    # manage shell completion scripts
```

Follow the printed instructions to install completion for your shell (bash, zsh, fish, etc.).

---

## Multi-line Input Patterns

The CLI stores input **literally** — `\n` in double-quoted strings is not converted to a newline by the shell. Use these
patterns instead:

### Bash / Zsh — ANSI-C quoting (recommended)

```bash
backlog task edit 42 --plan $'1. Research\n2. Implement\n3. Test'
backlog task edit 42 --description $'Line one\n\nLine two after blank'
backlog task edit 42 --append-notes $'- Fixed edge case\n- Updated tests'
backlog task edit 42 --final-summary $'Shipped OAuth login.\n\nChanges:\n- Added /auth/github route\n- Session middleware updated'
```

### POSIX-portable — printf

```bash
backlog task edit 42 --notes "$(printf 'Line one\nLine two')"
```

### PowerShell — backtick-n

```powershell
backlog task edit 42 --notes "Line one`nLine two"
```

---

## AI Agent Workflow

The recommended workflow for AI agents implementing tasks:

```bash
# 1. Find work
backlog task list -s "To Do" --plain

# 2. Read task
backlog task 42 --plain

# 3. Start work: assign + set status
backlog task edit 42 -s "In Progress" -a @agent-name

# 4. Write implementation plan (BEFORE coding)
backlog task edit 42 --plan $'1. Analyse codebase\n2. Implement X\n3. Add tests\n4. Verify AC'

# 5. Share plan with user — await approval before writing code

# 6. Implement; append notes as you progress
backlog task edit 42 --append-notes $'- Implemented route handler\n- Added session middleware'

# 7. Mark AC complete as each is finished
backlog task edit 42 --check-ac 1 --check-ac 2

# 8. Mark DoD complete
backlog task edit 42 --check-dod 1

# 9. Write final summary
backlog task edit 42 --final-summary $'Implemented OAuth GitHub login.\n\nChanges:\n- /auth/github route\n- Session middleware\n\nTests: all pass\nNo regressions.'

# 10. Set Done
backlog task edit 42 -s Done
```

**Rules for AI agents:**

- Use `--plain` on all read operations
- Never edit `.md` files directly
- Only implement what is in the Acceptance Criteria
- Add Implementation Plan before writing any code
- Append notes progressively — don't overwrite history
- Final Summary = PR description quality

---

## Golden Rules

| Rule                                                         | Rationale                                                   |
|--------------------------------------------------------------|-------------------------------------------------------------|
| **CLI only for writes**                                      | Keeps Git, metadata, and relationships in sync              |
| **`--plain` for reads**                                      | Machine-readable; no TUI escape sequences                   |
| **AC = scope boundary**                                      | Only implement what's in AC; extend AC first if scope grows |
| **Plan before code**                                         | Document the "how" before touching files                    |
| **Append notes, don't replace**                              | Preserve implementation history                             |
| **Final summary = PR description**                           | Written for a reviewer, not a progress log                  |
| **Done = all AC + DoD checked + Final Summary + status set** | Never mark Done prematurely                                 |
