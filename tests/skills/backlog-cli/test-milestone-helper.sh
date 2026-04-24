#!/usr/bin/env bash
# =============================================================================
# test-milestone-helper.sh — shunit2 tests for milestone-helper.sh
# =============================================================================
# HOW TO INSTALL shunit2:
#   macOS:          brew install shunit2
#   Debian/Ubuntu:  sudo apt-get install shunit2
#   Manual:         https://github.com/kward/shunit2
#                   Download shunit2 and place it somewhere on your PATH, or set
#                   SHUNIT2 env var to the full path of the shunit2 script.
#
# HOW TO RUN TESTS:
#   From the repo root:
#     bash tests/skills/backlog-cli/test-milestone-helper.sh
#
#   With a custom shunit2 path:
#     SHUNIT2=/path/to/shunit2 bash tests/skills/backlog-cli/test-milestone-helper.sh
#
# WHAT IS TESTED:
#   - create-milestone creates a file with correct frontmatter
#   - create-milestone duplicate exits non-zero
#   - assign-task inserts milestone field into task frontmatter
#   - assign-task replaces an existing milestone field
#   - assign-task exits non-zero when task file not found
#   - assign-task exits non-zero for an invalid task ID
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SCRIPT_UNDER_TEST="$REPO_ROOT/.github/skills/backlog-cli/scripts/milestone-helper.sh"

# ---------------------------------------------------------------------------
# setUp / tearDown — run before/after each test function
# ---------------------------------------------------------------------------
setUp() {
  TEST_DIR="$(mktemp -d)"
  export BACKLOG_DIR="$TEST_DIR"
  mkdir -p "$TEST_DIR/milestones" "$TEST_DIR/tasks"
}

tearDown() {
  rm -rf "$TEST_DIR"
}

# ---------------------------------------------------------------------------
# test_create_milestone_creates_file
# ---------------------------------------------------------------------------
test_create_milestone_creates_file() {
  bash "$SCRIPT_UNDER_TEST" create-milestone "My Milestone" "A description"

  # Find the created file
  local file
  file="$(find "$TEST_DIR/milestones" -name "*.md" | head -1)"

  assertNotNull "Milestone file should exist" "$file"
  assertTrue "File should be non-empty" "[ -s '$file' ]"

  # Check file naming pattern m-N - <slug>.md
  local basename
  basename="$(basename "$file")"
  echo "$basename" | grep -qE '^m-[0-9]+ - .+\.md$'
  assertTrue "File should use m-N naming pattern" $?

  # Check frontmatter: only id and title (no description, status, created_date)
  assertTrue "Should contain id field"              "grep -q '^id:' '$file'"
  assertTrue "Should contain title field"           "grep -q '^title:' '$file'"
  assertFalse "Should NOT contain description field" "grep -q '^description:' '$file'"
  assertFalse "Should NOT contain status field"      "grep -q '^status:' '$file'"
  assertFalse "Should NOT contain created_date field" "grep -q '^created_date:' '$file'"

  # id should use m-N format
  assertTrue "id should use m-N format"            "grep -q '^id: m-' '$file'"

  # Body should have ## Description section
  assertTrue "Should contain ## Description section" "grep -q '^## Description' '$file'"
  assertTrue "Should contain Milestone: <Title>"     "grep -q 'Milestone: My Milestone' '$file'"
  assertTrue "Title should match"                    "grep -q 'My Milestone' '$file'"
}

# ---------------------------------------------------------------------------
# test_create_milestone_duplicate
# ---------------------------------------------------------------------------
test_create_milestone_duplicate() {
  bash "$SCRIPT_UNDER_TEST" create-milestone "Sprint One" "First sprint"

  # Second call with the same title should exit non-zero
  bash "$SCRIPT_UNDER_TEST" create-milestone "Sprint One" "Duplicate" 2>/dev/null
  assertNotEquals "Duplicate milestone should fail" 0 $?
}

# ---------------------------------------------------------------------------
# test_assign_task_patches_frontmatter (inserts milestone field)
# ---------------------------------------------------------------------------
test_assign_task_patches_frontmatter() {
  # Create milestone fixture
  cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'
---
id: m-1
title: "Sprint 1"
---
MILE

  # Write a minimal task file with no milestone field
  cat > "$TEST_DIR/tasks/task-7 - my-task.md" <<'TASK'
---
id: TASK-7
title: "My Task"
status: To Do
---
Task body here.
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 7 "Sprint 1"

  assertTrue "milestone field should be in task file" \
    "grep -q '^milestone: m-1' '$TEST_DIR/tasks/task-7 - my-task.md'"
}

# ---------------------------------------------------------------------------
# test_assign_task_replaces_existing_milestone
# ---------------------------------------------------------------------------
test_assign_task_replaces_existing_milestone() {
  # Create milestone fixtures
  cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'
---
id: m-1
title: "Sprint 1"
---
MILE
  cat > "$TEST_DIR/milestones/m-2 - sprint-2.md" <<'MILE'
---
id: m-2
title: "Sprint 2"
---
MILE

  # Write a task file that already has a milestone field
  cat > "$TEST_DIR/tasks/task-8 - another-task.md" <<'TASK'
---
id: TASK-8
title: "Another Task"
status: To Do
milestone: m-1
---
Task body here.
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 8 "Sprint 2"

  assertTrue "milestone field should be updated" \
    "grep -q '^milestone: m-2' '$TEST_DIR/tasks/task-8 - another-task.md'"
  # Should NOT contain the old milestone id
  assertFalse "Old milestone should be gone" \
    "grep -q 'milestone: m-1' '$TEST_DIR/tasks/task-8 - another-task.md'"
  # Should only have one milestone line
  local count
  count="$(grep -c '^milestone:' "$TEST_DIR/tasks/task-8 - another-task.md")"
  assertEquals "Only one milestone field should exist" 1 "$count"
}

# ---------------------------------------------------------------------------
# test_assign_task_missing_file
# ---------------------------------------------------------------------------
test_assign_task_missing_file() {
  # Create a milestone so the lookup succeeds but task file doesn't exist
  cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'
---
id: m-1
title: "Sprint 1"
---
MILE
  bash "$SCRIPT_UNDER_TEST" assign-task 999 "Sprint 1" 2>/dev/null
  assertNotEquals "Missing task file should fail" 0 $?
}

# ---------------------------------------------------------------------------
# test_assign_task_backslash_n_in_title (SEC-001 regression)
# ---------------------------------------------------------------------------
# A milestone title containing a literal backslash-n sequence must NOT inject
# a second YAML field.  With awk -v this would expand \n to a newline, turning
# "Sprint 1\ninjected: evil" into two lines in the frontmatter.  The ENVIRON
# fix passes the value as raw bytes so the literal characters \ and n reach
# the output unchanged.
test_assign_task_backslash_n_in_title() {
  cat > "$TEST_DIR/tasks/task-9 - sec-task.md" <<'TASK'
---
id: TASK-9
title: "SEC Task"
status: To Do
---
Task body here.
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 9 'Sprint 1\ninjected: evil' 2>/dev/null

  # Unmatched milestone title should cause non-zero exit before any write
  assertNotEquals 0 $?
}

# ---------------------------------------------------------------------------
# test_assign_task_invalid_id
# ---------------------------------------------------------------------------
test_assign_task_invalid_id() {
  bash "$SCRIPT_UNDER_TEST" assign-task "" "Sprint 1" 2>/dev/null
  assertNotEquals "Empty task ID should fail" 0 $?

  bash "$SCRIPT_UNDER_TEST" assign-task "abc" "Sprint 1" 2>/dev/null
  assertNotEquals "Non-numeric task ID should fail" 0 $?

  bash "$SCRIPT_UNDER_TEST" assign-task "TASK-abc" "Sprint 1" 2>/dev/null
  assertNotEquals "TASK-abc task ID should fail" 0 $?
}

# ---------------------------------------------------------------------------
# test_assign_task_milestone_not_found
# ---------------------------------------------------------------------------
test_assign_task_milestone_not_found() {
  cat > "$TEST_DIR/tasks/task-10 - some-task.md" <<'TASK'
---
id: TASK-10
title: "Some Task"
status: To Do
---
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 10 "Nonexistent Milestone" 2>/dev/null
  assertNotEquals "Nonexistent milestone should fail" 0 $?
}

# ---------------------------------------------------------------------------
# test_assign_task_by_milestone_id
# ---------------------------------------------------------------------------
test_assign_task_by_milestone_id() {
  cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'
---
id: m-1
title: "Sprint 1"
---
MILE

  cat > "$TEST_DIR/tasks/task-11 - id-task.md" <<'TASK'
---
id: TASK-11
title: "ID Task"
status: To Do
---
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 11 "m-1"

  assertTrue "milestone field should use id" \
    "grep -q '^milestone: m-1' '$TEST_DIR/tasks/task-11 - id-task.md'"
}

# ---------------------------------------------------------------------------
# test_assign_task_milestone_missing_id_field
# ---------------------------------------------------------------------------
test_assign_task_milestone_missing_id_field() {
  # Milestone file exists but has no id: field
  cat > "$TEST_DIR/milestones/no-id - sprint-x.md" <<'MILE'
---
title: "Sprint X"
---
MILE

  cat > "$TEST_DIR/tasks/task-12 - noid-task.md" <<'TASK'
---
id: TASK-12
title: "No ID Task"
status: To Do
---
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 12 "Sprint X" 2>/dev/null
  assertNotEquals "Missing id field in milestone should fail" 0 $?

  # No milestone: line should have been written
  assertFalse "No milestone field should be written" \
    "grep -q '^milestone:' '$TEST_DIR/tasks/task-12 - noid-task.md'"
}

# ---------------------------------------------------------------------------
# Source shunit2
# ---------------------------------------------------------------------------
if [[ -n "${SHUNIT2:-}" ]]; then
  # shellcheck disable=SC1090
  . "$SHUNIT2"
elif command -v shunit2 &>/dev/null; then
  . "$(command -v shunit2)"
elif [[ -f /usr/share/shunit2/shunit2 ]]; then
  . /usr/share/shunit2/shunit2
elif [[ -f /usr/local/opt/shunit2/libexec/shunit2 ]]; then
  . /usr/local/opt/shunit2/libexec/shunit2
else
  echo "Error: shunit2 not found. Install with: brew install shunit2  (macOS) or  sudo apt-get install shunit2  (Debian/Ubuntu)" >&2
  exit 1
fi
