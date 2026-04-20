---
id: TASK-32
title: 'backlog-cli skill: remove direct-edit exception from Golden Rule'
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-20 21:07'
updated_date: '2026-04-20 21:17'
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
- [x] #1 Exception callout under the Golden Rule is removed from SKILL.md
- [x] #2 Golden Rule section states only two supported methods: backlog CLI commands and milestone-helper.sh
- [x] #3 Reference or link to .github/skills/backlog-cli/scripts/milestone-helper.sh is present near the Golden Rule section
- [x] #4 No other location in SKILL.md instructs the reader to edit task or milestone files directly
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open `.github/skills/backlog-cli/SKILL.md` for editing.

2. **Remove the Exception callout under the Golden Rule (AC#1):**
   - Locate line 40: the blockquote starting with `> **Exception — milestone assignment:**`
   - Delete that entire paragraph (the `> **Exception...` block).

3. **Update the Golden Rule sentence to reference the two supported methods (AC#2 & AC#3):**
   - Current text (line 38): `**Golden rule:** Never edit task \`.md\` files directly. All writes go through the CLI.`
   - Replace with the following exact sentence (removes the contradiction — milestone-helper.sh patches frontmatter directly so it is not "the CLI"):
     `**Golden rule:** Never edit task or milestone \`.md\` files directly. All writes go through the CLI or the approved [\`milestone-helper.sh\`](.github/skills/backlog-cli/scripts/milestone-helper.sh) script.`
   - This satisfies AC#2 (two methods: backlog CLI commands and milestone-helper.sh) and AC#3 (link to milestone-helper.sh present near the Golden Rule).

4. **Remove "Option 1: Edit frontmatter directly" from the Milestones section (AC#4):**
   - Locate lines ~189-202 under `### Milestones` > `#### Option 1: Edit frontmatter directly`.
   - Delete that entire block: the heading, the introductory sentence "**Assigning a task to a milestone** must be done by editing the task's frontmatter directly:", the yaml code block, and the "Add or update..." note below it.\n   - Rename `#### Option 2: Using the milestone-helper.sh script` → `#### Using the milestone-helper.sh script` (drop the "Option 2" prefix).\n   - Replace the introductory sentence "Two options are available for creating milestones and assigning tasks to them:" with "Use the `milestone-helper.sh` script to create milestones and assign tasks to them:".\n\n5. **Update the Task Content Reference table (AC#4):**\n   - Locate the Milestone row (line ~354): `| Milestone | *(frontmatter only)* | Set \`milestone: <name>\` in task frontmatter — no CLI flag exists |`\n   - Replace with: `| Milestone | *(milestone-helper.sh)* | Use \`bash .github/skills/backlog-cli/scripts/milestone-helper.sh assign-task <id> "<name>"\` — no CLI flag exists |`\n\n6. **Verify AC#4 — scan for remaining direct-edit instructions:**\n   - Run: `grep -n "frontmatter" .github/skills/backlog-cli/SKILL.md`\n     Expected/acceptable residual matches (do NOT remove these):\n       • A match containing "by patching task frontmatter" — this is inside the milestone-helper.sh description block (the `create-milestone`/`assign-task` explanation) and describes what the script does internally. It is not an instruction to the reader.\n       • A match containing "sets \`milestone:\` in the task's frontmatter" — also inside the milestone-helper.sh description block, describing the `assign-task` subcommand behaviour. Also acceptable.\n     Patterns that confirm a problem (must be absent):\n       • Any line containing an imperative instruction such as "edit the task's frontmatter directly", "edit.*frontmatter.*directly", or "must be done by editing the.*frontmatter".\n   - Run: `grep -n "edit.*directly\\|directly.*edit" .github/skills/backlog-cli/SKILL.md`\n     This must return zero results after the edit.\n   - Run: `grep -n "Option 1\\|Option 2" .github/skills/backlog-cli/SKILL.md`\n     This must return zero results after the edit.\n\n7. **Commit the changes:**\n   - `git add .github/skills/backlog-cli/SKILL.md`\n   - `git commit -m "docs(skill): remove direct-edit exception from Golden Rule in SKILL.md"`\n\n8. **Verify all ACs:**\n   - AC#1: Confirm `> **Exception — milestone assignment:**` blockquote is gone.\n   - AC#2: Confirm Golden Rule now reads "All writes go through the CLI or the approved milestone-helper.sh script." — no mention of direct editing, no contradiction.\n   - AC#3: Confirm a link to `.github/skills/backlog-cli/scripts/milestone-helper.sh` appears in the Golden Rule line itself.\n   - AC#4: Confirm grep checks from Step 6 pass: no imperative direct-edit instructions remain; only acceptable descriptor-level frontmatter references remain inside the milestone-helper.sh description block.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 4 ACs:
- AC#1 → Step 2 (remove Exception callout).
- AC#2 → Step 3 (update Golden Rule text with two methods).
- AC#3 → Step 3 (add link to milestone-helper.sh near Golden Rule).
- AC#4 → Steps 4–5 (remove Option 1 direct-edit block from Milestones section; update Task Reference table row).
Error paths: Step 6 grep scan catches any missed direct-edit instructions. No unverified assumptions — SKILL.md reviewed in full; both the Exception callout (line 40) and the Option 1 frontmatter section (lines 188-202) and the table row (line 354) are confirmed present and targeted. Analysis complete. No blockers.

🔍 PLAN REVIEW CONCERNS
- Concern #1 (AC#2 — wording contradiction): Plan Step 3 proposes keeping "All writes go through the CLI." immediately followed by "Two supported methods exist: (1) backlog CLI commands, (2) milestone-helper.sh script." milestone-helper.sh patches frontmatter directly — it is not the CLI. Keeping the "All writes go through the CLI" sentence while endorsing a non-CLI script as an equal method creates a self-contradiction on adjacent lines. The phrase needs updating, e.g. "All writes go through the CLI or approved helper scripts." Plan must specify the corrected phrasing.
- Concern #2 (AC#4 — grep verification ambiguous): After all changes, grep -n "frontmatter" will still return lines 206 and 217 (script-behaviour descriptions: "by patching task frontmatter" and "sets milestone: in the task's frontmatter"). Plan Step 6 says "confirm no remaining instructions to edit directly" but does not tell the implementer that these residual matches are acceptable. Without this clarification the implementer may over-remove valid documentation or treat the grep as a failing check. Plan must explicitly note that post-edit frontmatter references inside the milestone-helper.sh description block are expected and acceptable.\n\nVerdict: Plan needs revision before implementation.

Plan revised to address Plan Reviewer concerns. No blockers.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 8
- AC mapped: 4/4
- Previous concerns resolved:
  #1 (Golden Rule contradiction): Step 3 supplies the exact replacement sentence; contradiction eliminated.
  #2 (grep ambiguity): Step 6 explicitly names acceptable residual frontmatter matches (lines 206, 217) and problem patterns that must be absent; two additional grep checks added.
- No new concerns found.

- Removed Exception callout blockquote from line ~40 (AC#1)
- Updated Golden Rule to reference both CLI and milestone-helper.sh (AC#2 + AC#3)
- Removed "Option 1: Edit frontmatter directly" block from Milestones section (AC#4)
- Renamed "Option 2: Using the milestone-helper.sh script" → "Using the milestone-helper.sh script" (AC#4)
- Updated intro sentence for milestones section to remove "Two options" framing (AC#4)
- Updated Task Content Reference table Milestone row to reference milestone-helper.sh instead of frontmatter (AC#4)
- Grep checks: no Option 1/2 remaining, no imperative direct-edit instructions, only acceptable descriptor-level frontmatter references remain
All AC/DoD checked. Ready for QA.

❌ QA REJECTED: AC/DoD incomplete.
- Missing: DoD #1 (All code is committed to git)

✅ QA APPROVED — all tests passing, no regressions
- Scope reviewed: code/content quality only (per request)
- Golden Rule updated correctly with milestone-helper.sh link
- Milestones section unified to single method
- No Option 1/Option 2 remnants
- No direct-edit instructions remain; frontmatter mentions are descriptive only
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
