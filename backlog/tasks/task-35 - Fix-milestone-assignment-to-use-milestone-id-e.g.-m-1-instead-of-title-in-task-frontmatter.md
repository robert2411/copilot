---
id: TASK-35
title: >-
  Fix milestone assignment to use milestone id (e.g. m-1) instead of title in
  task frontmatter
status: In Progress
assignee:
  - '@manager'
created_date: '2026-04-23 09:28'
updated_date: '2026-04-23 09:32'
labels: []
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently, the script assigns milestones to tasks using the milestone title (e.g. 'Research: Jira API & Backlog CLI'), but the UI expects the milestone id (e.g. 'm-1'). Update the script so that when assigning a milestone to a task, it uses the milestone id in the 'milestone:' field in the task frontmatter, ensuring consistency with the UI and other tools.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Script assigns milestone using milestone id (e.g. m-1) in task frontmatter
- [ ] #2 Milestone assignment is consistent between CLI, UI, and scripts
- [ ] #3 Regression tests for milestone assignment pass
- [ ] #4 Documentation updated if needed
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
- Returns just the id string via stdout.
- Returns exit code 1 if no match.

---

### Step 2 — Modify `cmd_assign_task()` to use milestone id

1. Rename the parameter `milestone_title` -> `milestone_ref` (or keep as-is for minimal diff).
2. After validation of task ID, call `lookup_milestone_id "$milestone_ref"` to get the id.
3. If no id is returned (exit 1), print error and exit:
   ```
   Error: Milestone '<milestone_ref>' not found in $MILESTONES_DIR.\n   ```\n4. Replace the `MILESTONE_VAR="milestone: ${milestone_title}"` line with:\n   ```\n   MILESTONE_VAR="milestone: ${milestone_id}"\n   ```\n5. Update the success echo to reflect the id was used:\n   ```\n   echo "Assigned task ${task_num} to milestone '${milestone_ref}' (id: ${milestone_id})."\n   ```\n\n---\n\n### Step 3 — Update usage/comment strings in `milestone-helper.sh`\n\n- Header comment: change `<milestone-title>` to `<milestone-title-or-id>` in USAGE and EXAMPLES sections.\n- `usage()` function: same change.\n- Note that the script now resolves the title/id to the milestone's `id` field.\n\n---\n\n### Step 4 — Update test file `test-milestone-helper.sh`\n\nAll three `assign-task` tests (`test_assign_task_patches_frontmatter`, `test_assign_task_replaces_existing_milestone`, `test_assign_task_backslash_n_in_title`) currently do NOT create a milestone file first, and assert `milestone: <title>`. They must be updated:\n\n#### For each of those tests:\n1. Create a milestone file in `$TEST_DIR/milestones/` before calling `assign-task`.\n   - Use `bash "$SCRIPT_UNDER_TEST" create-milestone "Sprint 1"` OR write the file manually to control the id.\n   - Writing manually is more deterministic; e.g.:\n     ```bash\n     cat > "$TEST_DIR/milestones/m-1 - sprint-1.md" <<'MILE'\n     ---\n     id: m-1\n     title: "Sprint 1"\n     ---\n     MILE\n     ```\n2. Update assertions from `grep -q '^milestone: Sprint 1'` to `grep -q '^milestone: m-1'`.\n\n#### `test_assign_task_replaces_existing_milestone`:\n- Create a `m-2 - sprint-2.md` milestone file for "Sprint 2".\n- Pre-populate task with `milestone: m-1`.\n- Assert result is `milestone: m-2`.\n- Assert old value `m-1` is gone (and `Old Milestone` gone since that's no longer written).\n\n#### `test_assign_task_backslash_n_in_title`:\n- The malicious input `'Sprint 1\\ninjected: evil'` will NOT match any milestone title → script should exit non-zero.\n- Update test to assert non-zero exit code instead of checking for injected field (SEC-001 is now prevented at a higher level — no match = no write).\n- OR: keep a matching milestone titled `'Sprint 1\\ninjected: evil'` for completeness — but this is edge-case; simpler to test that unmatched titles are rejected.\n\n#### Add a new test: `test_assign_task_milestone_not_found`\n- Call `assign-task` with a title that has no matching milestone file.\n- Assert non-zero exit code.\n\n#### Add a new test: `test_assign_task_by_milestone_id`\n- Create milestone `m-1` with title "Sprint 1".\n- Call `assign-task 7 m-1` (passing the id directly).\n- Assert `milestone: m-1` is written.\n\n---\n\n### Step 5 — AC Mapping\n\n| AC | Steps covering it |\n|----|-------------------|\n| #1 Script assigns milestone using milestone id in task frontmatter | Steps 1, 2 |\n| #2 Milestone assignment consistent between CLI, UI, and scripts | Steps 1, 2 (id is what UI expects) |\n| #3 Regression tests pass | Steps 4 |\n| #4 Documentation updated if needed | Step 3 |\n\n---\n\n### Files to modify\n- `.github/skills/backlog-cli/scripts/milestone-helper.sh`\n- `tests/skills/backlog-cli/test-milestone-helper.sh`\n\n### Edge cases to handle\n- Milestone file with `name:` (old format, no `id:`) → `lookup_milestone_id` returns empty string; this becomes `milestone: ` which is invalid → emit error: "Milestone found but has no id field".\n- Multiple milestones matching same title → use first match (consistent with `head -1` pattern used elsewhere).\n- `MILESTONES_DIR` empty or missing → "Milestone not found" error.
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
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
