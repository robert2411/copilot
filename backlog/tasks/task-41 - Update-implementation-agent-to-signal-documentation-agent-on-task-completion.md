---
id: TASK-41
title: Update implementation agent to signal documentation agent on task completion
status: In Progress
assignee:
  - '@myself'
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:40'
labels:
  - documentation
  - agent
  - implementation
milestone: m-2
dependencies:
  - TASK-40
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
- [x] #1 Implementation agent constraints updated to not mark task Done until documentation step is complete
- [x] #2 Implementation agent final-summary step notes that summary will be passed to documentation agent
- [x] #3 Implementation agent sub-agent delegation section lists documentation agent role
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open `.github/agents/implementation.agent.md` for editing.
2. **Update Role & Scope section** — locate the prose line that reads "Mark tasks Done, then commit." and replace it with:
   > "Commit after QA approval; Done status is set by the Manager after the Documentation step completes."
   This ensures the Role & Scope description accurately reflects the updated pipeline and is not left stale after the changes in Steps 3–6.
3. **Update Step 7: Commit & Complete** — remove the `backlog task edit <id> -s Done` command and its "Order matters" warning. Replace it with:
   - Add the final summary (unchanged).
   - Commit WITHOUT marking Done:
     ```bash
     git add -A
     git commit -m "task-<id>: <brief description>"
     ```
   - Add a note explaining that Done status is set by the Manager after the Documentation step completes, not by the Implementation agent.
4. **Update Step 8: Next Task or Report Completion** — change the milestone-complete note from implying the task is Done to reporting "Implementation and QA complete — awaiting Security and Documentation routing by Manager". The implementation agent signals readiness to the Manager rather than marking Done itself.
5. **Update the final-summary step (Step 7)** — add an explicit note in the `--final-summary` usage block:
   > The final summary is passed by the Manager to the Documentation agent. Include: what changed, why, which files were modified, and any architectural decisions made. This helps the Documentation agent determine what to record.
6. **Update the Sub-Agent Delegation section** — in the "Sub-Agent Delegation" → bullet list, add:
   - **documentation** — Invoked by the Manager (not directly by Implementation) after Security approves. Reads the final-summary and changed-files list produced in Step 7 to update backlog/docs and backlog/decisions.
7. **Update Constraints** — change Constraint #3 (currently "DON'T commit before marking the task Done — DO set status Done first, then run git commit") to:
   > DON'T mark task Done yourself — DO leave Done status to the Manager, which sets it after the Documentation step completes. Commit after QA approval.
8. **Verify consistency** — read through the full updated file and confirm:
   - No remaining reference to `backlog task edit <id> -s Done` by the implementation agent.
   - Role & Scope section no longer references "Mark tasks Done".
   - The final-summary step clearly documents that it feeds the documentation pipeline.
   - Sub-Agent Delegation section lists: qa, analyse, documentation (manager-invoked).
9. **Atomicity note** — TASK-41 (remove Done-marking from Implementation) and TASK-40 (add Done-marking to Manager after Documentation) MUST be deployed together in the same commit. If TASK-41 is committed without TASK-40, no agent marks tasks Done and the pipeline stalls. TASK-40 is declared as a dependency and both tasks must be included in the same PR/merge.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Self-review complete. Plan covers all 3 ACs. AC1→Step 6 (Constraint #3 updated: DON'T mark Done yourself), AC2→Step 4 (final-summary block notes it feeds the documentation agent), AC3→Step 5 (Sub-Agent Delegation section lists documentation). Key risk: removing Done-marking from implementation creates a pipeline dependency on Manager correctly marking Done after documentation — addressed by TASK-40 plan. Verified current implementation agent Step 7 is the only location marking -s Done. No ambiguous steps.

Analysis complete. Plan ready. Depends on TASK-39 completing first. Coordinate with TASK-40 — both modify the pipeline handoff at the implementation boundary.

🔍 PLAN REVIEW CONCERNS:
- Concern #1 (Role & Scope section not updated): The current implementation.agent.md Role & Scope section (line 29) reads "Mark tasks Done, then commit." After TASK-41's changes, Done is no longer set by the implementation agent — it is set by the Manager after Documentation completes. The plan does not include a step to update the Role & Scope description, leaving it stale and misleading. Plan Step 7 (verify consistency) checks for stale CLI references but does not check the Role & Scope prose. A step must be added to update that description to something like "Commit after QA approval; Done status is set by the Manager after the Documentation step."
- Concern #2 (No dependency on TASK-40 / deployment atomicity risk): TASK-41 removes the implementation agent's Done-marking responsibility. TASK-40 adds Done-marking to the Manager. Both must be deployed together — if TASK-41 is committed without TASK-40, no agent marks tasks Done and the pipeline stalls. TASK-41's dependency list only includes TASK-39; it should also declare a dependency on TASK-40 (or the plan must explicitly note that TASK-41 and TASK-40 must be committed in the same batch and never independently).

Verdict: Plan needs revision before implementation.

Plan revised: Role & Scope update step added; TASK-40 dependency declared; atomicity note added.

✅ PLAN APPROVED — plan is complete, all AC covered, no ambiguity
- Steps verified: 9 (Steps 1–8 implementation.agent.md edits + Step 9 atomicity note)
- AC mapped: 3/3 (AC1→Steps 3+7 remove -s Done from workflow + update Constraint #3, AC2→Step 5 final-summary block annotated to feed documentation agent, AC3→Step 6 Sub-Agent Delegation lists documentation)
- Previous concern #1 resolved: Step 2 explicitly updates Role & Scope prose from "Mark tasks Done, then commit." to reflect new pipeline.
- Previous concern #2 resolved: TASK-40 declared as dependency in task header; Step 9 atomicity note mandates both tasks committed together in same PR/merge.
- Note: Minor AC-mapping label error in Implementation Notes (says AC1→Step 6, should be Step 7) — does not affect plan correctness.
<!-- SECTION:NOTES:END -->
