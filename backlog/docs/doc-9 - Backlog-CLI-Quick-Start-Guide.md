---
id: doc-9
title: Backlog CLI - Quick-Start Guide
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — Quick-Start Guide

Get up and running with Backlog CLI in minutes.

---

## Installation

```bash
# npm (Node.js 18+)
npm install -g backlog.md

# Homebrew (macOS/Linux)
brew install backlog-md
```

Verify installation:

```bash
backlog --version
```

---

## Initialize a Project

```bash
# Interactive setup
backlog init "My Project"

# Non-interactive with all defaults
backlog init "My Project" --defaults

# With AI agent instructions generated
backlog init "My Project" --agent-instructions claude,agents
```

This creates a `backlog/` directory with `config.yml` and all subdirectories.

---

## Project Structure (What Gets Created)

```
backlog/
  config.yml      ← your project settings
  tasks/          ← active tasks
  drafts/         ← work-in-progress ideas
  milestones/     ← milestone groupings
  docs/           ← project documentation
  decisions/      ← architectural decision records
  archive/        ← archived tasks
  completed/      ← done tasks (after cleanup)
```

---

## Common Workflows

### 1. Create a Task

```bash
backlog task create "Fix login bug" \
  -d "Users can't log in with special characters in password" \
  --ac "Login succeeds with special characters" \
  --ac "Error message shown on failure" \
  --priority high \
  -l bug,auth
```

### 2. List Tasks

```bash
# All tasks
backlog task list --plain

# Filter by status
backlog task list -s "To Do" --plain
backlog task list -s "In Progress" --plain

# Filter by assignee
backlog task list -a @alice --plain

# High-priority tasks
backlog task list --priority high --plain
```

### 3. View a Task

```bash
backlog task 42 --plain
# or
backlog task view 42 --plain
```

Always use `--plain` to get clean text output (required for AI agents, scripts, and piping).

### 4. Edit Task Status and Assignee

```bash
# Start work on a task
backlog task edit 42 -s "In Progress" -a @bob

# Complete a task
backlog task edit 42 -s Done
```

### 5. Manage Acceptance Criteria

```bash
# Add criteria
backlog task edit 42 --ac "Users can reset password via email"

# Mark criteria complete (1-based index)
backlog task edit 42 --check-ac 1
backlog task edit 42 --check-ac 1 --check-ac 2  # multiple at once

# Uncheck a criterion
backlog task edit 42 --uncheck-ac 2

# Remove a criterion
backlog task edit 42 --remove-ac 3
```

### 6. Search Tasks

```bash
# Search across all tasks, docs, decisions
backlog search "authentication" --plain

# Search only tasks
backlog search "login" --type task --plain

# Narrow by status
backlog search "api" --status "In Progress" --plain
```

Fuzzy matching — `"auth"` finds `"authentication"`.

### 7. View the Board

```bash
# Terminal Kanban board
backlog board

# Vertical layout
backlog board --vertical

# Export board to markdown
backlog board export board.md

# Inject board into README.md
backlog board export --readme
```

### 8. Archive a Task

```bash
backlog task archive 42
```

Moves the task to `backlog/archive/tasks/`. Keeps active list clean.

### 9. Draft Workflow

```bash
# Create an idea as a draft (not yet active)
backlog task create "Investigate caching options" --draft

# List drafts
backlog draft list --plain

# Promote when ready
backlog draft promote 42
```

### 10. Add Notes During Implementation

```bash
# Replace notes
backlog task edit 42 --notes "Started implementation, route handler done"

# Append notes (preferred — preserves history)
backlog task edit 42 --append-notes $'- Added unit tests\n- Coverage at 85%'
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| **Task not found** | Run `backlog task list --plain` to see all task IDs |
| **AC index error** | Run `backlog task 42 --plain` to see current AC indices (1-based) |
| **`\n` appears literally in notes** | Use `$'...'` quoting: `--notes $'Line 1\nLine 2'` |
| **Metadata out of sync** | Re-edit via CLI: `backlog task edit 42 -s <current-status>` |
| **Board not showing tasks** | Check that tasks have valid statuses matching config |
| **Changes not reflected** | Ensure you're using CLI commands, not editing `.md` files directly |
| **Task file renamed accidentally** | Restore original name — CLI manages naming; never rename manually |

---

## Next Steps

- **Full reference:** See `doc-8 - Backlog-CLI-Comprehensive-Reference-Guide.md` for all commands and options
- **Task management tutorial:** `backlog doc list --plain` to find the task management tutorial doc
- **Advanced features:** `backlog search "advanced features" --type document --plain`
- **Help:** `backlog --help` for all commands; `backlog task --help` for task subcommands


