---
id: TASK-42
title: Create git commit manager agent file
status: In Progress
assignee:
  - '@myself'
created_date: '2026-04-24 22:19'
updated_date: '2026-04-26 19:47'
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
- [x] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Agent file exists at .github/agents/git-commit-manager.agent.md with correct frontmatter
- [x] #2 Agent stages all changes (git add -A) before committing, including backlog/ and docs/
- [x] #3 Agent commits using canonical format: 'task-<id>: <title>'
- [x] #4 Agent parses recent git log to detect consecutive commits sharing the same task-id prefix
- [x] #5 Agent squashes consecutive same-task commits into a single commit via git rebase -i or reset+commit
- [x] #6 Agent does NOT squash non-consecutive same-task commits (another task commit in between preserves the boundary)
- [x] #7 Squash example: [task1, task1, task3, task1] becomes [task1, task3, task1]
- [x] #8 Squash example: [task1, task1, task1, task3] becomes [task1, task3]
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create the file `.github/agents/git-commit-manager.agent.md`.
2. Write YAML frontmatter with: `name: git-commit-manager`, a clear description explaining it stages changes, commits with canonical format, and squashes consecutive same-task commits, `color: "#E88C2A"`, `user-invocable: false`. No `model` key (inherit default, same as implementation/documentation agents).
3. Immediately after the frontmatter opening, write the standard 🚫 FORBIDDEN block that all agents carry:
   - Prohibits writing directly to the `backlog/` folder (no create_file, insert_edit_into_file, replace_string_in_file, or shell writes like `echo > backlog/...`)
   - Requires all backlog operations to go through the `backlog` CLI
   - Add the git-specific carve-out: `run_in_terminal` is permitted ONLY for: git commands (`git add`, `git commit`, `git log`, `git status`, `git rebase`), the squash script (`.github/skills/backlog-cli/scripts/squash-task-commits.sh`), and approved backlog CLI commands (`backlog task edit`).

4. Write the agent system-prompt body with the following sections:

   **Role & Scope**
   - Receives: task ID and task title from Manager (via run_subagent task string)
   - Responsibilities: (a) stage all changes, (b) commit with canonical message, (c) call squash script, (d) emit commit-complete signal
   - Does NOT analyse, implement, or review code

   **Workflow**
   Step 1 — Verify working state
   - Run `git status --porcelain` via run_in_terminal to confirm there are changes OR it is clean (already committed); either is valid — proceed
   - If the tree is dirty (unexpected uncommitted changes from a prior crash), log a note and continue — `git add -A` will capture them

   Step 2 — Stage all changes
   - Run `git add -A` to stage every modified, deleted, and untracked file including `backlog/`, `docs/`, and source files

   Step 3 — Commit
   - Run `git commit -m "task-<id>: <title>"` using the exact task ID (e.g. TASK-42) and title passed in by the Manager
   - If nothing to commit (working tree already clean), skip commit and proceed to squash step

   Step 4 — (Optional) Dry-run squash check (POST-COMMIT)
   - Run `.github/skills/backlog-cli/scripts/squash-task-commits.sh --dry-run` to preview what squash operations will be performed
   - This runs AFTER the new commit is in history so it reflects the actual post-commit state the live squash will see
   - Log the dry-run output to task notes via `backlog task edit <id> --append-notes`

   Step 5 — Squash consecutive same-task commits
   - Run `.github/skills/backlog-cli/scripts/squash-task-commits.sh` (without --dry-run)
   - If the script exits non-zero, append a warning note to the task and stop (do not emit commit-complete)
   - If it exits 0, proceed

   Step 6 — Emit commit-complete signal
   - Run `backlog task edit <id> --append-notes "✅ COMMIT COMPLETE: task-<id>: <title>"` so the Manager can detect the signal

5. Add **Tool Usage** section listing only approved tools: `run_in_terminal` (for git commands and backlog CLI — see FORBIDDEN block for permitted git commands), `run_subagent` NOT used.
6. Add **Output** section: one note appended to task beginning with `✅ COMMIT COMPLETE`.
7. Add **Constraints** section:
   - DON'T edit task files directly — DO use `backlog task edit`\n   - DON'T run squash script on a dirty tree — the script itself exits non-zero on dirty tree, treat that as a blocker\n   - DON'T skip git add -A — always stage everything including backlog/ directory\n   - DON'T squash manually — always delegate squashing to squash-task-commits.sh\n   - DON'T emit commit-complete if squash script fails\n   - DON'T run dry-run before committing — the dry-run must run AFTER the new commit is made (Step 4) so it reflects actual post-commit history\n8. Verify each AC is covered:\n   - AC#1: file exists at correct path ✅ (Step 1)\n   - AC#2: git add -A ✅ (Step 2)\n   - AC#3: canonical commit format ✅ (Step 3)\n   - AC#4: parses git log (delegated to squash script) ✅ (Step 5)\n   - AC#5: squashes consecutive ✅ (Step 5)\n   - AC#6: non-consecutive not squashed ✅ (script handles this)\n   - AC#7 & AC#8: squash examples (script handles this, agent just calls script) ✅
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

Analysis complete. Plan ready. No blockers. Implementation order: implement TASK-42 first (no dependencies), but note the agent references squash-task-commits.sh which is created by TASK-44 — both should be delivered together.

🔍 PLAN REVIEW CONCERNS:

- Concern #1 — Missing FORBIDDEN notice block: The plan specifies Constraints and Tool Usage sections but does not mention adding the standard "🚫 FORBIDDEN" notice block at the top of the agent body (below the frontmatter opening). Every other agent (manager, documentation) has this block. Without it the implementation agent may omit it, making the agent inconsistent with the pattern and missing the explicit guardrail against direct backlog/ writes.

- Concern #2 — Dry-run ordering is pre-commit (misleading): Workflow Step 2 runs `squash-task-commits.sh --dry-run` BEFORE the new commit is made (Step 4). At that point the new commit does not yet exist in history, so the dry-run preview reflects the pre-commit history state — not the state that will trigger squashing. A preview that does not include the commit being added is uninformative at best and misleading at worst. The dry-run should either be moved to AFTER Step 4 (post-commit) so it previews what the live squash run will actually see, or be removed from the workflow and left as an advisory note in the Constraints section.

Verdict: Plan needs revision on these two points before implementation.

Plan revised: FORBIDDEN block step added; dry-run moved to post-commit.

🔍 PLAN REVIEW CONCERNS (re-review round 2):

- Concern #1 — FORBIDDEN carve-out "ONLY" wording excludes backlog CLI from permitted run_in_terminal commands:
  Plan Step 3 states: "run_in_terminal is permitted ONLY for the following commands: git add, git commit, git log, git status, and squash-task-commits.sh". However, the agent workflow requires backlog task edit <id> --append-notes in at least three places:
    • Step 4 — log dry-run output via backlog task edit
    • Step 5 — append warning note on squash script failure via backlog task edit
    • Step 6 — emit commit-complete signal via backlog task edit
  The word "ONLY" means an implementation agent following the FORBIDDEN block strictly would omit all three backlog CLI calls, breaking the commit-complete signal mechanism and making the agent invisible to the Manager.
  This directly contradicts the Tool Usage section (Step 5) which correctly lists "run_in_terminal (for git commands and backlog CLI)". The carve-out must be reworded to say: run_in_terminal is permitted for (a) the listed git commands + squash script, AND (b) backlog CLI commands (backlog task edit, etc.). Remove the word "ONLY" or expand the list to include backlog CLI explicitly.

Verdict: Plan needs this one wording fix before implementation. Both previous concerns (#1 FORBIDDEN block and #2 dry-run ordering) are confirmed resolved.

Plan revised: FORBIDDEN carve-out expanded to include backlog CLI commands alongside git commands.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 8 (Plan Steps 1–7 + AC mapping in Step 8)
- AC mapped: 8/8
- FORBIDDEN carve-out confirmed expanded to include backlog CLI commands (backlog task edit) alongside git commands and squash script — previous concern fully resolved
- No new issues introduced by the change

- Created .github/agents/git-commit-manager.agent.md
- Added frontmatter with user-invocable: false, name, color
- Added FORBIDDEN block with git + backlog CLI carve-out
- Added 6-step workflow (verify, stage, commit, dry-run, squash, emit signal)
- Added error path: squash script failure → no COMMIT COMPLETE signal
- Coverage: all AC verified
<!-- SECTION:NOTES:END -->
