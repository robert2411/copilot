---
id: TASK-32
title: 'backlog-cli skill: remove direct-edit exception from Golden Rule'
status: To Do
assignee: []
created_date: '2026-04-20 21:07'
updated_date: '2026-04-20 21:09'
labels:
  - backlog-cli
  - skills
  - docs
milestone: Backlog CLI Skill Cleanup
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SKILL.md currently has an Exception callout under the Golden Rule (around line 40) that permits direct frontmatter editing for milestone assignment. This is no longer needed — milestone-helper.sh now covers both milestone creation and task assignment. The exception should be removed and replaced with a reference to the two supported methods: (1) backlog CLI commands, (2) milestone-helper.sh script.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Exception callout under the Golden Rule is removed from SKILL.md
- [ ] #2 Golden Rule section states only two supported methods: backlog CLI commands and milestone-helper.sh
- [ ] #3 Reference or link to .github/skills/backlog-cli/scripts/milestone-helper.sh is present near the Golden Rule section
- [ ] #4 No other location in SKILL.md instructs the reader to edit task or milestone files directly
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open `.github/skills/backlog-cli/SKILL.md` for editing.

2. **Remove the Exception callout under the Golden Rule (AC#1):**
   - Locate line 40: the blockquote starting with `> **Exception — milestone assignment:**`
   - Delete that entire paragraph (the `> **Exception...` block).

3. **Update the Golden Rule sentence to reference the two supported methods (AC#2 & AC#3):**
   - Current text (line 38): `**Golden rule:** Never edit task `.md` files directly. All writes go through the CLI.`
   - Replace with:
     ```
     **Golden rule:** Never edit task or milestone `.md` files directly. All writes go through the CLI.
     Two supported methods exist for milestone operations: (1) `backlog` CLI commands, (2) the [`milestone-helper.sh`](.github/skills/backlog-cli/scripts/milestone-helper.sh) script.
     ```
   - This satisfies AC#2 (two methods stated) and AC#3 (link to milestone-helper.sh present).

4. **Remove "Option 1: Edit frontmatter directly" from the Milestones section (AC#4):**
   - Locate lines ~188-202 under `### Milestones` > `#### Option 1: Edit frontmatter directly`.
   - Delete that entire block (heading, explanation paragraph, yaml code block, and the note below it).
   - Rename `#### Option 2: Using the milestone-helper.sh script` to just `#### Using milestone-helper.sh` (remove the "Option 2" prefix).
   - Also remove the introductory sentence "Two options are available..." and replace with "Use the `milestone-helper.sh` script to create milestones and assign tasks:".

5. **Update the Task Content Reference table (AC#4):**
   - Locate the Milestone row (line ~354): `| Milestone | *(frontmatter only)* | Set \`milestone: <name>\` in task frontmatter — no CLI flag exists |`
   - Replace with: `| Milestone | *(milestone-helper.sh)* | Use \`milestone-helper.sh assign-task <id> "<name>"\` — no CLI flag exists |`

6. **Verify AC#4 — scan for remaining direct-edit instructions:**
   - Run: `grep -n "frontmatter" .github/skills/backlog-cli/SKILL.md`
   - Run: `grep -n "edit.*directly\|directly.*edit" .github/skills/backlog-cli/SKILL.md`
   - Confirm no remaining instructions to edit task or milestone files directly.

7. **Commit the changes:**
   - `git add .github/skills/backlog-cli/SKILL.md`
   - `git commit -m "docs(skill): remove direct-edit exception from Golden Rule in SKILL.md"`

8. **Verify all ACs:**
   - AC#1: Confirm `> **Exception — milestone assignment:**` blockquote is gone.
   - AC#2: Confirm Golden Rule now mentions backlog CLI + milestone-helper.sh as the only two methods.
   - AC#3: Confirm a reference/link to `.github/skills/backlog-cli/scripts/milestone-helper.sh` appears near the Golden Rule.
   - AC#4: Confirm `grep -n "frontmatter\|edit.*directly" SKILL.md` returns no lines instructing direct file edits.
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
