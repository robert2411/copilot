---
id: TASK-31
title: >-
  backlog-cli skill: document milestone limitations and link helper script in
  SKILL.md
status: To Do
assignee: []
created_date: '2026-04-20 20:22'
updated_date: '2026-04-20 20:41'
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
1. Open .github/skills/backlog-cli/SKILL.md and locate the Milestones section (around line 173).
2. Update the Milestones section narrative to:
   a. State that two operations cannot be done via the CLI natively: creating milestones and assigning tasks to them.
   b. Introduce milestone-helper.sh as the supported workaround for both operations.
   c. Show example invocations:
      - bash .github/skills/backlog-cli/scripts/milestone-helper.sh create-milestone "Sprint 1" "First sprint"
      - bash .github/skills/backlog-cli/scripts/milestone-helper.sh assign-task 42 "Sprint 1"
3. Add a `scripts/` subsection under Milestones (or a dedicated Scripts section) that:
   a. Lists .github/skills/backlog-cli/scripts/ as the location for helper scripts bundled with this skill.
   b. Links to milestone-helper.sh with a brief one-line description of each subcommand.
4. Update (or add) the References / Resources section at the bottom of SKILL.md to include:
   - `scripts/milestone-helper.sh` — shell script for milestone creation and task assignment
5. Add a Testing subsection (or note in the scripts section) that:
   a. States test files live in tests/skills/backlog-cli/ at the repo root.
   b. Documents how to run them: `bash tests/skills/backlog-cli/test-milestone-helper.sh`
   c. Notes the shunit2 dependency and installation command.
6. Confirm the scripts/ folder exists (.github/skills/backlog-cli/scripts/) — it will be created by TASK-30; if somehow absent, create it with a .gitkeep so the reference in SKILL.md is not broken.
7. Review entire SKILL.md diff for consistency: ensure all references to milestone-helper.sh use the correct relative path, all example commands are syntactically valid, and no existing documented behaviour is accidentally removed.
8. Commit changes (SKILL.md update only; scripts/ folder created by TASK-30).
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
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
