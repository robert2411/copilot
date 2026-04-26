---
id: TASK-44
title: Write squash-consecutive-commits shell helper script
status: In Progress
assignee:
  - '@myself'
created_date: '2026-04-24 22:20'
updated_date: '2026-04-26 21:05'
labels:
  - git
  - agent
  - scripts
milestone: m-3
dependencies:
  - TASK-42
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Write a shell script squash-task-commits.sh (alongside milestone-helper.sh) that the git commit manager agent calls. The script reads the git log, identifies consecutive runs of commits with the same task-id prefix (format: task-<id>: ...), and squashes each consecutive run into a single commit. Non-consecutive occurrences of the same task-id are left independent. Uses git rebase --onto or git reset + commit to rewrite history cleanly.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Script lives at .github/skills/backlog-cli/scripts/squash-task-commits.sh
- [x] #2 Script reads git log in reverse order and groups consecutive commits by task-id prefix
- [x] #3 Consecutive run of N commits for same task-id is squashed into one commit keeping the first message
- [x] #4 A boundary commit from a different task-id breaks the run; resumes a new independent run after
- [x] #5 Script is idempotent: running twice on already-squashed history produces no change
- [x] #6 Script accepts optional --dry-run flag that prints planned squash operations without executing
- [x] #7 Script exits non-zero if working tree is dirty (uncommitted changes)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create the file `.github/skills/backlog-cli/scripts/squash-task-commits.sh` alongside milestone-helper.sh.
2. Add shebang `#!/usr/bin/env bash` and `set -euo pipefail` at the top. Add a header comment block (matching milestone-helper.sh convention) describing purpose, usage, flags, and examples.
3. Parse CLI arguments:
   - Loop over "$@", if arg is `--dry-run` set DRY_RUN=true, else print usage and exit 1.
4. Dirty working tree check (AC#7):
   - Run `git status --porcelain`. If output is non-empty, print error "Working tree is dirty. Commit or stash changes before squashing." to stderr and exit 1.
5. Read git log (AC#2):
   - Capture output of: `git log --format="%H|%s" -100`
   - Use `-100` as the practical scan depth limit (not unbounded). This is a deliberate cap: repos with thousands of commits do not need full history scanned; consecutive same-task commits will always be in the recent window.
   - Store as an array of lines, newest-first order (default git log order)
   - Use `while IFS= read -r line; do ... done < <(git log --format="%H|%s" -100)` for bash 3.2 compatibility (do NOT use mapfile/readarray — macOS ships bash 3.2)
6. Parse task-id from each commit subject (AC#2):
   - For each line, extract hash and subject via IFS='|' splitting
   - Apply regex `^task-([^: ]+):` to the subject using bash `=~` operator (standard case-sensitive matching — the canonical commit format is always lowercase `task-<id>:`, so case-insensitive matching is not needed and should NOT be used)
   - If no match, task-id = "" (non-task commit)
7. Identify consecutive runs (AC#2, AC#4):
   - Walk the array from index 0 (newest) to end
   - Track current_task_id and run_start_index, run_hashes[]
   - When task-id changes OR is empty → close the current run
   - A "run" worthy of squashing: same non-empty task-id, length > 1
   - Store each qualifying run as: (first_hash, last_hash, count, message)
8. If no qualifying runs found → print "Nothing to squash." and exit 0 (idempotent — AC#5)
9. Dry-run output (AC#6):
   - If DRY_RUN=true, for each qualifying run print:
     `[DRY-RUN] Would squash <count> commits for <task-id> into: <first_message>`
   - Then exit 0 without modifying history
10. Squash execution (AC#3, AC#5):
    - Process runs from OLDEST to NEWEST (reverse order of discovery) so SHA invalidation from rebase does not affect already-processed runs
    - For each run:
      a. Determine how many commits from HEAD the run covers: compute N = index_of_last_commit_in_run + 1
      b. Build a git-rebase-todo temp file:
         - List ALL commits in the rebase window using the correct range: `git log --format="%H %s" --reverse HEAD~<N>..HEAD`
         - NOTE: Use `HEAD~<N>..HEAD` range (not `HEAD~<N>` alone) to limit output to exactly N commits. `HEAD~<N>` without a range walks ALL history from that point backwards and is incorrect.
         - For commits in the current run: first = `pick <hash> <subject>`, rest = `fixup <hash> <subject>`
         - For commits NOT in the current run within the window: `pick <hash> <subject>`
      c. Export `GIT_SEQUENCE_EDITOR="cp <todo-tempfile>"` and run `git rebase -i HEAD~<N>`
      d. After rebase, re-read git log to refresh hashes for subsequent runs (since hashes change after rebase)
    - Alternative simpler approach when run is at the very tip (newest commits): use `git reset --soft HEAD~<run_length>` then `git commit -m "<first_message>"` — this is valid only when the run starts at HEAD
    - **Recommended approach for correctness**: use the GIT_SEQUENCE_EDITOR / rebase-todo approach for any run position
11. After all squashes complete, print "Squash complete." and exit 0.
12. Make the script executable: `chmod +x .github/skills/backlog-cli/scripts/squash-task-commits.sh`
13. Idempotency (AC#5): if script is run again on already-squashed history, step 8 exits 0 because no runs of length > 1 are found.
14. AC coverage verification:
    - AC#1: file at correct path ✅ (Step 1)
    - AC#2: git log parsed, grouped consecutively ✅ (Steps 5-7)
    - AC#3: N consecutive commits → 1 commit, first message kept (fixup) ✅ (Step 10)
    - AC#4: boundary commit breaks run ✅ (Step 7 — different task-id closes the run)
    - AC#5: idempotent ✅ (Step 8 exits 0 when nothing to squash)
    - AC#6: --dry-run flag ✅ (Steps 3, 9)
    - AC#7: dirty working tree exits non-zero ✅ (Step 4)
15. Test approach (for implementation agent to verify):
    - Create a temp git repo, make commits: task-1, task-1, task-3, task-1 → run script → verify log shows task-1, task-3, task-1
    - Create commits: task-1, task-1, task-1, task-3 → run script → verify log shows task-1, task-3
    - Run script twice on the same history → verify second run makes no changes (idempotent)
    - Dirty working tree test: touch a file without committing → run script → verify exit code 1
    - --dry-run test: confirm no history changes occur
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete.

AC coverage:
- AC#1 → Plan Step 1 (file at correct path)
- AC#2 → Plan Steps 5-7 (git log parsed, consecutive grouping logic detailed)
- AC#3 → Plan Step 10 (fixup instruction keeps first message, N→1)
- AC#4 → Plan Step 7 (different task-id closes and breaks the run)
- AC#5 → Plan Steps 8 and 13 (no qualifying runs → exit 0 is idempotent)
- AC#6 → Plan Steps 3 and 9 (--dry-run flag parsed, prints plan, exits 0)
- AC#7 → Plan Step 4 (git status --porcelain exits non-zero if dirty)

Error paths covered:
- Dirty working tree → exit 1 with clear error message (Step 4)
- No task-format commits in history → Step 8 exits 0 gracefully
- Run of exactly 1 commit (already squashed) → not a qualifying run, exits 0

Risk flagged for implementation agent: `mapfile` requires bash 4+. macOS ships bash 3.2. Implementation agent should either: (a) use `while IFS= read -r line; do ... done < <(git log ...)` instead, or (b) use `readarray` and verify environment. Recommend using `while read` loop for portability.

Second risk: GIT_SEQUENCE_EDITOR approach requires git 1.7.8+. This is safe for all modern environments.

Third risk: rebasing rewrites SHAs — script must re-read git log after each rebase to refresh hashes for subsequent run processing (already in plan Step 10d).

Test approach included in plan (Step 15). No ambiguous steps.

Analysis complete. Plan ready. No blockers. Note portability risk with mapfile/bash 4 flagged in notes — implementation agent must use while-read loop for git log parsing.

🔍 PLAN REVIEW CONCERNS:

- Concern #1 — Step 10b git log range command is incorrect: The plan specifies `git log --reverse --format="%H %s" HEAD~<N>` to build the rebase todo for the window of N commits. However, `git log HEAD~<N>` (without a range) walks the ENTIRE history from HEAD~N backwards — it does not limit output to the last N commits. This means the rebase-todo file would contain hundreds/thousands of unrelated commits, making the rebase command destructive and wrong. The correct command to get only the N commits between HEAD~N and HEAD is `git log --reverse --format="%H %s" HEAD~<N>..HEAD` (note the range operator). The plan must be corrected to use the `HEAD~<N>..HEAD` range everywhere in Step 10b.

- Concern #2 — Step 6 case-sensitivity contradiction: Step 6 describes the regex `^task-([^: ]+):` as "(case-insensitive)" but in bash the `=~` operator performs case-SENSITIVE matching by default. No `shopt -s nocasematch` or lowercase conversion is specified. If case-insensitivity is genuinely required, the plan must specify the mechanism (e.g. `shopt -s nocasematch` before the match, or convert the subject to lowercase first via `${subject,,}`). If the commit format is always lowercase `task-<id>:` (which the canonical format implies), remove the "(case-insensitive)" annotation to avoid confusion for the implementation agent.

- Concern #3 — Step 5 depth limit is ambiguous: Step 5 says "no depth limit — processes all commits" and then "(use -100 as a practical guard)" in the same sentence. These two intentions contradict each other. A repo with thousands of commits would expose a performance and correctness risk if no limit is used (pattern matching on all commit messages). The plan must commit to one explicit decision: either always use `-100` (state the flag explicitly in the git log command), or document why unbounded depth is intentional and acceptable.

Verdict: Plan needs revision on these three points before implementation.

Plan revised: git log range fixed; case-sensitivity annotation removed; depth limit resolved to -100 with explicit command.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 15
- AC mapped: 7
- Previous concerns resolved:
  #1 git log range corrected to HEAD~<N>..HEAD with explicit explanation of why bare HEAD~<N> is wrong
  #2 Case-sensitivity annotation removed; Step 6 now specifies standard case-sensitive matching
  #3 Depth limit committed to -100 with explicit git log command shown

- Created .github/skills/backlog-cli/scripts/squash-task-commits.sh
- bash 3.2 (macOS) compatible: no mapfile/readarray
- Dirty tree check exits non-zero with message
- git log -100 with %H|%s, IFS pipe splitting
- Consecutive run detection in newest-first order
- Squash via git rebase -i with GIT_SEQUENCE_EDITOR + pre-built todo
- Processes oldest runs first (highest end_idx) to avoid SHA invalidation
- Re-reads git log after each rebase for fresh SHAs
- --dry-run flag prints plan without modifying history
- Idempotent: no qualifying runs → exit 0
- Tests: AC#7 (dirty), AC#5 (idempotent), scenario [t1,t1,t3,t1]→[t1,t3,t1], scenarios [t1,t1,t1,t3]→[t1,t3], two-run scenario all pass

All AC/DoD checked. Ready for QA.

✅ QA APPROVED — all tests passing, no regressions
- AC/DoD: Complete (all checklist items checked)
- File reviewed: .github/skills/backlog-cli/scripts/squash-task-commits.sh
- Validation: bash syntax check passed (bash -n), dirty-tree guard, --dry-run behavior, consecutive-run detection, boundary preservation, oldest-first processing, idempotent no-op path all implemented
- Code quality/security/spelling: No issues found

✅ SECURITY APPROVED — static audit complete, zero vulnerabilities identified
- Files reviewed: .github/skills/backlog-cli/scripts/squash-task-commits.sh
- Checks performed: OWASP Top 10, path traversal, ReDoS, input validation, command injection, unquoted variable expansion, history rewrite scope
- set -euo pipefail present; dirty-tree guard exits non-zero; GIT_SEQUENCE_EDITOR uses mktemp-generated path (not user-controlled, no space/metachar risk); commit subject written to rebase-todo via echo does not re-evaluate shell substitutions; [^:]+ regex has no catastrophic backtracking; oldest-first processing prevents SHA invalidation; run_found guard correctly blocks non-consecutive commits; -100 depth cap bounds history rewrite blast radius; idempotent exit-0 path confirmed

✅ DOCUMENTATION COMPLETE
- Updated: backlog/docs/doc-17 - Git-Commit-Manager-Agent-—-Workflow-and-Squash-Strategy.md — added "squash-task-commits.sh — Implementation Reference" section with full algorithm walkthrough, flag/exit-code table, key design choices table, and verified test-case table
- Updated: .github/skills/backlog-cli/SKILL.md — added squash-task-commits.sh row to Scripts table and a reference link in the References section
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created squash-task-commits.sh at .github/skills/backlog-cli/scripts/squash-task-commits.sh.

What changed and why:
- Shell helper script that the git-commit-manager agent calls to collapse consecutive same-task commits
- Reads git log (last 100), extracts task-id prefix via bash regex, groups consecutive runs
- Squashes via git rebase -i with pre-built todo file (pick/fixup), processed oldest-first to avoid SHA invalidation
- Re-reads git log after each rebase for fresh SHAs
- --dry-run flag for preview without modifying history
- Idempotent: exits 0 with "Nothing to squash." when no qualifying runs
- bash 3.2 compatible (macOS): uses while IFS= read -r instead of mapfile

Changes:
- .github/skills/backlog-cli/scripts/squash-task-commits.sh (new file, chmod +x)

Tests:
- Dirty tree → exit 1 ✅
- Idempotent ✅
- [task-1, task-1, task-3, task-1] → [task-1, task-3, task-1] ✅
- [task-1, task-1, task-1, task-3] → [task-1, task-3] ✅
- Two non-adjacent runs simultaneously processed ✅
- --dry-run prints plan without touching history ✅
<!-- SECTION:FINAL_SUMMARY:END -->
