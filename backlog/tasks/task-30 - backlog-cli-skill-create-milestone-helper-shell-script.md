---
id: TASK-30
title: 'backlog-cli skill: create milestone helper shell script'
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
updated_date: '2026-04-20 20:38'
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
2. Scaffold milestone-helper.sh at .github/skills/backlog-cli/scripts/milestone-helper.sh with a shebang (#!/usr/bin/env bash), set -euo pipefail, and a usage() function that prints a help block covering both subcommands.
3. Implement `create-milestone` subcommand:
   a. Accept positional args: <title> [description]
   b. Derive a slug from the title (lowercase, spaces→hyphens)
   c. Determine next milestone ID by scanning backlog/milestones/ for existing milestone-N files
   d. Check for duplicate: if a milestone file with the same title already exists, print an error and exit 1
   e. Write backlog/milestones/milestone-<N> - <slug>.md with frontmatter: id, title, description, status (active), created_date
4. Implement `assign-task` subcommand:
   a. Accept positional args: <task-id> <milestone-title>
   b. Validate task-id is non-empty and numeric/TASK-prefixed; exit 1 with message if invalid
   c. Glob backlog/tasks/ for a file matching task-<id> - *.md; exit 1 with clear message if not found
   d. Check if a `milestone:` key already exists in frontmatter; if so, replace it; if not, insert after the last frontmatter field before the closing ---
   e. Use sed/awk to perform the in-place frontmatter patch
5. Add argument dispatch: parse $1 as subcommand, shift, pass remaining args; print usage and exit 1 for unknown subcommands
6. Mark script executable: chmod +x .github/skills/backlog-cli/scripts/milestone-helper.sh
7. Create tests/skills/backlog-cli/ directory at repo root if absent
8. Write tests/skills/backlog-cli/test-milestone-helper.sh using shunit2:
   a. setUp: create a temp BACKLOG_DIR with milestones/ and tasks/ subdirs; point BACKLOG_DIR env var at it
   b. test_create_milestone_creates_file: call create-milestone "My Milestone" "A description"; assert file exists and frontmatter fields are correct
   c. test_create_milestone_duplicate: call create-milestone twice with the same title; assert second call exits non-zero
   d. test_assign_task_patches_frontmatter: create a minimal task file in temp dir; call assign-task; assert milestone field appears
   e. test_assign_task_missing_file: call assign-task with a non-existent task ID; assert non-zero exit
   f. test_assign_task_invalid_id: call assign-task with empty/garbage ID; assert non-zero exit
9. Add a comment block at the top of the test file documenting: how to install shunit2 (brew install shunit2 / apt-get install shunit2) and how to run the tests (bash tests/skills/backlog-cli/test-milestone-helper.sh)
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
