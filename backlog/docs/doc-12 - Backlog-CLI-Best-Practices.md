---
id: doc-12
title: Backlog CLI - Best Practices
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — Best Practices

Patterns and anti-patterns for using Backlog CLI effectively.

---

## Table of Contents

1. [Phase Discipline](#phase-discipline)
2. [Acceptance Criteria Writing](#acceptance-criteria-writing)
3. [Multi-Task Workflow Patterns](#multi-task-workflow-patterns)
4. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
5. [Git Integration and Branching](#git-integration-and-branching)

---

## Phase Discipline

Every task has four phases. Respecting phase boundaries keeps work traceable and reviewable.

### Phase 1: Creation

**What belongs here:** Title, Description, Acceptance Criteria, labels, priority, assignee.  
**What does NOT belong here:** Implementation Plan, notes, code decisions.

```bash
backlog task create "Add rate limiting to API" \
  -d "Protect public endpoints from abuse; target <100 req/min per IP" \
  --ac "Requests above limit receive 429 response" \
  --ac "Retry-After header included in 429 response" \
  --ac "Limit is configurable per endpoint" \
  --priority high \
  -l backend,security
```

### Phase 2: Start Work

**What belongs here:** Set In Progress, assign yourself, write Implementation Plan.  
**Rule:** Write the plan *before* touching any code.

```bash
# Claim the task
backlog task edit 42 -s "In Progress" -a @alice

# Write the plan
backlog task edit 42 --plan $'1. Audit current middleware stack\n2. Evaluate express-rate-limit vs custom\n3. Implement per-route config\n4. Add integration tests\n5. Verify AC scenarios'
```

> **Why plan first?** Forces you to think through the approach before committing to code. Plans can be reviewed, challenged, and improved cheaply.

### Phase 3: During Work

**What belongs here:** Append Implementation Notes as you progress.  
**Rule:** Always *append* — never overwrite. Notes are a progress log.

```bash
# Good: append preserves history
backlog task edit 42 --append-notes "Chose express-rate-limit: battle-tested, supports per-route config"
backlog task edit 42 --append-notes $'- Implemented per-route config via options object\n- Tests added for 429 and Retry-After\n- Coverage: 87%'

# Bad: replace discards history
backlog task edit 42 --notes "done"  # ❌ Overwrites all previous notes
```

### Phase 4: Completion

**What belongs here:** Check all AC/DoD items, write Final Summary, set Done.  
**Rule:** Never set Done without all AC/DoD checked and Final Summary written.

```bash
# Check all AC
backlog task edit 42 --check-ac 1 --check-ac 2 --check-ac 3

# Check all DoD
backlog task edit 42 --check-dod 1 --check-dod 2

# Write Final Summary (PR description quality)
backlog task edit 42 --final-summary $'Added per-route rate limiting to public API endpoints.\n\nApproach: express-rate-limit with per-route config object; limits stored in config.yml.\n\nChanges:\n- middleware/rateLimiter.ts: new middleware factory\n- routes/api.ts: limits applied to /search, /auth endpoints\n- config.yml: rateLimit section added\n\nTests: 12 new integration tests; all pass. No regressions.'

# Set Done
backlog task edit 42 -s Done
```

---

## Acceptance Criteria Writing

AC items define the scope boundary of a task. Write them well.

### Principles

| Principle | Description |
|---|---|
| **Outcome-oriented** | Describe the result, not the implementation method |
| **Testable/verifiable** | Each item must be objectively verifiable |
| **User-focused** | Frame from end-user or system behaviour perspective |
| **Concise** | One criterion per item; unambiguous language |
| **Complete** | Together, they define the full scope |

### Good vs Bad Examples

| ❌ Bad (Implementation step) | ✅ Good (Outcome) |
|---|---|
| "Add `handleLogin()` function in auth.ts" | "User can log in with valid credentials" |
| "Define expected behaviour in docs" | "System returns 401 with error message on invalid credentials" |
| "Write tests for edge cases" | "Login with special characters in password succeeds" |
| "Update the config parser" | "Config changes take effect without server restart" |

### AC as Scope Boundary

Only implement what the AC specifies. If you discover extra scope is needed:

**Option A:** Add a new AC before coding:
```bash
backlog task edit 42 --ac "Concurrent login attempts are queued, not dropped"
```

**Option B:** Create a follow-up task:
```bash
backlog task create "Handle concurrent login queue" \
  -d "Follow-up from task-42: concurrent logins need queuing" \
  --dep task-42
```

**Never:** Silently implement beyond the AC and claim Done.

---

## Multi-Task Workflow Patterns

### Dependency Ordering

Foundation tasks first. Features depend on foundations.

```bash
# Wrong: create feature first, then foundation
backlog task create "Add OAuth login"          # needs auth middleware
backlog task create "Implement auth middleware" # should have been first

# Right: foundation first
backlog task create "Implement auth middleware" --priority high
backlog task create "Add OAuth login" --dep task-43  # depends on middleware
```

### Board-Driven Triage

Use the board to visualise flow and spot bottlenecks:

```bash
backlog board                         # see all columns
backlog board -m                      # group by milestone
backlog board export status.md        # snapshot for async review
```

Look for:
- Columns with too many "In Progress" tasks (WIP limit exceeded)
- "To Do" pile growing faster than "Done" column

### Search-Driven Discovery

Before creating a task, search to avoid duplicates:

```bash
backlog search "rate limiting" --plain
backlog search "auth middleware" --type task --plain
```

### Milestone Planning

Group related tasks under milestones for progress tracking:

```bash
backlog milestone list --plain    # see % completion per milestone
```

Assign tasks to milestones at creation or edit:

```bash
backlog task create "Feature X" -m "Q2 Launch"
backlog task edit 42 -m "Q2 Launch"
```

---

## Anti-Patterns to Avoid

### ❌ Direct File Editing

```bash
# NEVER do this:
vim backlog/tasks/task-42\ -\ Add-OAuth-login.md
# Then manually change "- [ ] #1" to "- [x] #1"
```

**Why it breaks things:** Bypasses Git commit tracking, metadata sync, and relationship management.

**Do this instead:**
```bash
backlog task edit 42 --check-ac 1
```

### ❌ Skipping the Implementation Plan

```bash
# Bad: jump straight to code
backlog task edit 42 -s "In Progress"
# [immediately start coding without a plan]

# Good: plan first
backlog task edit 42 -s "In Progress" -a @alice
backlog task edit 42 --plan $'1. Research\n2. Design\n3. Implement\n4. Test'
# [share plan, await approval, then code]
```

### ❌ Marking Done Without All AC/DoD Checked

```bash
# Bad: done without verification
backlog task edit 42 -s Done  # ❌ AC still unchecked

# Good: verify everything first
backlog task edit 42 --check-ac 1 --check-ac 2 --check-ac 3
backlog task edit 42 --check-dod 1 --check-dod 2
backlog task edit 42 --final-summary "..."
backlog task edit 42 -s Done  # ✅
```

### ❌ Mixing Phases

```bash
# Bad: adding notes during creation
backlog task create "Fix bug" --notes "Already know the fix, it's in line 42"

# Bad: writing implementation plan at completion
backlog task edit 42 --plan "..."  # plan belongs at start of work, not end

# Good: plan at start, notes during, summary at end
```

### ❌ Overwriting Notes History

```bash
# Bad: replaces entire history
backlog task edit 42 --notes "Finished"

# Good: preserves history
backlog task edit 42 --append-notes "Finished - all tests pass"
```

---

## Git Integration and Branching

### Auto-Commit Behaviour

Backlog auto-commits task file changes to Git on every CLI write. Each `backlog task edit` produces a Git commit. This means:
- Full history of task changes in `git log`
- Every status transition is version-controlled
- Diffs show exactly what changed in task metadata

### Branch-Aware Task States

When `checkActiveBranches` is enabled (default), Backlog scans Git branches to track task states:

```bash
backlog config get checkActiveBranches  # true/false
backlog config set checkActiveBranches true
backlog config set activeBranchDays 30  # branches older than 30 days = inactive
```

This means a task can show different apparent states on different branches — useful for tracking work-in-progress per branch.

### Recommended Branching Strategy

Work on feature branches and use task IDs in branch names:

```bash
git checkout -b task-42/add-oauth-login

# Work, commit normally
git add .
git commit -m "Implement OAuth handler"

# Backlog CLI auto-commits task changes on same branch
backlog task edit 42 --append-notes "Handler implemented"

# Merge when done
git checkout main
git merge task-42/add-oauth-login
backlog task edit 42 -s Done
```

### Bypassing Git Hooks

If pre-commit hooks slow down Backlog auto-commits:

```bash
backlog config set bypassGitHooks true
```

Use with care — bypasses linting and test hooks on task commits.

