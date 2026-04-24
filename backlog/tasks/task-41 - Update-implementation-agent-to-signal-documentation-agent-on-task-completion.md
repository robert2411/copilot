---
id: TASK-41
title: Update implementation agent to signal documentation agent on task completion
status: To Do
assignee: []
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:29'
labels:
  - documentation
  - agent
  - implementation
milestone: m-2
dependencies:
  - TASK-39
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the implementation agent system prompt so it knows the documentation agent runs after security approval. The implementation agent should pass the task ID, list of changed files, and final summary to the manager for routing to documentation.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Implementation agent constraints updated to not mark task Done until documentation step is complete
- [ ] #2 Implementation agent final-summary step notes that summary will be passed to documentation agent
- [ ] #3 Implementation agent sub-agent delegation section lists documentation agent role
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open `.github/agents/implementation.agent.md` for editing.
2. **Update Step 7: Commit & Complete** — remove the `backlog task edit <id> -s Done` command and its "Order matters" warning. Replace it with:
   - Add the final summary (unchanged).
   - Commit WITHOUT marking Done:
     ```bash
     git add -A
     git commit -m "task-<id>: <brief description>"
     ```
   - Add a note explaining that Done status is set by the Manager after the Documentation step completes, not by the Implementation agent.
3. **Update Step 8: Next Task or Report Completion** — change the milestone-complete note from implying the task is Done to reporting "Implementation and QA complete — awaiting Security and Documentation routing by Manager". The implementation agent signals readiness to the Manager rather than marking Done itself.
4. **Update the final-summary step (Step 7)** — add an explicit note in the `--final-summary` usage block:
   > The final summary is passed by the Manager to the Documentation agent. Include: what changed, why, which files were modified, and any architectural decisions made. This helps the Documentation agent determine what to record.
5. **Update the Sub-Agent Delegation section** — in the "Sub-Agent Delegation" → bullet list, add:
   - **documentation** — Invoked by the Manager (not directly by Implementation) after Security approves. Reads the final-summary and changed-files list produced in Step 7 to update backlog/docs and backlog/decisions.
6. **Update Constraints** — change Constraint #3 (currently "DON'T commit before marking the task Done — DO set status Done first, then run git commit") to:
   > DON'T mark task Done yourself — DO leave Done status to the Manager, which sets it after the Documentation step completes. Commit after QA approval.
7. **Verify consistency** — read through the full updated file and confirm:
   - No remaining reference to `backlog task edit <id> -s Done` by the implementation agent.
   - The final-summary step clearly documents that it feeds the documentation pipeline.
   - Sub-Agent Delegation section lists: qa, analyse, documentation (manager-invoked).
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 3 ACs. AC1→Step 6 (Constraint #3 updated: DON'T mark Done yourself), AC2→Step 4 (final-summary block notes it feeds the documentation agent), AC3→Step 5 (Sub-Agent Delegation section lists documentation). Key risk: removing Done-marking from implementation creates a pipeline dependency on Manager correctly marking Done after documentation — addressed by TASK-40 plan. Verified current implementation agent Step 7 is the only location marking -s Done. No ambiguous steps.

Analysis complete. Plan ready. Depends on TASK-39 completing first. Coordinate with TASK-40 — both modify the pipeline handoff at the implementation boundary.

🔍 PLAN REVIEW CONCERNS:
- Concern #1 (Role & Scope section not updated): The current implementation.agent.md Role & Scope section (line 29) reads "Mark tasks Done, then commit." After TASK-41's changes, Done is no longer set by the implementation agent — it is set by the Manager after Documentation completes. The plan does not include a step to update the Role & Scope description, leaving it stale and misleading. Plan Step 7 (verify consistency) checks for stale CLI references but does not check the Role & Scope prose. A step must be added to update that description to something like "Commit after QA approval; Done status is set by the Manager after the Documentation step."
- Concern #2 (No dependency on TASK-40 / deployment atomicity risk): TASK-41 removes the implementation agent's Done-marking responsibility. TASK-40 adds Done-marking to the Manager. Both must be deployed together — if TASK-41 is committed without TASK-40, no agent marks tasks Done and the pipeline stalls. TASK-41's dependency list only includes TASK-39; it should also declare a dependency on TASK-40 (or the plan must explicitly note that TASK-41 and TASK-40 must be committed in the same batch and never independently).

Verdict: Plan needs revision before implementation.
<!-- SECTION:NOTES:END -->
