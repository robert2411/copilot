---
id: TASK-30
title: 'backlog-cli skill: create milestone helper shell script'
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
updated_date: '2026-04-20 20:43'
labels:
  - backlog-cli
  - skills
milestone: Backlog CLI Milestone Helper
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The backlog CLI has no milestone create command and no --milestone flag for task create/edit. Milestone files must be created manually and task milestone assignment requires direct frontmatter editing. A helper shell script should be added to the backlog-cli skill's scripts/ folder to automate both operations.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Script supports creating a new milestone file in backlog/milestones/ with correct frontmatter (id, title, description, status, created_date)
- [ ] #2 Script supports assigning an existing task to a milestone by patching the task file's frontmatter milestone field
- [ ] #3 Script is placed at .github/skills/backlog-cli/scripts/milestone-helper.sh
- [ ] #4 Script is executable and includes usage instructions as inline comments
- [ ] #5 Script handles edge cases: duplicate milestone names, missing task file, invalid task ID
- [ ] #6 Tests written using shunit2 covering: create milestone, assign task, duplicate milestone, missing task file, invalid task ID
- [ ] #7 Tests live in tests/skills/backlog-cli/ at repo root — NOT inside the skill dir
- [ ] #8 README or inline comment in test file documents how to install shunit2 and run tests
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Confirm directory structure: verify .github/skills/backlog-cli/ exists; create .github/skills/backlog-cli/scripts/ if absent.
2. Scaffold milestone-helper.sh at .github/skills/backlog-cli/scripts/milestone-helper.sh with:
   a. Shebang: #!/usr/bin/env bash
   b. set -euo pipefail
   c. A comment-block header at the very top of the script (after shebang) covering: purpose, usage synopsis for both subcommands, argument descriptions, examples, and the BACKLOG_DIR env var. This satisfies AC4 inline comment requirement.
   d. A usage() function that prints the same help text at runtime; called for unknown subcommands or missing args.
3. Wire BACKLOG_DIR env var throughout the script:
   a. After set -euo pipefail, declare: BACKLOG_DIR="${BACKLOG_DIR:-./backlog}"
   b. Derive: MILESTONES_DIR="$BACKLOG_DIR/milestones" and TASKS_DIR="$BACKLOG_DIR/tasks"
   c. Every path that references milestones or tasks must use these variables — never a hardcoded ./backlog literal.
   d. This lets test setUp export BACKLOG_DIR pointing at a temp dir, fully isolating test runs from the real backlog.
4. Implement create-milestone subcommand:
   a. Accept positional args: <title> [description]
   b. Derive slug from title: lowercase, replace non-alphanumeric with hyphens, collapse consecutive hyphens, strip leading/trailing hyphens.
   c. Determine next milestone ID by scanning $MILESTONES_DIR for files matching milestone-N - *.md; take max N + 1.
   d. Duplicate detection — filename slug match: glob $MILESTONES_DIR for any file whose name contains the derived slug (i.e., *<slug>*). If found, print error "Milestone '<title>' already exists" and exit 1. Using slug-based filename match ensures "Sprint 1" and "sprint-1" resolve to the same slug and are correctly detected as duplicates.
   e. Write $MILESTONES_DIR/milestone-<N> - <slug>.md with YAML frontmatter: id, title, description, status (active), created_date (YYYY-MM-DD).
5. Implement assign-task subcommand:
   a. Accept positional args: <task-id> <milestone-title>
   b. Normalise task-id: strip leading "TASK-" or "task-" prefix, validate remainder is a non-empty integer; exit 1 with clear message if invalid.
   c. Glob $TASKS_DIR for a file matching task-<id> - *.md; exit 1 with clear message if not found.
   d. Determine whether a milestone: key already exists in the frontmatter block (lines between the two --- delimiters).
   e. File rewrite strategy — standardise on BSD sed and awk (both available on macOS without extra flags):
      - Replace case (milestone: field exists): use BSD sed in-place edit: sed -i "" 's/^milestone:.*/milestone: <value>/' <file>
        BSD sed requires the empty-string backup suffix (sed -i "") on macOS; GNU sed accepts sed -i without it. Since this project runs on macOS, always use sed -i "" for all single-line replacements.
      - Insert case (no milestone: field): use awk to rewrite the file — read all lines; when the closing --- of the frontmatter block is reached, emit the new "milestone: <value>" line first, then the ---. awk avoids the sed portability issue for structural multi-line inserts and is available on both macOS and Linux.
6. Add argument dispatch: parse $1 as subcommand, shift, pass remaining args; call usage() and exit 1 for unknown subcommands or when invoked with no args.
7. Mark script executable: chmod +x .github/skills/backlog-cli/scripts/milestone-helper.sh
8. Create tests/skills/backlog-cli/ directory at repo root if absent.
9. Write tests/skills/backlog-cli/test-milestone-helper.sh using shunit2:
   a. Comment-block header at top of test file documenting: how to install shunit2 (brew install shunit2 on macOS, apt-get install shunit2 on Debian/Ubuntu) and how to run tests (bash tests/skills/backlog-cli/test-milestone-helper.sh). Satisfies AC8.
   b. setUp: create a temp dir with milestones/ and tasks/ subdirs; export BACKLOG_DIR pointing at temp dir so the script under test operates on the temp dir, not the real backlog.
   c. tearDown: delete the temp dir.
   d. test_create_milestone_creates_file: call create-milestone "My Milestone" "A description"; assert file exists in MILESTONES_DIR and frontmatter contains id, title, description, status fields.
   e. test_create_milestone_duplicate: call create-milestone twice with the same title; assert second call exits non-zero.
   f. test_assign_task_patches_frontmatter: write a minimal task file with frontmatter but no milestone field into TASKS_DIR; call assign-task; assert milestone: field appears in the file.
   g. test_assign_task_replaces_existing_milestone: write task file with an existing milestone: field; call assign-task with a new milestone title; assert field is updated and not duplicated.
   h. test_assign_task_missing_file: call assign-task with a non-existent task ID; assert non-zero exit and error message.
   i. test_assign_task_invalid_id: call assign-task with empty or non-numeric ID; assert non-zero exit.
   j. Source shunit2 at the end of the test file using the shunit2 binary located via PATH.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 8 ACs:
- AC1 (create milestone file with correct frontmatter) → steps 3a–3e
- AC2 (assign task by patching frontmatter) → steps 4a–4e
- AC3 (script at correct path) → steps 1–2
- AC4 (executable + inline comments) → steps 2 and 6
- AC5 (edge cases: duplicate, missing file, invalid ID) → steps 3d, 4b, 4c
- AC6 (shunit2 tests for all scenarios) → steps 8a–8f
- AC7 (tests in tests/skills/backlog-cli/ at repo root) → steps 7–8
- AC8 (shunit2 install + run instructions in test file) → step 9
No unverified assumptions. sed/awk available on macOS and Linux. shunit2 is a well-known testing framework. Error paths explicitly covered. Analysis complete. Plan ready. No blockers.

🔍 PLAN REVIEW CONCERNS

- Concern #1 (HIGH): BACKLOG_DIR not wired into script steps. Test step 8a sets BACKLOG_DIR to a temp dir but implementation steps 1-6 hardcode backlog/milestones/ and backlog/tasks/ paths with no mention of reading BACKLOG_DIR inside the script itself. If paths resolve from CWD, tests will either fail or corrupt the real backlog. Plan must explicitly state the script reads a BACKLOG_DIR env var (defaulting to ./backlog) and uses it for all path resolution.

- Concern #2 (MEDIUM): sed -i macOS portability not addressed. On macOS BSD sed, in-place editing requires an empty string suffix: sed -i "". On Linux GNU sed it is sed -i. Step 4e says "use sed/awk" but is silent on this difference. Since the project runs on macOS, a naive sed -i will error. Plan must specify the portability strategy (e.g., detect OS, always pass the empty-string arg, or use perl -i -pe as a cross-platform alternative).

- Concern #3 (MEDIUM): Duplicate milestone detection method is ambiguous. Step 3d says exit 1 if a milestone with the same title already exists, but does not specify the comparison method: slug match on filename, grep on the title: frontmatter field, or exact string match. These yield different results for titles like "Sprint 1" vs "sprint-1". Plan must specify the exact comparison strategy.

- Concern #4 (LOW): AC4 requires "usage instructions as inline comments." The plan implements a usage() function that prints at runtime, which is different from inline # comment documentation embedded in the script body. Plan should explicitly call out adding comment-block usage documentation at the top of the script to satisfy the AC as written.

Verdict: Plan needs revision before implementation.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
