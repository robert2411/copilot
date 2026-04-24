---
id: TASK-39
title: Create documentation agent file
status: In Progress
assignee:
  - '@myself'
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:35'
labels:
  - documentation
  - agent
milestone: m-2
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the documentation agent that runs after implementation completes. The agent inspects each completed task's final summary, implementation notes, and changed files, then ensures all significant decisions, patterns, and outcomes are captured in backlog/docs or backlog/decisions. If a relevant doc/decision already exists it updates it; otherwise it creates a new one.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Agent file exists at .github/agents/documentation.agent.md with correct frontmatter
- [ ] #2 Agent reads completed task details via backlog task <id> --plain
- [ ] #3 Agent lists existing docs via backlog doc list --plain and scans backlog/decisions/
- [ ] #4 Agent updates an existing doc when the content is relevant to a completed task
- [ ] #5 Agent creates a new backlog doc when no relevant doc exists
- [ ] #6 Agent creates a new backlog decision record when the task involved an architectural or design choice
- [ ] #7 Agent appends notes to the task indicating what was documented and where
- [ ] #8 Agent frontmatter sets user-invocable to false
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create the file `.github/agents/documentation.agent.md` using the `create_file` tool.
2. Add YAML frontmatter at the top of the file:
   - `name: documentation`
   - `description`: concise multi-line description explaining the agent audits completed tasks and persists outcomes to backlog/docs and backlog/decisions; include a "Use this agent when:" line for discoverability.
   - `color: "#6366F1"` (indigo — distinct from existing agents: blue=#0078D4, green=#2EA043, orange=#FF6B35, purple=#7B5EA7)
   - `user-invocable: false`
3. Write the system-prompt heading: `# Documentation Agent — System Prompt`
4. Write the FORBIDDEN / CLI-only notice — but MODIFIED for the documentation agent. The standard boilerplate prohibits `insert_edit_into_file` and `replace_string_in_file` on any `./backlog` path. For the documentation agent this blanket prohibition must be explicitly carved out for existing `backlog/docs/<filename>` and `backlog/decisions/<filename>` files. Rationale: no `backlog doc edit` or `backlog decision edit` CLI command exists (verified: `backlog doc --help` lists only `create`, `list`, `view`), so direct file editing is the only viable mechanism for updating existing records. The notice must read something like:
   > **🚫 FORBIDDEN (modified for this agent):** Writing directly to the `./backlog` folder is prohibited **EXCEPT** when updating existing `backlog/docs/` or `backlog/decisions/` files — those MUST be edited directly via `insert_edit_into_file` or `replace_string_in_file` because no CLI edit command exists for these resources. All *create* operations (new docs, new decision records, task note appends) MUST still go through the backlog CLI.
5. Write **Role & Scope** section:
   - Receives task ID, changed files list, and final summary from the Manager.
   - Inspects completed task details and matches them against existing docs/decisions.
   - Updates existing docs or creates new ones; creates decision records for architectural choices.
   - Appends a documentation-complete signal to the task notes.
   - Does NOT implement code, modify source files, or communicate with any agent other than the Manager.
6. Write **Workflow** as numbered steps:
   - Step 1: Read task — `backlog task <id> --plain` — extract description, implementation notes, final-summary, and changed-files list.
   - Step 2: List existing docs — `backlog doc list --plain` — collect all doc IDs and titles. Also run `list_dir` on `backlog/decisions/` to collect decision filenames.
   - Step 3: Read candidates — for each doc/decision whose title is thematically related to the task, run `backlog doc view <docId>` (for docs) or `read_file` (for decisions) to read full content.
   - Step 4: Match — decide for each candidate whether the task outcome is relevant enough to warrant an update. Criteria: same subsystem, same pattern, same agent, or same architectural area.
   - Step 5: Update existing doc — if a relevant doc exists, use `insert_edit_into_file` or `replace_string_in_file` to append a new dated section or update stale content. Do NOT use `backlog doc create` for updates — edit the existing file at `backlog/docs/<filename>`. (This is the carve-out to the FORBIDDEN notice — permitted because no CLI edit command exists.)
   - Step 6: Create new doc — if no relevant doc exists and the task produced reusable reference material, run `backlog doc create "<Descriptive Title>"` then use `insert_edit_into_file` to write the content into the newly created file (path returned by the CLI or found via `list_dir`).
   - Step 7: Create decision record — if the task involved an architectural or design decision (e.g. new agent added to pipeline, new naming convention chosen, new tool pattern adopted), run `backlog decision create "<Decision Title>" --status "Accepted"` then use `insert_edit_into_file` to write context, options considered, and rationale into the new file under `backlog/decisions/`.
   - Step 8: Append completion notes — write a summary note to the task using `backlog task edit <id> --append-notes` listing exactly which docs/decisions were created or updated and their IDs/paths. Format the note to begin with `✅ DOCUMENTATION COMPLETE` so the Manager can detect the signal.
7. Write **Tool Usage** section listing allowed tools: `read_file`, `list_dir`, `insert_edit_into_file`, `replace_string_in_file`, `run_in_terminal` (CLI only — backlog commands). Explicitly mark `run_subagent` as NOT used.
8. Write **Output** section: per-task note appended via `--append-notes` beginning with `✅ DOCUMENTATION COMPLETE`, listing each doc/decision touched.
9. Write **Constraints** section (7 rules, mirroring other agents):
   - DON'T edit source/test/config files — DO only touch backlog/docs and backlog/decisions.
   - DON'T create a new doc if an existing one covers the topic — DO update the existing doc.
   - DON'T skip listing existing docs first — DO always scan before creating.
   - DON'T create a decision unless an architectural/design choice was made — DO check task notes for evidence.
   - DON'T use `insert_edit_into_file` or `replace_string_in_file` on `./backlog` files except for existing `backlog/docs/` and `backlog/decisions/` files — DO use the backlog CLI for all create operations (doc create, decision create, task note appends).
   - DON'T omit the ✅ DOCUMENTATION COMPLETE signal — DO always append the note even if nothing needed documenting (note "no documentation changes required").
   - DON'T edit task files directly — DO use `backlog task edit` CLI commands.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 8 ACs. AC1→Steps 1-2 (file+frontmatter), AC2→Workflow Step 1, AC3→Workflow Steps 2-3, AC4→Workflow Steps 4-5, AC5→Workflow Step 6, AC6→Workflow Step 7, AC7→Workflow Step 8, AC8→Step 2. CLI commands (backlog doc view, backlog decision create --status) verified available. Fallback note for no-documentation-needed case included. No gaps or unverified assumptions.

Analysis complete. Plan ready. No blockers.

🔍 PLAN REVIEW CONCERNS:
- Concern #1 (Self-contradiction in FORBIDDEN boilerplate): Plan Step 4 instructs writing the standard FORBIDDEN boilerplate, which explicitly prohibits `insert_edit_into_file` and `replace_string_in_file` on any file within `./backlog`. However, Workflow Step 5 instructs the documentation agent to use exactly those tools to update existing docs in `backlog/docs/`. There is no `backlog doc edit` CLI command (verified: `backlog doc --help` lists only `create`, `list`, `view`), so direct file editing is the only viable mechanism. As written the agent file will contain directly contradictory instructions. The plan must specify that the FORBIDDEN boilerplate be modified or annotated for the documentation agent to explicitly carve out `insert_edit_into_file` / `replace_string_in_file` on existing `backlog/docs/` and `backlog/decisions/` files, making clear this is permitted because no CLI edit command exists for those resources.

Verdict: Plan needs revision before implementation.

Plan revised: FORBIDDEN boilerplate carve-out for backlog/docs and backlog/decisions edits specified.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 9 (Steps 1–2 file/frontmatter, Steps 3–4 FORBIDDEN boilerplate with carve-out, Step 5 Role & Scope, Steps 6–9 Workflow + Tool Usage + Output + Constraints)
- AC mapped: 8/8 (AC1→Steps 1–2, AC2→Workflow Step 1, AC3→Workflow Steps 2–3, AC4→Workflow Steps 4–5, AC5→Workflow Step 6, AC6→Workflow Step 7, AC7→Workflow Step 8, AC8→Step 2)
- Previous concern resolved: FORBIDDEN boilerplate carve-out for backlog/docs/ and backlog/decisions/ edits explicitly specified in Step 4, Workflow Step 5, and Constraint 5. CLI-only rule retained for all create operations.
<!-- SECTION:NOTES:END -->
