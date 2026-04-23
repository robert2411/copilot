---
id: TASK-35
title: >-
  Fix milestone assignment to use milestone id (e.g. m-1) instead of title in
  task frontmatter
status: In Progress
assignee:
  - '@myself'
created_date: '2026-04-23 09:28'
updated_date: '2026-04-23 09:43'
labels: []
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently, the script assigns milestones to tasks using the milestone title (e.g. 'Research: Jira API & Backlog CLI'), but the UI expects the milestone id (e.g. 'm-1'). Update the script so that when assigning a milestone to a task, it uses the milestone id in the 'milestone:' field in the task frontmatter, ensuring consistency with the UI and other tools.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Script assigns milestone using milestone id (e.g. m-1) in task frontmatter
- [x] #2 Milestone assignment is consistent between CLI, UI, and scripts
- [x] #3 Regression tests for milestone assignment pass
- [x] #4 Documentation updated if needed
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Implementation Plan

### Overview
The `assign-task` subcommand currently writes `milestone: <title>` directly into task frontmatter. It must instead look up the milestone file by title or id, extract the `id:` field, and write that id (e.g. `m-1`, `milestone-3`) into the task frontmatter.

---

### Step 1 — Add `lookup_milestone_id()` helper function in `milestone-helper.sh`

Insert a new function `lookup_milestone_id()` above `cmd_assign_task()`:

```bash
lookup_milestone_id() {
  local query="$1"   # may be a title OR an id
  local file id title name
  while IFS= read -r file; do
    id=""
    title=""
    name=""
    # Parse only the YAML frontmatter (between first pair of ---)
    while IFS= read -r line; do
      [[ "$line" == "---" ]] && break   # end of frontmatter
      case "$line" in
        id:*   ) id="${line#id: }" ;;
        title:*) title="${line#title: }"; title="${title//\"}" ;;
        name:* ) name="${line#name: }"; name="${name//\"}" ;;
      esac
    done < <(tail -n +2 "$file")   # skip first ---
    if [[ "$id" == "$query" || "$title" == "$query" || "$name" == "$query" ]]; then
      echo "$id"
      return 0
    fi
  done < <(find "$MILESTONES_DIR" -maxdepth 1 -name "*.md" 2>/dev/null)
  return 1
}
```

Notes:
- Matches on `id`, `title`, or `name` (supports both old and new milestone file formats).
- Returns just the id string via stdout (may be empty if the milestone file has no `id:` field).
- Returns exit code 1 if no match is found at all.

---

### Step 2 — Modify `cmd_assign_task()` to use milestone id

1. Rename the parameter `milestone_title` -> `milestone_ref` (or keep as-is for minimal diff).
2. After validation of task ID, call `lookup_milestone_id "$milestone_ref"` to get the id.
3. If no milestone file matches (exit code 1), print error and exit:
   ```
   Error: Milestone '<milestone_ref>' not found in $MILESTONES_DIR.
   ```
4. **[Concern #1 fix]** After a successful lookup (exit 0), explicitly check for an empty id and fail with a non-zero exit + error message:
   ```bash
   milestone_id=$(lookup_milestone_id "$milestone_ref")
   if [[ $? -ne 0 ]]; then
     echo "error: Milestone '${milestone_ref}' not found in ${MILESTONES_DIR}." >&2
     exit 1
   fi
   if [[ -z "$milestone_id" ]]; then
     echo "error: milestone id is empty (milestone file has no id: field)" >&2
     exit 1
   fi
   ```
   This prevents the silent `milestone: ` (empty value) that would otherwise be written to the task file.
5. Replace the `MILESTONE_VAR="milestone: ${milestone_title}"` line with:
   ```
   MILESTONE_VAR="milestone: ${milestone_id}"
   ```
6. Update the success echo to reflect the id was used:
   ```
   echo "Assigned task ${task_num} to milestone '${milestone_ref}' (id: ${milestone_id})."
   ```

---

### Step 3 — Update usage/comment strings in `milestone-helper.sh`

- Header comment: change `<milestone-title>` to `<milestone-title-or-id>` in USAGE and EXAMPLES sections.
- `usage()` function: same change.
- Note that the script now resolves the title/id to the milestone's `id` field.

---

### Step 4 — Update test file `test-milestone-helper.sh`

All three `assign-task` tests (`test_assign_task_patches_frontmatter`, `test_assign_task_replaces_existing_milestone`, `test_assign_task_backslash_n_in_title`) currently do NOT create a milestone file first, and assert `milestone: <title>`. They must be updated:

#### For `test_assign_task_patches_frontmatter` and `test_assign_task_replaces_existing_milestone`:
1. Create a milestone file in `$TEST_DIR/milestones/` before calling `assign-task`.
   Writing manually for deterministic ids; e.g.:
   ```bash
   cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'
   ---
   id: m-1
   title: "Sprint 1"
   ---
   MILE
   ```
2. Update assertions from `grep -q '^milestone: Sprint 1'` to `grep -q '^milestone: m-1'`.

#### `test_assign_task_replaces_existing_milestone`:
- Create a `m-2 - sprint-2.md` milestone file for "Sprint 2".
- Pre-populate task with `milestone: m-1`.
- Assert result is `milestone: m-2`.
- Assert old value `m-1` is gone.

#### `test_assign_task_backslash_n_in_title` (SEC-001) — **[Concern #2 fix]**:
- The malicious input `'Sprint 1\ninjected: evil'` will not match any milestone title, so `lookup_milestone_id` returns exit code 1 and the script exits non-zero before any file write occurs.
- **Remove both old assertions** (the line-count check `assertEquals "Only one milestone field should exist" 1 "$count"` AND the injected-field check `assertFalse ... grep -q 'injected: evil'`).
- **Replace with a single assertion:**
  ```bash
  assertNotEquals 0 $?
  ```
  This verifies that unmatched milestone titles cause a non-zero exit before any file write, which is the correct SEC-001 behaviour after the fix.

#### Add a new test: `test_assign_task_milestone_not_found`
- Call `assign-task` with a title that has no matching milestone file.
- Assert non-zero exit code.

#### Add a new test: `test_assign_task_by_milestone_id`
- Create milestone `m-1` with title "Sprint 1".
- Call `assign-task 7 m-1` (passing the id directly).
- Assert `milestone: m-1` is written.

#### Add a new test: `test_assign_task_milestone_missing_id_field`
- Create a milestone file that matches the query but has no `id:` field.
- Assert non-zero exit code and that no `milestone:` line is written to the task file.

---

### Step 5 — AC Mapping

| AC | Steps covering it |
|----|-------------------|
| #1 Script assigns milestone using milestone id in task frontmatter | Steps 1, 2 |
| #2 Milestone assignment consistent between CLI, UI, and scripts | Steps 1, 2 (id is what UI expects) |
| #3 Regression tests pass | Step 4 |
| #4 Documentation updated if needed | Step 3 |

---

### Files to modify
- `.github/skills/backlog-cli/scripts/milestone-helper.sh`
- `tests/skills/backlog-cli/test-milestone-helper.sh`

### Edge cases to handle
- **No matching milestone file** → exit 1 + error "Milestone not found".
- **Milestone file found but `id:` field is empty** → exit 1 + error "milestone id is empty" (explicit `[[ -z "$milestone_id" ]]` guard in Step 2).
- **Multiple milestones matching same title** → first match wins (consistent with `head -1` pattern used elsewhere).
- **`MILESTONES_DIR` empty or missing** → `find` returns nothing → exit 1 + "Milestone not found" error.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all AC. No gaps or unverified assumptions.
Key decisions confirmed:
- lookup_milestone_id() matches on id, title, OR name to handle both old (name:) and new (title:) milestone file formats.
- Malicious input (SEC-001) is now prevented at lookup time — unmatched titles fail before any write occurs.
- Test updates are concrete: create milestone fixture manually for deterministic ids, update all three existing assign-task tests, add test_assign_task_milestone_not_found and test_assign_task_by_milestone_id.
- Edge case: milestone found but id field empty → error 'Milestone found but has no id field'.
Analysis complete. Plan ready. No blockers.

🔍 PLAN REVIEW CONCERNS:

- Concern #1 (Gap in empty-id handling): The plan's edge-case section states that a milestone file with no `id:` field should emit "Milestone found but has no id field" error. However, the `lookup_milestone_id()` code shown in Step 1 does `echo "$id"; return 0` regardless — if `id` is empty it returns exit code 0 with empty stdout. Step 2's guard ("If no id is returned (exit 1), print error and exit") only checks exit code 1, so it will NOT catch the empty-id case. The result would be `milestone: ` written silently to the task file, which is invalid YAML. The plan must show explicit code in Step 2 to check `if [[ -z "$milestone_id" ]]` after a successful lookup and emit the correct error message then.

- Concern #2 (test_assign_task_backslash_n_in_title behaviour change not fully specified): The plan says to update this test to "assert non-zero exit code instead of checking for injected field". However, the test also currently asserts `assertEquals "Only one milestone field should exist" 1 "$count"` — implying the script currently succeeds (exit 0) and writes one milestone line. After the fix, the script should exit non-zero (no write occurs). The plan should explicitly state that both the count assertion and the injected-field assertion are removed/replaced with a single `assertNotEquals 0 $?` check to avoid leaving a broken test.

Verdict: Plan needs revision before implementation — two concrete gaps to address.

Plan revised to address plan-reviewer concerns. No blockers.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 5
- AC mapped: 4
- Concern #1 (empty-id guard): addressed — explicit [[ -z "$milestone_id" ]] check shown in Step 2 with error + exit 1
- Concern #2 (SEC-001 test): addressed — both old assertions explicitly removed, replaced by single assertNotEquals 0 $?

- Added lookup_milestone_id() function to milestone-helper.sh
- Modified cmd_assign_task() to resolve title/id to milestone id before writing frontmatter
- Added empty-id guard (Concern #1 fix)
- Updated usage/comments
- Updated all 3 existing assign-task tests with milestone fixtures
- Updated SEC-001 test (Concern #2 fix) — now asserts non-zero exit
- Added test_assign_task_milestone_not_found
- Added test_assign_task_by_milestone_id
- Added test_assign_task_milestone_missing_id_field
- All 10 tests pass
All AC/DoD checked. Ready for QA.

✅ QA APPROVED — all tests passing, no regressions
- AC/DoD: Complete (all checklist items checked)
- Validation: 10/10 tests passing via shunit2
- Code quality: Milestone lookup + empty-id guard implemented correctly
- Security: No obvious issues (unmatched/missing-id paths fail before write)
- Spelling/Docs: Usage/comments updated for title-or-id input
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Added lookup_milestone_id() to milestone-helper.sh and updated cmd_assign_task() to resolve milestone title/id to the actual id field before writing task frontmatter.

Changes:
- .github/skills/backlog-cli/scripts/milestone-helper.sh: new lookup_milestone_id() function, updated cmd_assign_task() with milestone lookup + empty-id guard, updated usage/comments
- tests/skills/backlog-cli/test-milestone-helper.sh: all assign-task tests now create milestone fixtures and assert id (m-1) not title; SEC-001 test updated; 3 new tests added

Tests:
- 10 tests total, all passing
- Covers: id lookup, title lookup, not-found error, missing-id-field error, SEC-001 injection prevention
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
