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

  # Check frontmatter fields
  assertTrue "Should contain id field"          "grep -q '^id:' '$file'"
  assertTrue "Should contain title field"       "grep -q '^title:' '$file'"
  assertTrue "Should contain description field" "grep -q '^description:' '$file'"
  assertTrue "Should contain status field"      "grep -q '^status:' '$file'"
  assertTrue "Should contain created_date field" "grep -q '^created_date:' '$file'"
  assertTrue "Status should be active"          "grep -q 'status: active' '$file'"
  assertTrue "Title should match"               "grep -q 'My Milestone' '$file'"
  assertTrue "Description should match"         "grep -q 'A description' '$file'"
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
    "grep -q '^milestone: Sprint 1' '$TEST_DIR/tasks/task-7 - my-task.md'"
}

# ---------------------------------------------------------------------------
# test_assign_task_replaces_existing_milestone
# ---------------------------------------------------------------------------
test_assign_task_replaces_existing_milestone() {
  # Write a task file that already has a milestone field
  cat > "$TEST_DIR/tasks/task-8 - another-task.md" <<'TASK'
---
id: TASK-8
title: "Another Task"
status: To Do
milestone: Old Milestone
---
Task body here.
TASK

  bash "$SCRIPT_UNDER_TEST" assign-task 8 "Sprint 2"

  assertTrue "milestone field should be updated" \
    "grep -q '^milestone: Sprint 2' '$TEST_DIR/tasks/task-8 - another-task.md'"
  # Should NOT contain the old milestone
  assertFalse "Old milestone should be gone" \
    "grep -q 'Old Milestone' '$TEST_DIR/tasks/task-8 - another-task.md'"
  # Should only have one milestone line
  local count
  count="$(grep -c '^milestone:' "$TEST_DIR/tasks/task-8 - another-task.md")"
  assertEquals "Only one milestone field should exist" 1 "$count"
}

# ---------------------------------------------------------------------------
# test_assign_task_missing_file
# ---------------------------------------------------------------------------
test_assign_task_missing_file() {
  bash "$SCRIPT_UNDER_TEST" assign-task 999 "Sprint 1" 2>/dev/null
  assertNotEquals "Missing task file should fail" 0 $?
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
