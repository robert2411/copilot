---
id: doc-8
title: Backlog CLI - Comprehensive Reference Guide
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — Comprehensive Reference Guide

> Version: **1.44.0** | Binary: `backlog`

---

## Table of Contents

1. [Overview](#overview)
2. [Installation & Initialization](#installation--initialization)
3. [Project Structure](#project-structure)
4. [Configuration](#configuration)
5. [Task Management](#task-management)
6. [Acceptance Criteria](#acceptance-criteria)
7. [Definition of Done](#definition-of-done)
8. [Task Lifecycle Fields](#task-lifecycle-fields)
9. [Dependencies & Subtasks](#dependencies--subtasks)
10. [Draft Management](#draft-management)
11. [Milestone Management](#milestone-management)
12. [Search](#search)
13. [Board](#board)
14. [Documents & Decisions](#documents--decisions)
15. [Sequence](#sequence)
16. [MCP Server](#mcp-server)
17. [Browser UI](#browser-ui)
18. [Multi-line Input Patterns](#multi-line-input-patterns)
19. [AI Agent Workflow](#ai-agent-workflow)
20. [Golden Rules](#golden-rules)

---

## Overview

Backlog.md is a **Git-native, file-based project management system** driven entirely through its CLI. Tasks, documents, decisions, and milestones are plain Markdown files in a `backlog/` directory alongside your code. Every change is version-controlled, diff-able, and branch-aware.

**Core design principles:**

- **CLI is the only write interface.** Never edit task files directly — the CLI manages metadata sync, Git commits, and relationships.
- **Plain-text first.** All read commands support `--plain` for machine-readable, AI-friendly output.
- **Configurable statuses.** Default: `To Do → In Progress → Done`. Any statuses can be configured.
- **MCP-server mode.** AI tools (Claude, Copilot) call Backlog as structured tool calls.

---

## Installation & Initialization

```bash
# Install
npm install -g backlog.md
# or
brew install backlog-md

# Initialize a project
backlog init [projectName] [options]
```

### Init Options

| Option | Description |
|---|---|
| `--agent-instructions <list>` | Generate AI instruction files: `claude`, `agents`, `gemini`, `copilot`, `cursor`, `none` |
| `--check-branches <bool>` | Track task states across Git branches (default: `true`) |
| `--include-remote <bool>` | Include remote branches (default: `true`) |
| `--branch-days <n>` | Days before branch considered inactive (default: `30`) |
| `--bypass-git-hooks <bool>` | Skip Git hooks on commits (default: `false`) |
| `--zero-padded-ids <n>` | Zero-pad IDs to n digits (e.g. `3` → `task-001`) |
| `--default-editor <cmd>` | Editor for interactive editing |
| `--web-port <n>` | Browser UI port (default: `6420`) |
| `--auto-open-browser <bool>` | Auto-launch browser on `backlog browser` (default: `true`) |
| `--integration-mode <mode>` | `mcp`, `cli`, or `none` — how AI tools connect |
| `--backlog-dir <path>` | Folder name: `backlog`, `.backlog`, or custom |
| `--task-prefix <prefix>` | Custom prefix for task IDs (default: `task`) |
| `--defaults` | Accept all defaults non-interactively |

---

## Project Structure

```
backlog/
  config.yml            ← project configuration
  tasks/                ← active tasks (task-<id> - <title>.md)
  drafts/               ← draft tasks not yet promoted
  completed/            ← completed tasks (moved by `backlog cleanup`)
  archive/
    tasks/              ← manually archived tasks
    drafts/
    milestones/
  milestones/           ← milestone definition files
  decisions/            ← architectural decision records (ADRs)
  docs/                 ← project documentation
```

**File naming:** `task-<id> - <title-with-dashes>.md` — managed automatically by CLI. **Never rename manually.**

---

## Configuration

```bash
backlog config list                  # print all config values
backlog config get <key>             # read a single value
backlog config set <key> <value>     # update a value
```

### Key Config Fields

| Key | Description |
|---|---|
| `projectName` | Human-readable project name |
| `defaultEditor` | Editor for interactive editing |
| `defaultStatus` | Status applied to new tasks |
| `statuses` | Ordered list of valid statuses |
| `labels` | Project-level label definitions |
| `milestones` | Milestone list |
| `definitionOfDone` | Default DoD items added to every new task |
| `dateFormat` | Date format (e.g. `yyyy-mm-dd`) |
| `maxColumnWidth` | Max column width in board view |
| `autoOpenBrowser` | Auto-launch browser on `backlog browser` |
| `defaultPort` | Web UI port |
| `autoCommit` | Auto-commit task changes to Git |
| `bypassGitHooks` | Skip hooks on auto-commits |
| `zeroPaddedIds` | Digits for zero-padded IDs |
| `checkActiveBranches` | Scan branches for task state |
| `activeBranchDays` | Age threshold for "active" branches |

---

## Task Management

### Creating Tasks

```bash
backlog task create "Task title" [options]
```

| Option | Description |
|---|---|
| `-d, --description <text>` | Task description (supports multi-line) |
| `--desc <text>` | Alias for `--description` |
| `-a, --assignee <name>` | Assign to a person (`@alice`) |
| `-s, --status <status>` | Initial status (default from config) |
| `-l, --labels <labels>` | Comma-separated labels |
| `--priority <level>` | `high`, `medium`, or `low` |
| `--ac <text>` | Add acceptance criterion (repeatable) |
| `--dod <text>` | Add Definition of Done item (repeatable) |
| `--no-dod-defaults` | Skip project-level DoD defaults |
| `--plan <text>` | Implementation plan |
| `--notes <text>` | Implementation notes |
| `--final-summary <text>` | PR-style final summary |
| `-p, --parent <taskId>` | Set parent task (creates subtask) |
| `--dep <taskId>` | Add dependency (repeatable) |
| `--ref <path/url>` | Attach file path or URL reference (repeatable) |
| `--doc <path/url>` | Attach documentation (repeatable) |
| `--draft` | Create as draft instead of active task |
| `--plain` | Print plain-text output after creation |

**Full example:**

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

### Listing Tasks

```bash
backlog task list [options]
```

| Option | Description |
|---|---|
| `-s, --status <status>` | Filter by status (case-insensitive) |
| `-a, --assignee <name>` | Filter by assignee |
| `-m, --milestone <name>` | Filter by milestone (fuzzy match) |
| `-p, --parent <taskId>` | Filter by parent (list subtasks) |
| `--priority <level>` | Filter by priority |
| `--sort <field>` | Sort by `priority` or `id` |
| `--plain` | Machine-readable plain-text output |

```bash
backlog task list --plain
backlog task list -s "In Progress" --plain
backlog task list -a @alice --priority high --plain
backlog task list -p task-42 --plain        # subtasks of task-42
```

### Viewing Tasks

```bash
backlog task view <taskId> [--plain]
backlog task <taskId> [--plain]             # shorthand
```

`--plain` suppresses the interactive TUI — **required for AI agent use**.

### Editing Tasks

```bash
backlog task edit <taskId> [options]
```

All `task create` options plus:

| Option | Description |
|---|---|
| `-t, --title <title>` | Rename task |
| `--add-label <label>` | Append label without removing existing |
| `--remove-label <label>` | Remove a specific label |
| `--ordinal <n>` | Set custom sort ordinal |
| `--notes <text>` | Replace implementation notes |
| `--append-notes <text>` | Append to notes (repeatable) |
| `--append-final-summary <text>` | Append to final summary (repeatable) |
| `--clear-final-summary` | Remove final summary entirely |

### Archiving & Demoting

```bash
backlog task archive <taskId>    # move to backlog/archive/tasks/
backlog task demote <taskId>     # move active task back to drafts
```

---

## Acceptance Criteria

AC items are **numbered checkboxes**, indices are **1-based**.

```bash
# Add criteria
backlog task edit 42 --ac "User sees error on invalid input" --ac "Rate limit applied"

# Check (complete) — multiple flags supported
backlog task edit 42 --check-ac 1 --check-ac 2

# Uncheck
backlog task edit 42 --uncheck-ac 1

# Remove (processed high-to-low to preserve indices)
backlog task edit 42 --remove-ac 3

# Mixed operations in one command
backlog task edit 42 --check-ac 1 --uncheck-ac 2 --remove-ac 4 --ac "New criterion"
```

> ⚠️ **No comma-separated ranges.** Use separate `--check-ac` flags per index.  
> ❌ `--check-ac 1,2,3` — does not work  
> ✅ `--check-ac 1 --check-ac 2 --check-ac 3` — correct

---

## Definition of Done

DoD items are a second checklist per task. Defaults come from `config.yml → definitionOfDone`.

```bash
# Add items
backlog task edit 42 --dod "Performance benchmarks pass"

# Check / uncheck
backlog task edit 42 --check-dod 1
backlog task edit 42 --uncheck-dod 2

# Remove
backlog task edit 42 --remove-dod 2

# Disable defaults on creation
backlog task create "Title" --no-dod-defaults
```

---

## Task Lifecycle Fields

| Field | CLI Flag | Purpose |
|---|---|---|
| Description | `-d` / `--desc` | The "why" — context and goal |
| Implementation Plan | `--plan` | The "how" — steps to implement |
| Implementation Notes | `--notes` / `--append-notes` | Progress log during implementation |
| Final Summary | `--final-summary` / `--append-final-summary` | PR description written at completion |

**Phase discipline:**

1. **Creation** — Title, Description, AC, labels, priority, assignee
2. **Start work** — Set In Progress, assign, add Implementation Plan
3. **During work** — Append Implementation Notes progressively
4. **Completion** — Check all AC/DoD, write Final Summary, set Done

---

## Dependencies & Subtasks

```bash
# Add dependencies
backlog task edit 42 --dep task-10 --dep task-11

# Create a subtask
backlog task create "Sub-feature" -p 42

# List subtasks
backlog task list -p 42 --plain

# View execution order
backlog sequence list --plain
```

---

## Draft Management

Drafts are tasks not yet ready for active tracking.

```bash
backlog draft list [--plain]
backlog draft create "Title" [options]      # same flags as task create
backlog draft view <taskId> [--plain]
backlog draft promote <taskId>              # draft → active task
backlog draft archive <taskId>

# Or create directly as draft
backlog task create "Title" --draft
```

**Use cases for drafts:**
- Ideas to be refined before committing to the backlog
- Tasks blocked on external decisions
- Future work not yet scoped

---

## Milestone Management

```bash
backlog milestone list [--plain]        # list milestones with completion %
backlog milestone archive <name>        # archive by id or title
```

Milestones group related tasks. Associate a task via the `-m` flag or task metadata.

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

| Option | Description |
|---|---|
| `--type <type>` | `task`, `document`, or `decision` |
| `--status <status>` | Filter task results by status |
| `--priority <priority>` | Filter by `high`, `medium`, or `low` |
| `--limit <n>` | Cap total results |
| `--plain` | Plain-text output for AI/scripting |

Fuzzy matching: searching `"auth"` finds `"authentication"`.

---

## Board

Terminal Kanban board and export:

```bash
backlog board                               # interactive horizontal board
backlog board --vertical                    # vertical layout
backlog board -m                            # group by milestone
backlog board export [filename]             # export to markdown file
backlog board export --readme               # inject into README.md with markers
backlog board export --force                # overwrite without confirmation
backlog board export --export-version 1.0   # embed version in export
```

---

## Documents & Decisions

### Documents

```bash
backlog doc create "Title" [-p <path>] [-t <type>]
backlog doc list [--plain]
backlog doc view <docId>
```

Types: `api`, `architecture`, `guide`, `other`

### Decisions (ADRs)

```bash
backlog decision create "Title" [options]
```

ADRs capture context, options considered, and rationale for architectural choices, stored in `backlog/decisions/`.

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

Manages AI agent instruction files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.github/copilot-instructions.md`):

```bash
backlog agents                         # show current agent files
backlog agents --update-instructions   # regenerate/update all agent instruction files
```

These files embed the Backlog CLI usage guide so AI agents know how to interact with the project.

---

## Shell Completion

```bash
backlog completion    # manage shell completion scripts
```

Follow the printed instructions to install completion for your shell (bash, zsh, fish, etc.).

---

## Sequence

Topological sort of task dependencies for execution order:

```bash
backlog sequence list --plain
```

Shows which tasks must complete before others can start. Essential for complex task graphs.

---

## MCP Server

Backlog runs as a **Model Context Protocol (MCP) server**, exposing all operations as structured tool calls:

```bash
backlog mcp start                     # start on stdio
backlog mcp start --debug             # with debug logging
backlog mcp start --cwd <path>        # custom working directory
```

`BACKLOG_CWD` environment variable also sets the working directory.

**Integration mode** set via `backlog init --integration-mode mcp` or config.  
In MCP mode, AI assistants call `create_task`, `edit_task`, `list_tasks`, etc. as tool calls instead of CLI commands.

---

## Browser UI

```bash
backlog browser               # open at default port 6420
backlog browser --port 8080   # custom port
```

Press `Ctrl+C` / `Cmd+C` to stop. Config: `autoOpenBrowser` controls automatic launch.

---

## Multi-line Input Patterns

The CLI stores input **literally** — `\n` in double-quoted strings is **not** converted to a newline by the shell. Use one of these patterns:

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

> ❌ `--notes "Line one\nLine two"` — passes literal `\n`, not a newline.

---

## AI Agent Workflow

Annotated step-by-step example for AI agents implementing a task:

```bash
# 1. Find available work
backlog task list -s "To Do" --plain

# 2. Read task details (always --plain)
backlog task 42 --plain

# 3. Claim task: assign + set status atomically
backlog task edit 42 -s "In Progress" -a @agent-name

# 4. Write implementation plan BEFORE touching code
backlog task edit 42 --plan $'1. Analyse codebase\n2. Implement X\n3. Add tests\n4. Verify AC'

# 5. Share plan with user — AWAIT approval before writing code

# 6. Implement; append notes as you progress (append, not replace)
backlog task edit 42 --append-notes $'- Implemented route handler\n- Added session middleware'

# 7. Mark AC complete as each is finished
backlog task edit 42 --check-ac 1 --check-ac 2

# 8. Mark DoD complete
backlog task edit 42 --check-dod 1

# 9. Write final summary (PR description quality)
backlog task edit 42 --final-summary $'Implemented OAuth GitHub login.\n\nChanges:\n- /auth/github route\n- Session middleware\n\nTests: all pass\nNo regressions.'

# 10. Set Done
backlog task edit 42 -s Done
```

**Mandatory rules for AI agents:**
- `--plain` on ALL read operations
- Never edit `.md` files directly
- Only implement what is in the Acceptance Criteria
- Add Implementation Plan before writing any code
- Append notes progressively — never overwrite history
- Final Summary = PR description quality, not a progress log

---

## Golden Rules

| Rule | Rationale |
|---|---|
| **CLI only for writes** | Keeps Git, metadata, and relationships in sync |
| **`--plain` for reads** | Machine-readable; no TUI escape sequences |
| **AC = scope boundary** | Only implement what's in AC; extend AC first if scope grows |
| **Plan before code** | Document the "how" before touching files |
| **Append notes, don't replace** | Preserve implementation history |
| **Final summary = PR description** | Written for a reviewer, not a progress log |
| **Done = all AC + DoD checked + Final Summary + status set** | Never mark Done prematurely |


