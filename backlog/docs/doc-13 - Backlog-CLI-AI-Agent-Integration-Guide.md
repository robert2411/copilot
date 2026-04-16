---
id: doc-13
title: Backlog CLI - AI Agent Integration Guide
type: guide
created_date: '2026-04-16'
---

# Backlog CLI — AI Agent Integration Guide

How AI agents (Claude, GitHub Copilot, Cursor, etc.) use Backlog CLI for autonomous task management.

---

## Table of Contents

1. [AI Agent Workflow Overview](#ai-agent-workflow-overview)
2. [The --plain Flag](#the---plain-flag)
3. [AC Scope Boundaries](#ac-scope-boundaries)
4. [Phase Discipline for Agents](#phase-discipline-for-agents)
5. [CLI Mode vs MCP Mode](#cli-mode-vs-mcp-mode)
6. [Annotated Full Session Example](#annotated-full-session-example)

---

## AI Agent Workflow Overview

The standard 10-step workflow for an AI agent implementing a task:

```
1. Find work          → backlog task list -s "To Do" --plain
2. Read task          → backlog task <id> --plain
3. Claim task         → backlog task edit <id> -s "In Progress" -a @agent
4. Write plan         → backlog task edit <id> --plan "..."
5. Await approval     → share plan with user; wait for confirmation
6. Implement          → write code; append notes as you progress
7. Check AC           → backlog task edit <id> --check-ac 1 --check-ac 2
8. Check DoD          → backlog task edit <id> --check-dod 1
9. Final summary      → backlog task edit <id> --final-summary "..."
10. Set Done          → backlog task edit <id> -s Done
```

**Critical constraint:** Step 5 is non-negotiable. Never write code before sharing the plan and receiving approval.

---

## The `--plain` Flag

### Why It Matters

All Backlog read commands can output either:
- **TUI mode** (default): Interactive terminal UI with colours, borders, keyboard navigation — not parseable by AI
- **`--plain` mode**: Clean text output — no escape sequences, structured and parseable

AI agents **must always** use `--plain` on read operations.

### Commands That Support `--plain`

```bash
backlog task list --plain
backlog task <id> --plain
backlog task view <id> --plain
backlog task list -s "In Progress" --plain
backlog task list -a @alice --plain
backlog task list -m "Milestone Name" --plain
backlog search "authentication" --plain
backlog draft list --plain
backlog draft view <id> --plain
backlog milestone list --plain
backlog doc list --plain
backlog sequence list --plain
```

### Plain Output Format

```
Task TASK-42 - Add OAuth login
==================================================

Status: ● In Progress
Priority: High
Assignee: @alice
Labels: auth, backend

Description:
--------------------------------------------------
Implement OAuth 2.0 login via GitHub

Acceptance Criteria:
--------------------------------------------------
- [ ] #1 User can log in with GitHub account
- [x] #2 Session persists across page reloads
- [ ] #3 Logout clears session completely
```

Parse this output to:
- Determine which AC items are complete (`[x]`) and which remain (`[ ]`)
- Read task description, plan, and notes for context
- Extract task ID for subsequent edit commands

---

## AC Scope Boundaries

### The Rule

**Only implement what is specified in the Acceptance Criteria.** Nothing more.

This prevents scope creep, keeps tasks atomic, and ensures reviews are predictable.

### When You Discover Extra Scope

**Before writing any code**, choose one:

**Option A — Extend the AC first:**

```bash
backlog task edit 42 --ac "Rate limiting applied to all auth endpoints"
# Now implement the extended scope
```

**Option B — Create a follow-up task:**

```bash
backlog task create "Add rate limiting to auth endpoints" \
  -d "Discovered during task-42: auth endpoints need rate limiting" \
  --dep task-42
# Continue implementing task-42 as originally scoped
```

**Never:** Silently implement beyond AC scope, then mark Done.

### Reading AC Before Implementation

Always read the task and identify exactly what each AC requires:

```bash
backlog task 42 --plain
# Read all AC items carefully
# For each unchecked AC: determine what code change satisfies it
# Mark each AC complete as you finish it, not all at once at the end
```

---

## Phase Discipline for Agents

### The Phases

| Phase | Agent Actions | Forbidden |
|---|---|---|
| **Claim** | Set In Progress, assign | Writing code |
| **Plan** | Write Implementation Plan, share with user | Writing code |
| **Implement** | Write code, append notes, check AC as done | Overwriting notes |
| **Complete** | Check all AC/DoD, write Final Summary, set Done | Skipping any step |

### Plan Before Code — Why Agents Must Enforce This

1. Plans can be caught before wasted implementation effort
2. Architectural issues are cheaper to fix at plan stage
3. Users can redirect scope without reviewing a diff
4. Plans create a record of intent separate from what was actually done

### Plan Approval Pattern

```bash
# Write plan
backlog task edit 42 --plan $'1. Analyse current auth flow\n2. Add GitHub OAuth provider config\n3. Implement callback handler\n4. Add session persistence\n5. Test all AC scenarios'

# Output plan to user in chat
# Then stop. Wait for explicit approval.
# Do not proceed to implementation until user says "approved", "go ahead", "lgtm", etc.
```

### Notes Are a Progress Log

```bash
# ✅ Append as you progress
backlog task edit 42 --append-notes "Analysed auth flow — no existing OAuth wiring"
backlog task edit 42 --append-notes "GitHub OAuth config added to .env.example"
backlog task edit 42 --append-notes $'Callback handler implemented\nSession middleware integrated'

# ❌ Never overwrite existing notes
backlog task edit 42 --notes "Done"  # destroys history
```

---

## CLI Mode vs MCP Mode

### CLI Mode

Agent runs shell commands against the Backlog CLI binary:

```bash
backlog task list -s "To Do" --plain
backlog task edit 42 -s "In Progress" -a @agent
backlog task edit 42 --plan "..."
```

**When to use CLI mode:**
- Agent has shell access
- No MCP client configured
- CI/CD scripts
- Agents using AGENTS.md / CLAUDE.md instructions

**Setup:**
```bash
backlog init "Project" --integration-mode cli --agent-instructions agents
# Generates AGENTS.md with Backlog CLI guide embedded
```

### MCP Mode

Agent calls structured tool calls via MCP server:

```
create_task({title: "Fix bug", description: "...", acceptanceCriteria: [...]})
edit_task({id: "task-42", status: "In Progress", assignee: "@agent"})
list_tasks({status: "To Do"})
```

**When to use MCP mode:**
- Claude Desktop with MCP config
- Cursor with MCP settings
- Any MCP-compliant client
- Prefer structured JSON over text parsing

**Setup:**
```bash
backlog init "Project" --integration-mode mcp
backlog mcp start  # start MCP server on stdio
```

### Comparison

| Aspect | CLI mode | MCP mode |
|---|---|---|
| Agent parses | Text (`--plain` output) | Structured JSON |
| Requires | Shell access | MCP client config |
| Error detection | Parse error messages | Structured error objects |
| Discovery | Read AGENTS.md/CLAUDE.md | `tools/list` tool call |
| Latency | Shell process spawn per call | Persistent connection |

---

## Annotated Full Session Example

A complete agent session from task discovery to Done:

```bash
# ── STEP 1: Find work ──────────────────────────────────────────────────────
backlog task list -s "To Do" --plain
# Output shows task-42: "Add OAuth login" (priority: high)

# ── STEP 2: Read task ──────────────────────────────────────────────────────
backlog task 42 --plain
# Agent reads: description, all AC items, references, DoD
# Identifies 3 AC items, all unchecked

# ── STEP 3: Claim task ─────────────────────────────────────────────────────
backlog task edit 42 -s "In Progress" -a @agent-copilot
# Task now owned by this agent; prevents other agents taking it

# ── STEP 4: Write implementation plan ──────────────────────────────────────
backlog task edit 42 --plan $'1. Inspect src/auth/ for existing wiring\n2. Add GitHub OAuth provider (passport-github2)\n3. Implement /auth/github and /auth/github/callback routes\n4. Add session persistence middleware\n5. Test AC #1 (login), AC #2 (session persist), AC #3 (logout)'
# Plan is written to task — not in chat

# ── STEP 5: Share plan + await approval ────────────────────────────────────
# Agent posts plan to user in conversation
# STOPS HERE. Does not write code until approved.
# User replies: "Looks good, go ahead"

# ── STEP 6: Implement — append notes as you progress ──────────────────────
# [agent writes code]
backlog task edit 42 --append-notes "Inspected src/auth/ — no existing OAuth; clean slate"
# [agent writes passport-github2 integration]
backlog task edit 42 --append-notes $'Added passport-github2\nRoutes /auth/github and callback implemented'
# [agent adds session middleware]
backlog task edit 42 --append-notes "Session middleware integrated; tested AC #2 manually"

# ── STEP 7: Mark AC complete as each is finished ───────────────────────────
# After implementing and verifying each AC:
backlog task edit 42 --check-ac 1    # "User can log in with GitHub" — verified
backlog task edit 42 --check-ac 2    # "Session persists" — verified
backlog task edit 42 --check-ac 3    # "Logout clears session" — verified

# ── STEP 8: Check DoD items ────────────────────────────────────────────────
backlog task edit 42 --check-dod 1   # "All tests pass" — run tests, confirmed

# ── STEP 9: Write Final Summary ────────────────────────────────────────────
backlog task edit 42 --final-summary $'Added GitHub OAuth login via passport-github2.\n\nChanges:\n- src/auth/github.ts: OAuth strategy + route handlers\n- src/middleware/session.ts: session persistence\n- package.json: passport-github2 dependency\n\nAll 3 AC verified. Tests: 8 new integration tests, all pass. No regressions.'

# ── STEP 10: Set Done ──────────────────────────────────────────────────────
backlog task edit 42 -s Done
# Task complete. Agent reports back to user/manager.
```

### Key Principles Demonstrated

- `--plain` on every read operation (steps 1, 2)
- Claim immediately to prevent race conditions (step 3)
- Plan written to task, not just in chat — creates permanent record (step 4)
- Hard stop before code until plan approved (step 5)
- Notes appended incrementally — history preserved (step 6)
- AC checked *as each is verified*, not all at the end (step 7)
- Final Summary written as a PR description, not a progress log (step 9)

