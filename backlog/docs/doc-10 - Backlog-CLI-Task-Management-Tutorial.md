---
id: doc-10
title: Backlog CLI - Task Management Tutorial
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — Task Management Tutorial

A guided walkthrough for creating, editing, and managing tasks through their full lifecycle.

---

## Table of Contents

1. [Creating Tasks](#creating-tasks)
2. [Editing Tasks](#editing-tasks)
3. [Task Lifecycle and Status Transitions](#task-lifecycle-and-status-transitions)
4. [Acceptance Criteria Management](#acceptance-criteria-management)
5. [Definition of Done Management](#definition-of-done-management)
6. [Dependencies and Subtasks](#dependencies-and-subtasks)

---

## Creating Tasks

### Minimal Task

The simplest task requires only a title:

```bash
backlog task create "Fix navigation bug"
```

### Task with Description and AC

Add context (description) and verifiable outcomes (acceptance criteria):

```bash
backlog task create "Fix navigation bug" \
  -d "Navigation menu collapses on mobile screens smaller than 375px" \
  --ac "Menu displays correctly on 375px viewport" \
  --ac "Menu toggle button visible on all mobile sizes"
```

### Full Task Creation with All Options

```bash
backlog task create "Add OAuth login" \
  -d "Implement OAuth 2.0 login via GitHub" \
  -a @alice \
  -s "To Do" \
  --priority high \
  -l auth,backend \
  --ac "User can log in with GitHub account" \
  --ac "Session persists across page reloads" \
  --ac "Logout clears session completely" \
  --dod "All tests pass" \
  --dod "Docs updated" \
  --ref src/auth/handler.ts \
  --ref https://docs.github.com/en/apps/oauth-apps
```

**Option reference:**

| Flag | Purpose |
|---|---|
| `-d` / `--desc` | Description (the "why") |
| `-a` | Assignee (`@name`) |
| `-s` | Initial status |
| `--priority` | `high`, `medium`, or `low` |
| `-l` | Comma-separated labels |
| `--ac` | Acceptance criterion (repeatable) |
| `--dod` | Definition of Done item (repeatable) |
| `--no-dod-defaults` | Skip project-level DoD defaults |
| `--ref` | File or URL reference (repeatable) |
| `--doc` | Attached documentation (repeatable) |
| `--draft` | Create as draft (not yet active) |

### Verify Creation

```bash
backlog task list --plain         # find the new task ID
backlog task <id> --plain         # inspect full task details
```

---

## Editing Tasks

### Rename a Task

```bash
backlog task edit 42 -t "Fix mobile navigation collapse"
```

### Change Description

```bash
backlog task edit 42 -d "Navigation menu collapses below 375px width on iOS Safari"
```

### Update Assignee and Labels

```bash
backlog task edit 42 -a @bob
backlog task edit 42 -l auth,backend,mobile

# Add a label without replacing existing
backlog task edit 42 --add-label regression

# Remove a specific label
backlog task edit 42 --remove-label mobile
```

### Implementation Plan (Before Coding)

Write the "how" before touching any code:

```bash
backlog task edit 42 --plan $'1. Reproduce bug on iOS Safari 375px\n2. Audit CSS breakpoints in nav.css\n3. Fix media query\n4. Add visual regression test\n5. Verify on 320px, 375px, 414px viewports'
```

### Implementation Notes (During Work)

Append progress notes as you work — **always append, never overwrite**:

```bash
# First update
backlog task edit 42 --append-notes "Reproduced: breakpoint at 380px overlaps with menu toggle"

# Later update
backlog task edit 42 --append-notes $'- Fixed breakpoint in nav.css line 47\n- Added test for 375px viewport'

# POSIX alternative
backlog task edit 42 --append-notes "$(printf 'Coverage: 92%%\nAll tests green')"
```

### Final Summary (PR Description)

Write once at completion — describes what changed and why for a reviewer:

```bash
backlog task edit 42 --final-summary $'Fixed mobile navigation collapse on viewports < 375px.\n\nRoot cause: CSS breakpoint at 380px clashed with menu toggle button (40px) at 380px. Fixed by adjusting breakpoint to 415px.\n\nChanges:\n- nav.css: adjusted breakpoint from 380px to 415px\n- Added visual regression test for 375px viewport\n\nTests: all pass. Tested on iOS Safari 15, Android Chrome 120.'
```

---

## Task Lifecycle and Status Transitions

### Default Status Flow

```
To Do → In Progress → Done
```

### Transition Examples

```bash
# Start working
backlog task edit 42 -s "In Progress" -a @alice

# Complete
backlog task edit 42 -s Done

# Return to backlog (e.g. blocked)
backlog task edit 42 -s "To Do"
```

### Lifecycle Field Summary

| Phase | Actions |
|---|---|
| **Creation** | Set title, description, AC, labels, priority, assignee |
| **Start work** | Set `In Progress`, assign, write Implementation Plan |
| **During work** | Append Implementation Notes progressively |
| **Completion** | Check all AC/DoD, write Final Summary, set `Done` |

---

## Acceptance Criteria Management

AC items use **1-based indices**. Indices are stable within each task.

### Before: View Current State

```bash
backlog task 42 --plain
# Shows:
# - [ ] #1 User can log in with GitHub
# - [ ] #2 Session persists across page reloads
# - [x] #3 Logout clears session
```

### Add Criteria

```bash
# Add one
backlog task edit 42 --ac "Rate limiting applied to login endpoint"

# Add multiple at once
backlog task edit 42 --ac "Password reset email sent within 30s" --ac "Reset link expires after 1 hour"
```

### Check Criteria (Mark Complete)

```bash
# Check one
backlog task edit 42 --check-ac 1

# Check multiple in one command
backlog task edit 42 --check-ac 1 --check-ac 2 --check-ac 3
```

> ⚠️ No ranges: `--check-ac 1,2,3` does **not** work. Use separate flags.

### Uncheck Criteria

```bash
backlog task edit 42 --uncheck-ac 2
```

### Remove Criteria

```bash
# Remove one
backlog task edit 42 --remove-ac 3

# Remove multiple (processed high-to-low to preserve remaining indices)
backlog task edit 42 --remove-ac 4 --remove-ac 2
```

### Mixed Operations in One Command

```bash
backlog task edit 42 \
  --check-ac 1 \
  --uncheck-ac 2 \
  --remove-ac 4 \
  --ac "New requirement added during review"
```

---

## Definition of Done Management

DoD items are a second checklist per task. Defaults come from `config.yml → definition_of_done`.

### Default DoD Items

When configured in `config.yml`:

```yaml
definition_of_done:
  - Tests pass
  - Code reviewed
  - Docs updated
```

These are automatically added to every new task. Disable per task with `--no-dod-defaults`.

### Add DoD Items

```bash
backlog task edit 42 --dod "Performance benchmarks pass (< 200ms p95)"
backlog task edit 42 --dod "Security review completed" --dod "Feature flagged"
```

### Check DoD Items

```bash
backlog task edit 42 --check-dod 1
backlog task edit 42 --check-dod 1 --check-dod 2
```

### Uncheck / Remove DoD Items

```bash
backlog task edit 42 --uncheck-dod 2
backlog task edit 42 --remove-dod 3
```

### Create Task Without Default DoD

```bash
backlog task create "Quick config fix" --no-dod-defaults
```

---

## Dependencies and Subtasks

### Set Dependencies

Task 42 depends on tasks 40 and 41 being complete first:

```bash
backlog task edit 42 --dep task-40 --dep task-41
```

### View Execution Order

```bash
backlog sequence list --plain
```

Output shows topological order — which tasks must complete before others can start.

### Create a Subtask

```bash
# Create subtask under task 42
backlog task create "Write unit tests for OAuth handler" -p 42

# List all subtasks of task 42
backlog task list -p 42 --plain
```

### Full Dependency Workflow Example

```bash
# Create parent task
backlog task create "Implement authentication system" --ac "All auth flows working"

# Create subtasks
backlog task create "Set up OAuth provider" -p 43
backlog task create "Implement login handler" -p 43 --dep task-44
backlog task create "Implement logout handler" -p 43 --dep task-44
backlog task create "Add session middleware" -p 43 --dep task-45 --dep task-46

# Check planned sequence
backlog sequence list --plain
```

---

## Summary: Before and After

### Before: Untracked work note

```
TODO: fix the nav bug on mobile - alice
```

### After: Properly tracked task

```bash
# Create
backlog task create "Fix mobile navigation collapse" \
  -d "Nav menu collapses on iOS Safari <375px" \
  -a @alice --priority high \
  --ac "Menu displays on 375px viewport" \
  --ac "Toggle visible all mobile sizes"

# Work: task-45
backlog task edit 45 -s "In Progress"
backlog task edit 45 --plan $'1. Reproduce\n2. Audit CSS\n3. Fix\n4. Test'
backlog task edit 45 --append-notes "Root cause: breakpoint clash at 380px"
backlog task edit 45 --append-notes "Fixed nav.css breakpoint to 415px"
backlog task edit 45 --check-ac 1 --check-ac 2
backlog task edit 45 --check-dod 1 --check-dod 2
backlog task edit 45 --final-summary "Fixed breakpoint in nav.css; added visual regression test"
backlog task edit 45 -s Done
```



