---
id: doc-14
title: Backlog CLI - Advanced Features Guide
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — Advanced Features Guide

Search, board, sequences, drafts, milestones, and configuration.

---

## Table of Contents

1. [Search](#search)
2. [Board Visualization and Export](#board-visualization-and-export)
3. [Dependency Sequences](#dependency-sequences)
4. [Draft Workflow](#draft-workflow)
5. [Milestones](#milestones)
6. [Configuration Management](#configuration-management)

---

## Search

Fuzzy full-text search across all project content — tasks, documents, and decisions.

### Basic Usage

```bash
# Search everything
backlog search "authentication" --plain

# Search only tasks
backlog search "login" --type task --plain

# Search only documents
backlog search "setup guide" --type document --plain

# Search only decisions
backlog search "database choice" --type decision --plain
```

### Filters

Narrow results by combining filters:

```bash
# Tasks in progress matching "api"
backlog search "api" --status "In Progress" --plain

# High-priority bugs
backlog search "bug" --priority high --plain

# Limit result count
backlog search "oauth" --limit 5 --plain
```

### Filter Options

| Option | Values | Description |
|---|---|---|
| `--type` | `task`, `document`, `decision` | Limit to content type |
| `--status` | Any configured status | Filter task results by status |
| `--priority` | `high`, `medium`, `low` | Filter by priority level |
| `--limit <n>` | Integer | Cap total results returned |
| `--plain` | — | Plain-text output (always use for AI/scripts) |

### Fuzzy Matching

Search uses fuzzy matching — partial and approximate strings work:

```bash
backlog search "auth" --plain          # finds "authentication", "authorize", "OAuth"
backlog search "db migr" --plain       # finds "database migration"
backlog search "rate lim" --plain      # finds "rate limiting"
```

### Practical Patterns

**Before creating a task — check for duplicates:**
```bash
backlog search "rate limiting" --type task --plain
```

**Find all work assigned to a person:**
```bash
backlog task list -a @alice --plain
# (task list supports assignee filter; search does not)
```

**Triage session — find unassigned high-priority work:**
```bash
backlog task list --priority high -s "To Do" --plain
```

---

## Board Visualization and Export

### Terminal Kanban Board

```bash
# Horizontal board (default)
backlog board

# Vertical layout
backlog board --vertical

# Group by milestone
backlog board -m
```

The board shows tasks in columns by status. Use it to:
- Spot WIP (work-in-progress) bottlenecks — too many tasks in one column
- Identify blocked work — tasks stuck In Progress
- Check milestone distribution

### Exporting the Board

#### Export to Markdown File

```bash
# Export to a named file
backlog board export board.md

# Export to default filename
backlog board export

# Overwrite without confirmation
backlog board export board.md --force

# Embed version string in export
backlog board export board.md --export-version 1.0
```

#### Inject into README

Backlog can maintain a live board snapshot in your README:

```bash
backlog board export --readme
```

This looks for `<!-- BACKLOG_BOARD_START -->` and `<!-- BACKLOG_BOARD_END -->` markers in `README.md` and replaces the content between them. Add the markers to your README:

```markdown
## Project Status

<!-- BACKLOG_BOARD_START -->
<!-- BACKLOG_BOARD_END -->
```

Then run `backlog board export --readme` to inject the current board. Run it in CI to keep README always up-to-date.

---

## Dependency Sequences

### Why Sequences Matter

When tasks have dependencies (`--dep`), some tasks must complete before others can start. The `sequence` command computes this order using topological sorting.

### View Execution Order

```bash
backlog sequence list --plain
```

Output shows chains of tasks in the order they must be executed — earliest dependencies first, dependent tasks after.

### Example

Given tasks:
- task-40: "Set up database" (no deps)
- task-41: "Implement data models" (deps: task-40)
- task-42: "Build API endpoints" (deps: task-41)
- task-43: "Write integration tests" (deps: task-42)

```bash
backlog sequence list --plain
# Output: task-40 → task-41 → task-42 → task-43
```

### Setting Dependencies

```bash
# Single dependency
backlog task edit 42 --dep task-41

# Multiple dependencies (task waits for both)
backlog task edit 43 --dep task-41 --dep task-42
```

### Sequence for Sprint Planning

Use sequence output to:
1. Identify the critical path (longest dependency chain)
2. Find tasks that can run in parallel (no shared dependencies)
3. Ensure sprint work is ordered correctly

---

## Draft Workflow

Drafts are tasks not yet ready for active tracking. Use them for ideas, speculative work, or tasks blocked on external decisions.

### Create a Draft

```bash
# Via --draft flag on task create
backlog task create "Investigate GraphQL migration" \
  -d "Research feasibility of migrating REST APIs to GraphQL" \
  --draft

# Or directly via draft subcommand
backlog draft create "Investigate GraphQL migration" \
  -d "Research feasibility..."
```

Drafts go to `backlog/drafts/` instead of `backlog/tasks/`. They don't appear in standard task lists.

### Manage Drafts

```bash
# List all drafts
backlog draft list --plain

# View a draft
backlog draft view 42 --plain

# Archive a draft (remove without promoting)
backlog draft archive 42
```

### Promote a Draft to Active Task

When the draft is ready to be worked:

```bash
backlog draft promote 42
# Draft moves from backlog/drafts/ to backlog/tasks/
# Now visible in task list and board
```

### Demote an Active Task Back to Draft

If a task isn't ready to be worked after all:

```bash
backlog task demote 42
# Moves from backlog/tasks/ back to backlog/drafts/
```

### Typical Draft Workflow

```bash
# 1. Create draft during brainstorming
backlog task create "Refactor auth service" --draft \
  --ac "Latency reduced by 20%" \
  --ac "All existing tests pass"

# 2. Refine draft over time (edit just like tasks)
backlog task edit 42 -d "Detailed analysis reveals bottleneck in token validation"
backlog task edit 42 --ac "Token validation < 5ms p95"

# 3. When ready to schedule
backlog draft promote 42

# 4. Now visible in task list and board
backlog task list --plain
```

---

## Milestones

Milestones group related tasks under a shared goal with a target date or version.

### View Milestones

```bash
# List milestones with completion percentage
backlog milestone list --plain
```

Output shows each milestone, total task count, and percentage of tasks Done.

### Assign Tasks to a Milestone

At task creation:

```bash
backlog task create "Implement login" -m "v1.0 Launch"
```

On an existing task:

```bash
backlog task edit 42 -m "v1.0 Launch"
```

### Filter by Milestone

```bash
# View all tasks in a milestone
backlog task list -m "v1.0 Launch" --plain

# Board grouped by milestone
backlog board -m
```

### Archive a Milestone

Once a milestone is shipped:

```bash
backlog milestone archive "v1.0 Launch"
# Moves milestone file to backlog/archive/milestones/
```

---

## Configuration Management

All project settings live in `backlog/config.yml`. Use the CLI to read and modify them — never edit the file directly.

### List All Config

```bash
backlog config list
```

### Get a Single Value

```bash
backlog config get projectName
backlog config get defaultStatus
backlog config get zeroPaddedIds
```

### Set a Value

```bash
backlog config set defaultStatus "To Do"
backlog config set webPort 8080
backlog config set autoOpenBrowser false
backlog config set zeroPaddedIds 3         # task IDs become task-001, task-002, ...
```

### Key Configuration Fields

| Key | Default | Description |
|---|---|---|
| `projectName` | — | Human-readable project name |
| `defaultStatus` | `"To Do"` | Status applied to new tasks |
| `statuses` | `["To Do", "In Progress", "Done"]` | All valid task statuses (ordered) |
| `definition_of_done` | `[]` | Default DoD items on every new task |
| `integrationMode` | `"none"` | `mcp`, `cli`, or `none` |
| `zeroPaddedIds` | `0` | Pad IDs to N digits (`3` → `task-001`) |
| `webPort` | `6420` | Browser UI port |
| `autoOpenBrowser` | `true` | Launch browser automatically |
| `autoCommit` | `true` | Auto-commit task changes to Git |
| `bypassGitHooks` | `false` | Skip Git hooks on auto-commits |
| `checkActiveBranches` | `true` | Scan branches for task state |
| `activeBranchDays` | `30` | Age threshold for "active" branch |

### Configure Statuses

Add custom statuses to fit your workflow:

```bash
backlog config set statuses '["Backlog", "To Do", "In Progress", "Review", "Done"]'
```

### Configure Default DoD

Set global DoD items applied to every new task:

```bash
backlog config set definition_of_done '["Tests pass", "Code reviewed", "Docs updated"]'
```

Disable per task:

```bash
backlog task create "Quick fix" --no-dod-defaults
```

