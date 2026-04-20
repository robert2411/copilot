---
id: TASK-29
title: 'Fix Backlog CLI skill doc: document correct milestone assignment method'
status: Done
assignee:
  - '@implementation'
created_date: '2026-04-19 20:04'
updated_date: '2026-04-20 20:30'
labels:
  - docs
  - backlog-skill
milestone: Backlog Skill Doc Fixes
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The skill doc incorrectly implies milestone assignment can be done via CLI flag (--milestone). Validated: no such flag exists on task create or task edit. Must document the correct approach: edit task frontmatter directly to add milestone field, or set it in the milestone file itself.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Skill doc updated to remove any reference to --milestone CLI flag
- [x] #2 Skill doc documents correct method: add 'milestone: <name>' to task frontmatter directly
- [x] #3 Skill doc notes milestone CLI only supports: list and archive commands
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. VERIFY current SKILL.md state — the fix is already committed (commit 79a6838: "task-29: fix SKILL.md — document correct milestone assignment via frontmatter").
2. Confirm AC #1 (no --milestone flag references): grep confirms no incorrect usage exists; lines 40 and 185 correctly state the flag does NOT exist.
3. Confirm AC #2 (frontmatter method documented): line 40 exception note + lines 187–198 YAML example in the Milestones section both document adding `milestone: <name>` to frontmatter.
4. Confirm AC #3 (milestone CLI scope documented): line 185 note explicitly states "only supports `list` and `archive` commands."
5. Confirm reference table (line 307) shows Milestone as "*(frontmatter only)*" with "no CLI flag exists" note.
6. Since all code is already committed, check all three ACs on the task: `backlog task edit 29 --check-ac 1 --check-ac 2 --check-ac 3`
7. Write a final summary capturing what was changed: `backlog task edit 29 --final-summary "..."`
8. Mark task Done: `backlog task edit 29 -s Done`

Files changed (already committed):
- .github/skills/backlog-cli/SKILL.md
  - Line 40: Added exception note under Golden Rule clarifying no --milestone flag exists; correct method is frontmatter edit
  - Lines 175-198 (Milestones section): Added Note callout scoping milestone CLI to list/archive only; added YAML frontmatter example
  - Line 307: Updated reference table row for Milestone to show "*(frontmatter only)*"

No additional code changes are required. Implementation agent only needs to reconcile task state with committed reality.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all ACs. No gaps or unverified assumptions.

Key finding: all three ACs are already satisfied in the committed SKILL.md (commit 79a6838). The task state (To Do, unchecked ACs) has not been reconciled with the committed work. No new code changes are needed — Implementation agent should verify the file, check off all ACs, write a final summary, and mark Done.

Analysis complete. No blockers. Implementation already committed — task closure is the only remaining work.

✅ PLAN APPROVED — plan is complete, all ACs covered, no ambiguity
- Steps verified: 8
- AC mapped: 3/3
- AC #1 confirmed: lines 40 & 185 state no --milestone flag exists; no incorrect flag usage present
- AC #2 confirmed: lines 40, 187-198 & 307 document milestone: <name> frontmatter method with YAML example
- AC #3 confirmed: line 185 explicitly scopes milestone CLI to list and archive only
- All changes already committed (commit 79a6838); no new code changes required

All AC/DoD checked. Ready for QA.

✅ QA APPROVED — all tests passing, no regressions
- AC/DoD: Complete
- AC1 verified: No incorrect `--milestone` usage; lines 40, 185, 307 correctly state no CLI flag exists
- AC2 verified: Correct method documented via task frontmatter `milestone: <name>` (lines 40, 187-198, 307)
- AC3 verified: Milestone CLI scope correctly documented as `list` and `archive` only (line 185)
- Documentation quality: Clear, accurate, and complete for milestone assignment guidance
- Security/Spelling: No issues found in reviewed document
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Verified SKILL.md correctly documents milestone assignment via frontmatter only. All 3 ACs confirmed satisfied in commit 79a6838. No --milestone flag references remain; correct frontmatter method documented; milestone CLI scoped to list/archive only.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
