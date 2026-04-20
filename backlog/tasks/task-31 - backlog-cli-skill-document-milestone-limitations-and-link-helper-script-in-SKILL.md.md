---
id: TASK-31
title: >-
  backlog-cli skill: document milestone limitations and link helper script in
  SKILL.md
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
updated_date: '2026-04-20 20:44'
labels:
  - backlog-cli
  - skills
  - docs
milestone: Backlog CLI Milestone Helper
dependencies:
  - TASK-30
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SKILL.md currently notes milestone CLI limitations inline but does not reference the helper script or scripts/ folder. This task adds a scripts/ reference and proper documentation of the workaround pattern, linking to milestone-helper.sh once task-30 is complete.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 SKILL.md Milestones section references the scripts/ folder and milestone-helper.sh
- [ ] #2 SKILL.md explains the two operations the script covers: create milestone and assign task to milestone
- [ ] #3 A scripts/ folder exists at .github/skills/backlog-cli/scripts/ and is referenced from the SKILL.md resources/links section
- [ ] #4 References section at bottom of SKILL.md includes milestone-helper.sh link
- [ ] #5 SKILL.md notes test location (tests/skills/backlog-cli/) and how to run them with shunit2
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
0. Prerequisite: TASK-30 must be complete — milestone-helper.sh must exist at .github/skills/backlog-cli/scripts/milestone-helper.sh before this task begins.
1. Open .github/skills/backlog-cli/SKILL.md and identify the two locations containing existing direct-edit workaround content:
   a. Line ~40: the Exception callout after the Golden Rule ("Exception — milestone assignment: ... edit the task's frontmatter directly...").
   b. Lines ~187-198: the Milestones section frontmatter snippet and surrounding prose ("Assigning a task to a milestone must be done by editing the task's frontmatter directly").
2. Preserve ALL existing direct-edit workaround content exactly as written. Do NOT remove or replace it. This is the officially supported method and must remain clearly documented. The new script-based approach is an additional option, not a replacement.
3. Update the Milestones section (around line 173) to ADD a new "Option 2: Using the helper script" block AFTER the existing direct-edit documentation:
   a. Keep the existing frontmatter snippet and prose (step 1b content) intact above the new block.
   b. Add a clearly labelled subsection: "Option 2: Using the milestone-helper.sh script" with a brief intro explaining that the helper script automates both milestone creation and task assignment.
   c. Show example invocations under Option 2:
      - bash .github/skills/backlog-cli/scripts/milestone-helper.sh create-milestone "Sprint 1" "First sprint"
      - bash .github/skills/backlog-cli/scripts/milestone-helper.sh assign-task 42 "Sprint 1"
   d. Label the existing direct-edit block as "Option 1: Edit frontmatter directly" so both options are parallel and clearly distinguished.
4. Add a Scripts subsection (within or immediately after the Milestones section) that:
   a. Names .github/skills/backlog-cli/scripts/ as the location for helper scripts bundled with this skill.
   b. Lists milestone-helper.sh with a one-line description of each subcommand (create-milestone, assign-task).
5. Update the References section at the bottom of SKILL.md to add:
   - [milestone-helper.sh](./scripts/milestone-helper.sh) — shell script for milestone creation and task-to-milestone assignment
   The path must be exactly ./scripts/milestone-helper.sh (relative to SKILL.md location). Do not use an absolute path or a path relative to the repo root.
6. Add a Testing note in the Scripts subsection (or as a callout block) that:
   a. States test files live in tests/skills/backlog-cli/ at the repo root.
   b. Shows the run command: bash tests/skills/backlog-cli/test-milestone-helper.sh
   c. Notes the shunit2 dependency: brew install shunit2 (macOS) or apt-get install shunit2 (Debian/Ubuntu).
7. Confirm the scripts/ folder exists (.github/skills/backlog-cli/scripts/) — created by TASK-30; if absent, create it with a .gitkeep so the SKILL.md reference is not a broken link.
8. Final review: re-read the entire modified SKILL.md diff and verify:
   a. Both Option 1 (direct-edit) and Option 2 (helper script) are present and clearly labelled.
   b. All references to milestone-helper.sh use the relative path ./scripts/milestone-helper.sh.
   c. All example commands are syntactically valid.
   d. No existing documented behaviour has been removed.
9. Commit changes (SKILL.md update only; scripts/ folder and milestone-helper.sh committed by TASK-30).
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 5 ACs:
- AC1 (SKILL.md Milestones section references scripts/ and milestone-helper.sh) → steps 2–3
- AC2 (SKILL.md explains create-milestone and assign-task operations) → step 2c
- AC3 (scripts/ folder exists and is referenced from resources section) → steps 4 and 6
- AC4 (References section includes milestone-helper.sh link) → step 4
- AC5 (SKILL.md notes test location and how to run with shunit2) → step 5
Dependency on TASK-30 explicitly noted in plan step 0. No content to write until milestone-helper.sh exists (confirmed by TASK-30 dependency in task frontmatter). No other blockers. Analysis complete. Plan ready. No blockers.

🔍 PLAN REVIEW CONCERNS

- Concern #1 (MEDIUM): Existing workaround text not explicitly addressed. SKILL.md already contains a direct-edit workaround in two places: an Exception callout after the Golden Rule (around line 40) and the frontmatter snippet example under Milestones (lines 187-198). The plan says to "update the Milestones section narrative" but never says whether to replace, remove, or keep the existing content. If both the old direct-edit instructions and the new script references coexist, readers will see two conflicting guidance paths. The plan must explicitly state which existing text to remove or replace.

- Concern #2 (LOW): Reference link path format not specified. Step 4 adds a milestone-helper.sh entry to the References section but does not specify the relative path to use. Existing references use paths like ../../../backlog/docs/.... The correct relative path from SKILL.md to the script is ./scripts/milestone-helper.sh. Without specifying this, Implementation may produce a broken link. Plan should state the exact link format: [milestone-helper.sh](./scripts/milestone-helper.sh).

Verdict: Plan needs revision before implementation.

Analysis complete. Plan revised to address Plan Reviewer concerns. No blockers.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
