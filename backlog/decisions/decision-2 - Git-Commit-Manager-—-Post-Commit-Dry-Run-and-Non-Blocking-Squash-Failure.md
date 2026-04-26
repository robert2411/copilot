---
id: decision-2
title: Git Commit Manager — Post-Commit Dry-Run and Non-Blocking Squash Failure
status: Accepted
date: '2026-04-26'
task: TASK-42
---

# Git Commit Manager — Post-Commit Dry-Run and Non-Blocking Squash Failure

## Context

TASK-42 introduced the `git-commit-manager` agent — the final pipeline gate before a task is marked Done. The agent
stages all changes, commits with a canonical message (`task-<id>: <title>`), then calls a squash script
(`squash-task-commits.sh`) to collapse consecutive same-task commits into one.

Two architectural decisions were required during design:

1. **When should the dry-run squash check execute — before or after the new commit?**
2. **Should a squash script failure block the pipeline (hard stop) or be a warning (soft stop)?**

---

## Decision 1: Dry-Run Runs POST-Commit

### Options Considered

**Option A — Pre-commit dry-run:**
Run `squash-task-commits.sh --dry-run` BEFORE `git commit`. The dry-run would preview squash operations on the
existing history, excluding the new commit about to be made.

**Option B — Post-commit dry-run (chosen):**
Run `squash-task-commits.sh --dry-run` AFTER `git commit`. The dry-run previews the actual post-commit history state
that the live squash will operate on.

### Decision

**Option B — Post-commit dry-run** was accepted.

### Rationale

A pre-commit dry-run operates on a history state that does not include the commit being added. The squash script
inspects consecutive same-task commit runs; if the new commit would extend a consecutive run (most common case), the
pre-commit preview would NOT show that extension. The resulting dry-run output would be misleading — it would display
fewer squash operations than will actually occur, or none at all, giving false confidence.

A post-commit dry-run reflects the same git history state the live squash will see, making the preview accurate and
informative.

### Consequences

- Step 4 (dry-run) must always follow Step 3 (commit) in the agent workflow
- If the commit is skipped (nothing to commit), the dry-run still runs on the current HEAD — this is fine because the
  squash script handles a clean tree gracefully
- Agent prompt documentation must explicitly state the ordering constraint to prevent future regressions

---

## Decision 2: Squash Failure is a Warning, Not a Pipeline Halt

### Options Considered

**Option A — Hard stop (blocking):**
If `squash-task-commits.sh` exits non-zero, the agent emits an error and the manager cannot proceed. The task remains
In Progress until a manual intervention or retry resolves the squash failure.

**Option B — Soft stop / warning (chosen):**
If `squash-task-commits.sh` exits non-zero, the agent appends a warning note to the task and does NOT emit
`✅ COMMIT COMPLETE`. The manager detects the absent signal, logs a warning, and may choose to retry or proceed.

### Decision

**Option B — Soft stop / warning** was accepted.

### Rationale

The commit itself (Step 3) has already succeeded before the squash script runs. The code change is safely in history.
Squashing is a history-cleanliness optimisation, not a correctness requirement. Blocking the entire pipeline on a
squash failure would hold back a fully implemented, QA-approved, security-approved, and documented task simply because
git history wasn't tidied — an unacceptable availability/correctness trade-off for a cosmetic operation.

By treating squash failure as a warning:
- The commit is preserved in history (no work is lost)
- The manager can inspect the warning and decide whether to retry the squash or mark the task Done anyway
- The pipeline is not stuck behind a fixable infrastructure issue (e.g. rebase conflict due to concurrent pushes)

### Consequences

- The manager MUST check for the `✅ COMMIT COMPLETE` signal and handle its absence explicitly
- A missing signal does not mean the commit failed — it means squash failed after a successful commit
- The warning note appended to the task provides enough context for a human or manager to diagnose the squash failure
- The pattern is consistent with the documentation agent's non-blocking fallback (also a soft stop)

---

## Summary

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Dry-run timing | POST-commit (Step 4 after Step 3) | Pre-commit dry-run is misleading; post-commit reflects actual squash state |
| Squash failure severity | Warning (soft stop) | Commit already succeeded; squashing is cosmetic; blocking would be disproportionate |

---

## Related

- **TASK-42** — Create git commit manager agent file
- **TASK-44** — Create squash-task-commits.sh script
- **doc-17** — Git Commit Manager Agent — Workflow and Squash Strategy
- **decision-1** — Allow Direct File Editing of backlog/docs and backlog/decisions in Documentation Agent
