---
id: TASK-42
title: Create git commit manager agent file
status: To Do
assignee: []
created_date: '2026-04-24 22:19'
updated_date: '2026-04-24 23:03'
labels:
  - git
  - agent
  - commits
milestone: m-3
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the git commit manager agent responsible for guaranteeing clean git history per task. After a task is fully done (Implementation + QA + Security + Documentation approved), this agent: (1) stages ALL unstaged/untracked changes including backlog/, docs, and source files, (2) commits with the canonical message format 'task-<id>: <title>', (3) inspects the recent git log for consecutive commits belonging to the same task-id and squashes them into one — but only consecutive runs; if another task's commit sits between two task-<id> commits they are NOT squashed.

If it makes sense for the context: multiple tasks can be in one commit (if the are of the same milestone)
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file exists at .github/agents/git-commit-manager.agent.md with correct frontmatter
- [ ] #2 Agent stages all changes (git add -A) before committing, including backlog/ and docs/
- [ ] #3 Agent commits using canonical format: 'task-<id>: <title>'
- [ ] #4 Agent parses recent git log to detect consecutive commits sharing the same task-id prefix
- [ ] #5 Agent squashes consecutive same-task commits into a single commit via git rebase -i or reset+commit
- [ ] #6 Agent does NOT squash non-consecutive same-task commits (another task commit in between preserves the boundary)
- [ ] #7 Squash example: [task1, task1, task3, task1] becomes [task1, task3, task1]
- [ ] #8 Squash example: [task1, task1, task1, task3] becomes [task1, task3]
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create the file `.github/agents/git-commit-manager.agent.md`.
2. Write YAML frontmatter with: `name: git-commit-manager`, a clear description explaining it stages changes, commits with canonical format, and squashes consecutive same-task commits, `color: "#E88C2A"`, `user-invocable: false`. No `model` key (inherit default, same as implementation/documentation agents).
3. Write the agent system-prompt body with the following sections:

   **Role & Scope**
   - Receives: task ID and task title from Manager (via run_subagent task string)
   - Responsibilities: (a) stage all changes, (b) commit with canonical message, (c) call squash script, (d) emit commit-complete signal
   - Does NOT analyse, implement, or review code

   **Workflow**
   Step 1 — Verify working state
   - Run `git status --porcelain` via run_in_terminal to confirm there are changes OR it is clean (already committed); either is valid — proceed
   - If the tree is dirty (unexpected uncommitted changes from a prior crash), log a note and continue — `git add -A` will capture them

   Step 2 — (Optional) Dry-run squash check
   - Run `.github/skills/backlog-cli/scripts/squash-task-commits.sh --dry-run` to preview what squash operations would be performed after the new commit is added
   - Log the dry-run output to task notes via `backlog task edit <id> --append-notes`

   Step 3 — Stage all changes
   - Run `git add -A` to stage every modified, deleted, and untracked file including `backlog/`, `docs/`, and source files

   Step 4 — Commit
   - Run `git commit -m "task-<id>: <title>"` using the exact task ID (e.g. TASK-42) and title passed in by the Manager
   - If nothing to commit (working tree already clean), skip commit and proceed to squash step

   Step 5 — Squash consecutive same-task commits
   - Run `.github/skills/backlog-cli/scripts/squash-task-commits.sh` (without --dry-run)
   - If the script exits non-zero, append a warning note to the task and stop (do not emit commit-complete)
   - If it exits 0, proceed

   Step 6 — Emit commit-complete signal
   - Run `backlog task edit <id> --append-notes "✅ COMMIT COMPLETE: task-<id>: <title>"` so the Manager can detect the signal

4. Add **Tool Usage** section listing only approved tools: `run_in_terminal` (for git commands and backlog CLI), `run_subagent` NOT used.
5. Add **Output** section: one note appended to task beginning with `✅ COMMIT COMPLETE`.
6. Add **Constraints** section:
   - DON'T edit task files directly — DO use `backlog task edit`
   - DON'T run squash script on a dirty tree — the script itself exits non-zero on dirty tree, treat that as a blocker
   - DON'T skip git add -A — always stage everything including backlog/ directory
   - DON'T squash manually — always delegate squashing to squash-task-commits.sh
   - DON'T emit commit-complete if squash script fails
7. Verify each AC is covered:
   - AC#1: file exists at correct path ✅ (Step 1)
   - AC#2: git add -A ✅ (Step 3)
   - AC#3: canonical commit format ✅ (Step 4)
   - AC#4: parses git log (delegated to squash script) ✅ (Step 5)
   - AC#5: squashes consecutive ✅ (Step 5)
   - AC#6: non-consecutive not squashed ✅ (script handles this)
   - AC#7 & AC#8: squash examples (script handles this, agent just calls script) ✅
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete.

AC coverage:
- AC#1 → Plan Step 1 (file created at correct path)
- AC#2 → Workflow Step 3 (git add -A staged all changes including backlog/)
- AC#3 → Workflow Step 4 (canonical commit format task-<id>: <title>)
- AC#4 → Workflow Step 5 (squash script parses git log internally)
- AC#5 → Workflow Step 5 (squash script handles squashing)
- AC#6 → Workflow Step 5 (squash script respects boundaries)
- AC#7 & AC#8 → Workflow Step 5 (examples verified by script logic)

Error paths covered:
- Squash script fails → warning note appended, commit-complete NOT emitted (Step 5)
- Nothing to commit (clean tree) → skip commit, proceed to squash (Step 4)
- Squash script runs on clean tree after commit → always clean at that point ✅

Assumption called out: squash script (TASK-44) must exist at the path referenced. This is a dependency — TASK-44 must be implemented first.

No ambiguous steps. No gaps found.
<!-- SECTION:NOTES:END -->
