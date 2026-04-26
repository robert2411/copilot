---
id: doc-17
title: Git Commit Manager Agent — Workflow and Squash Strategy
type: other
created_date: '2026-04-26'
---

# Git Commit Manager Agent — Workflow and Squash Strategy

## Overview

The **git-commit-manager agent** is the final pipeline gate before the manager marks a task Done. It guarantees a
canonical, clean git history by staging all pending changes, committing with a standardised message format, and
squashing consecutive same-task commits into a single commit.

**Agent file:** `.github/agents/git-commit-manager.agent.md`
**Frontmatter:** `user-invocable: false` — invoked by the manager only
**Color:** `#E88C2A`
**Model:** inherited (no `model` key — same pattern as documentation and implementation agents)

---

## Pipeline Position

```
Implementation → QA → Security → Documentation → Git Commit Manager → Done
```

The manager routes to git-commit-manager after documentation emits `✅ DOCUMENTATION COMPLETE`.

---

## How the Manager Invokes the Git Commit Manager Agent

After documentation emits `✅ DOCUMENTATION COMPLETE`, the manager calls:

```
run_subagent with agentName: "git-commit-manager"

Task string MUST include:
- Task ID (e.g. TASK-42)
- Task title (e.g. "Create git commit manager agent file")
- Instruction to stage, commit, squash, and emit ✅ COMMIT COMPLETE via backlog task edit
```

After the subagent completes, the manager reads the task notes:

```bash
backlog task <id> --plain
```

- If `✅ COMMIT COMPLETE` found → mark task Done
- If signal absent → log warning, mark task Done (non-blocking fallback — mirrors documentation agent pattern)

---

## 6-Step Workflow

### Step 1 — Verify Working State

```bash
git status --porcelain
```

Confirm the tree is in a known state. Proceed regardless of clean or dirty — `git add -A` in the next step will capture
everything. If the tree is dirty from a prior crash, log a note and continue.

### Step 2 — Stage All Changes

```bash
git add -A
```

Stages every modified, deleted, and untracked file — including `backlog/`, `docs/`, and all source files. No selective
staging; the agent always stages everything.

### Step 3 — Commit

```bash
git commit -m "task-<id>: <title>"
```

Uses the exact task ID and title passed in by the manager. Examples:
- `git commit -m "TASK-42: Create git commit manager agent file"`
- `git commit -m "TASK-7: Add user authentication module"`

If nothing to commit (working tree already clean after `git add -A`), skip commit and proceed to Step 4.

### Step 4 — Dry-Run Squash (POST-Commit)

```bash
.github/skills/backlog-cli/scripts/squash-task-commits.sh --dry-run
```

Runs **after** the new commit is in history so it reflects the actual post-commit state the live squash will see. The
dry-run output is logged to task notes via:

```bash
backlog task edit <id> --append-notes "<dry-run output>"
```

> **⚠️ Architecture note:** the dry-run MUST run POST-commit (not pre-commit). A pre-commit dry-run would preview
> a state that excludes the new commit, making the preview misleading and uninformative.

### Step 5 — Live Squash

```bash
.github/skills/backlog-cli/scripts/squash-task-commits.sh
```

Executes the actual squash. Two outcomes:

| Exit code | Action |
|-----------|--------|
| 0 (success) | Proceed to Step 6 |
| non-zero (failure) | Append warning note to task; stop — do NOT emit `✅ COMMIT COMPLETE` |

Squash failures are treated as **warnings, not pipeline halts**. The manager decides whether to retry.

### Step 6 — Emit Commit-Complete Signal

```bash
backlog task edit <id> --append-notes "✅ COMMIT COMPLETE: task-<id>: <title>"
```

The manager polls for this signal to confirm the git-commit-manager finished successfully.

---

## Squash Logic

The squash script (`squash-task-commits.sh`) inspects the recent git log for consecutive commits sharing the same
`task-<id>` prefix and squashes them into one commit.

### Rule

- **Consecutive same-task commits** → squash into one
- **Non-consecutive same-task commits** (another task's commit sits between them) → preserve boundary, do NOT squash

### Examples

| Before squash | After squash |
|---------------|--------------|
| `[task-1, task-1, task-3, task-1]` | `[task-1, task-3, task-1]` |
| `[task-1, task-1, task-1, task-3]` | `[task-1, task-3]` |
| `[task-1, task-2, task-1]` | `[task-1, task-2, task-1]` (no change — non-consecutive) |

The agent does NOT implement squash logic itself — it always delegates to `squash-task-commits.sh`.

---

## FORBIDDEN Block Carve-Out

All agents in this system follow the rule: **🚫 FORBIDDEN — never write directly to `./backlog/`**.

For the git-commit-manager, `run_in_terminal` is permitted **only** for:

| Permitted commands | Examples |
|--------------------|---------|
| Git commands | `git status`, `git add`, `git commit`, `git log`, `git rebase` |
| Squash script | `.github/skills/backlog-cli/scripts/squash-task-commits.sh` |
| Backlog CLI | `backlog task edit <id> --append-notes` |

All other `run_in_terminal` usage (arbitrary shell commands, file writes, etc.) remains FORBIDDEN.

---

## Signal Formats

### Success

```
✅ COMMIT COMPLETE: task-<id>: <title>
```

### Squash Failure (warning)

```
⚠️ SQUASH WARNING: squash-task-commits.sh exited non-zero. Commit was made but squash was not applied.
Exit code: <N>
```

---

## Constraints

1. DON'T edit task files directly — DO use `backlog task edit`
2. DON'T run the squash script on a dirty tree — the script itself exits non-zero on dirty tree; treat that as a blocker
3. DON'T skip `git add -A` — always stage everything including `backlog/` directory
4. DON'T squash manually — always delegate squashing to `squash-task-commits.sh`
5. DON'T emit `✅ COMMIT COMPLETE` if squash script fails
6. DON'T run dry-run before committing — the dry-run must run AFTER the new commit is made (Step 4) so it reflects actual post-commit history

---

## Related Documentation

- **doc-6** — Agent Workflow Orchestration System (pipeline phases, agent responsibilities)
- **doc-15** — Security Agent Integration and Agent Pipeline Improvements (full pipeline flow, role mapping)
- **doc-16** — Documentation Agent — Integration and Pipeline Flow (documentation agent, which precedes this agent)
- **`.github/agents/git-commit-manager.agent.md`** — The agent system prompt itself
- **`.github/skills/backlog-cli/scripts/squash-task-commits.sh`** — Squash script (TASK-44)
