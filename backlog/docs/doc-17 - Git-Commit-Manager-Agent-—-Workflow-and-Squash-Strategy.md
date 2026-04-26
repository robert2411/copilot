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

## squash-task-commits.sh — Implementation Reference

**Script path:** `.github/skills/backlog-cli/scripts/squash-task-commits.sh`
**Delivered in:** TASK-44
**Compatibility:** bash 3.2+ (macOS) — no `mapfile`/`readarray` used

### Usage

```bash
# Preview without modifying history
.github/skills/backlog-cli/scripts/squash-task-commits.sh --dry-run

# Execute squash
.github/skills/backlog-cli/scripts/squash-task-commits.sh
```

### Flags

| Flag | Behaviour |
|------|-----------|
| *(none)* | Execute squash on current history |
| `--dry-run` | Print planned operations, exit 0, no history changes |

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success, nothing to squash, or dry-run complete |
| `1` | Dirty working tree, unrecognised flag, or script error |

### Algorithm (Detailed)

1. **Dirty-tree guard** — `git status --porcelain`; exits 1 with message if non-empty.
2. **Read log** — `git log --format="%H|%s" -100` (last 100 commits, newest-first). Uses `while IFS='|' read -r hash subject` for bash 3.2 compatibility.
3. **Extract task-id** — bash regex `^(task-[^:]+):` applied to each subject. Non-matching commits get an empty task-id.
4. **Find consecutive runs** — walks newest-first; tracks `current_tid` and span indices. A run of ≥ 2 consecutive commits with the same non-empty task-id is recorded. A commit with a different task-id (or no task-id) closes the current run.
5. **Idempotent exit** — if zero qualifying runs found, prints `"Nothing to squash."` and exits 0.
6. **Dry-run output** — if `--dry-run`, prints one line per run: `[DRY-RUN] Would squash <N> commits for <task-id> into one commit`, then exits 0.
7. **Oldest-first processing** — runs are sorted by `end_idx` descending (oldest run first) using a bubble sort on a processing-order array. This prevents SHA invalidation: rebasing older history does not affect the SHAs of newer (closer to HEAD) runs that have not yet been processed.
8. **Per-run rebase** — for each qualifying run:
   - Computes window size `N = end_idx + 1` (commits from HEAD to cover).
   - Re-reads `git log --format="%H|%s" --reverse "HEAD~${N}..HEAD"` for current SHAs (post any prior rebase).
   - Locates the first consecutive block of `task_id` commits in the window (oldest-first).
   - Builds a `mktemp` rebase-todo file: first run commit → `pick`, remaining → `fixup`, all others → `pick`.
   - Runs `GIT_SEQUENCE_EDITOR="cp <todo_file>" git rebase -i "HEAD~${N}"` non-interactively.
   - Deletes temp file; re-reads git log to refresh in-memory SHAs for the next iteration.
9. **Completion** — prints `"Squash complete."` and exits 0.

### Key Design Choices

| Choice | Rationale |
|--------|-----------|
| Depth cap at `-100` | Bounded blast radius; consecutive same-task commits always occur in recent history |
| Oldest-first processing | Rebasing old commits does not invalidate SHAs of newer un-processed commits |
| `GIT_SEQUENCE_EDITOR` + `mktemp` | Non-interactive rebase with full control over the todo file; no user prompt |
| Re-read log after each rebase | SHAs change after rebase; stale in-memory hashes would fail subsequent rebases |
| `while IFS= read -r` instead of `mapfile` | `mapfile`/`readarray` requires bash 4+; macOS ships bash 3.2 |
| Case-sensitive task-id regex | Canonical commit format is always lowercase `task-<id>:`; no `shopt -s nocasematch` needed |

### Verified Test Cases (TASK-44)

| Scenario | Result |
|----------|--------|
| Dirty working tree | Exits 1 with error message ✅ |
| No consecutive runs | "Nothing to squash." exits 0 ✅ |
| `[task-1, task-1, task-3, task-1]` | `[task-1, task-3, task-1]` ✅ |
| `[task-1, task-1, task-1, task-3]` | `[task-1, task-3]` ✅ |
| Two non-adjacent runs simultaneously | Both squashed in one invocation ✅ |
| Run twice on already-squashed history | "Nothing to squash." (idempotent) ✅ |
| `--dry-run` | Prints plan, no history changes ✅ |

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
