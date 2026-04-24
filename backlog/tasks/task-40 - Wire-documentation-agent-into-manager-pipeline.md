---
id: TASK-40
title: Wire documentation agent into manager pipeline
status: To Do
assignee: []
created_date: '2026-04-24 22:14'
updated_date: '2026-04-24 22:24'
labels:
  - documentation
  - agent
  - orchestration
milestone: m-2
dependencies:
  - TASK-39
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the manager agent to invoke the documentation agent after implementation and security are approved for each task. The documentation agent runs as the final step before marking a task Done, ensuring outcomes are persisted to backlog docs/decisions.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Manager invokes documentation agent via run_subagent after security approves each task
- [ ] #2 Documentation agent receives task ID, changed files, and final summary in the subagent call
- [ ] #3 Manager waits for documentation agent to emit doc-complete signal before marking task Done
- [ ] #4 Manager step 4b (after security) updated in agent file to include documentation step
- [ ] #5 Pipeline order documented: Implementation -> QA -> Security -> Documentation -> Done
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Open `.github/agents/manager.agent.md` for editing.
2. Locate the **Step 4b** section (currently titled "Route to Security Agent After QA Approval").
3. In Step 4b, find the block:
   ```
   - If `✅ SECURITY APPROVED` → mark task Done, proceed to next task
   ```
   Replace it with:
   ```
   - If `✅ SECURITY APPROVED` → invoke documentation agent (see Step 4d below)
   - If `⚠️ SECURITY FINDINGS` → enter the security fix loop (Step 4c)
   ```
4. After the **Step 4c: Security Fix Loop** section, insert a new **Step 4d: Route to Documentation Agent** section containing:
   a. Use `run_subagent` with `agentName: "documentation"`. The task string MUST include:
      - Task ID
      - List of changed files (from task final-summary/notes)
      - Final summary text (from task final-summary)
      - Instruction to read the task, scan existing docs/decisions, update or create as needed, and emit `✅ DOCUMENTATION COMPLETE` via `backlog task edit <id> --append-notes`.
   b. After the subagent call, read the task notes to detect the signal:
      ```bash
      backlog task <id> --plain
      ```
   c. If `✅ DOCUMENTATION COMPLETE` found → mark the task Done:
      ```bash
      backlog task edit <id> -s Done
      ```
      Then proceed to the next task.
   d. If signal is absent or the agent failed → log a warning note and mark Done anyway (documentation is non-blocking for delivery).
5. Update the pipeline description in the **Step 5: End-of-Milestone Decision** section header or preamble to read:
   > Pipeline order: Implementation → QA → Security → Documentation → Done
6. In the **Sub-Agent Delegation** "Available sub-agents" list at the bottom of the file, add:
   - **documentation** — Reads completed task outcome and persists significant decisions and patterns to backlog/docs or backlog/decisions. Emits `✅ DOCUMENTATION COMPLETE` via task notes.
7. Update **Constraint #6** (currently "DON'T mark task Done after QA approval alone — DO also route through Security") to read:
   > DON'T mark task Done after Security approval alone — DO also route through Documentation and wait for `✅ DOCUMENTATION COMPLETE` signal.
8. Verify the full pipeline flow reads consistently: Implementation → QA → Security → Documentation → Done across all sections of the file.
<!-- SECTION:PLAN:END -->
