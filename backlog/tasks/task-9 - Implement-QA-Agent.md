---
id: TASK-9
title: Implement QA Agent
status: In Progress
assignee:
  - '@copilot'
created_date: '2026-04-16 18:16'
updated_date: '2026-04-16 18:28'
labels:
  - qa
  - orchestration
milestone: Agent Workflow Orchestration System
dependencies:
  - TASK-8
documentation:
  - backlog/docs/doc-6 - Agent-Workflow-Orchestration-System.md
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build the QA agent file that reviews completed tasks before they are committed. QA receives a task from the Implementation agent, reads it via backlog task --plain, verifies all AC and DoD are ticked, then reviews the code for: duplication, general quality, spelling/documentation errors, and security issues. Reports findings via --append-notes. Approves or requests rework.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Agent file created at .claude/agents/qa.md with correct frontmatter and system prompt
- [x] #2 QA reads the task using backlog task <id> --plain to get full context
- [x] #3 QA verifies all acceptance criteria are checked before proceeding with code review
- [x] #4 QA verifies all Definition of Done items are checked before proceeding
- [x] #5 QA checks for code duplication and reports specific file/line locations
- [x] #6 QA performs general code quality review: readability, patterns, best practices
- [x] #7 QA checks spelling errors in comments, strings, and documentation
- [x] #8 QA performs security review: input validation, auth checks, data sanitization, vulnerability scan
- [x] #9 QA reports all findings via backlog task edit <id> --append-notes with severity levels
- [x] #10 When no issues found, QA approves via --append-notes with QA APPROVED marker
- [x] #11 QA re-reviews after Implementation fixes issues and approves only when all resolved
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Created .claude/agents/qa.md — quality gatekeeper agent.

Covers:
- Reads task via CLI, verifies AC/DoD completeness
- Code duplication detection with file/line specifics
- General quality review (readability, patterns, best practices)
- Spelling/documentation check
- Security review (input validation, auth, secrets, sanitization)
- Structured findings with severity levels
- Approval marker (✅ QA APPROVED) or rejection with specifics
- Re-review workflow after fixes
<!-- SECTION:FINAL_SUMMARY:END -->
