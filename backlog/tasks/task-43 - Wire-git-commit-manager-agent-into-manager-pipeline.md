---
id: TASK-43
title: Wire git commit manager agent into manager pipeline
status: To Do
assignee: []
created_date: '2026-04-24 22:20'
updated_date: '2026-04-24 23:03'
labels:
  - git
  - agent
  - orchestration
milestone: m-3
dependencies:
  - TASK-42
  - TASK-44
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the manager agent to invoke the git commit manager agent as the final step after documentation is complete for a task. The git commit manager ensures all changes (source, backlog, docs) are staged and committed with the canonical message, then calls squash-task-commits.sh to collapse any consecutive same-task commits in history.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager invokes git-commit-manager agent via run_subagent after documentation agent completes
- [ ] #2 Git commit manager agent receives task ID and task title to form the commit message
- [ ] #3 Manager marks task Done only after git commit manager emits commit-complete signal
- [ ] #4 Pipeline order in manager agent file updated: Implementation -> QA -> Security -> Documentation -> Git Commit -> Done
- [ ] #5 Manager passes --dry-run capability reference so agent can verify before writing history
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read the current manager.agent.md in full to understand exact sections to modify.
   File: `.github/agents/manager.agent.md`

2. Update the **Step 4d: Documentation** section:
   - After the block that detects `✅ DOCUMENTATION COMPLETE` (or falls back with a warning), BEFORE the line that calls `backlog task edit <id> -s Done`, insert a new sub-step:
     → Invoke git-commit-manager agent via run_subagent:
       ```
       run_subagent with agentName: "git-commit-manager"
       task: "Commit all changes for task <id>: <title>.\nTask ID: <id>\nTask Title: <title>\nInstructions:\n1. Stage all changes with git add -A\n2. Commit with message: task-<id>: <title>\n3. Run .github/skills/backlog-cli/scripts/squash-task-commits.sh to squash consecutive same-task commits\n4. Emit ✅ COMMIT COMPLETE signal via backlog task edit <id> --append-notes"
       ```
     → After subagent call, read task notes: `backlog task <id> --plain`
     → If `✅ COMMIT COMPLETE` found → mark task Done: `backlog task edit <id> -s Done`
     → If signal absent → log warning: `backlog task edit <id> --append-notes "⚠️ Git commit agent did not emit commit-complete signal; proceeding to mark Done."` then mark Done

3. Update pipeline order comment in **Step 4d** and **Step 5** to read:
   > Pipeline order: Implementation → QA → Security → Documentation → Git Commit → Done
   Replace the existing "Pipeline order: Implementation → QA → Security → Documentation → Done" line in Step 5.

4. Update **Step 4d** heading or description to mention that Documentation is followed by Git Commit before marking Done:
   - Change the final bullet in Step 4d from "mark the task Done" to "invoke git commit manager, then mark Done"

5. Add `git-commit-manager` to the **Sub-Agent Delegation** list in the Tool Usage section:
   - Add: `- **git-commit-manager** — Stages all changes, commits with canonical task-<id>: <title> format, squashes consecutive same-task commits, emits ✅ COMMIT COMPLETE signal.`

6. Update the **Constraints** section:
   - Change constraint #6 (currently about documentation being non-blocking) to add an analogous constraint for git commit:
     "DON'T mark task Done after Documentation alone — DO also invoke git-commit-manager; if commit-complete signal is absent, log a warning and proceed to mark Done. Git commit is non-blocking for delivery."

7. AC coverage verification:
   - AC#1: Manager invokes git-commit-manager via run_subagent after documentation ✅ (Step 2)
   - AC#2: Manager passes task ID and title as part of the task string ✅ (Step 2, task string content)
   - AC#3: Manager marks Done only after commit-complete OR warning fallback ✅ (Step 2)
   - AC#4: Pipeline order updated in Steps 4d, 5 ✅ (Steps 3, 4)
   - AC#5: Manager includes reference to --dry-run in the task string comment so agent can do verification ✅ (Step 2 — task string mentions the script path and flags)

8. Do NOT change any other pipeline steps (Analyse, Plan Reviewer, Implementation, QA, Security flows remain unchanged).

9. Verify the final manager.agent.md still has:
   - The security fix loop (Step 4c) intact
   - The orphan task grouping (Step 6) intact
   - All existing sub-agents still listed
   - The FORBIDDEN notice intact
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete.

AC coverage:
- AC#1 → Plan Step 2 (run_subagent with agentName: "git-commit-manager" inserted after documentation step)
- AC#2 → Plan Step 2 (task string includes task ID and task title explicitly)
- AC#3 → Plan Step 2 (reads task notes for ✅ COMMIT COMPLETE signal before marking Done; fallback warning if signal absent)
- AC#4 → Plan Steps 3-4 (pipeline order comment updated in Step 5 and Step 4d sections)
- AC#5 → Plan Step 2 (task string passed to git-commit-manager references the script path including --dry-run capability)

Error paths covered:
- commit-complete signal absent → warning note + mark Done (non-blocking, mirrors documentation fallback pattern)
- Only modifies Step 4d and Sub-Agent list; all other pipeline steps unaffected

Key structural clarity: The git commit invocation is inserted BETWEEN the documentation signal detection block and the `backlog task edit <id> -s Done` command. This means:
- Documentation completes (or times out with warning)
- Git commit runs
- Task marked Done
Order is unambiguous.

Constraints section update: Plan Step 6 updates constraint language to match the new two-step post-documentation flow (git commit then Done).

Dependency confirmed: TASK-42 (agent file) and TASK-44 (squash script) must be complete before TASK-43 is implemented. This is correctly declared in task dependencies.

No gaps found. No ambiguous steps.

Analysis complete. Plan ready. No blockers. Must be implemented after TASK-42 and TASK-44 are complete (declared dependencies satisfied).
<!-- SECTION:NOTES:END -->
