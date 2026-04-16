---
id: TASK-18
title: Create Backlog CLI skill file
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:52'
labels:
  - skill
  - implementation
milestone: Backlog CLI Skill
dependencies:
  - TASK-11
  - TASK-12
  - TASK-13
  - TASK-14
  - TASK-15
  - TASK-16
  - TASK-17
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Scaffold and implement the complete Backlog CLI skill for GitHub Copilot using make-skill-template
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Skill directory structure created with proper assets
- [x] #2 Comprehensive system prompt written covering CLI usage
- [x] #3 Reference materials embedded or linked
- [x] #4 Skill SKILL.md file with frontmatter and content completed
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read docs 7-17 (all Backlog CLI reference docs in backlog/docs/) to extract key commands, patterns, and workflows
2. Review make-skill-template SKILL.md at .github/skills/make-skill-template/SKILL.md for exact format requirements
3. Create skill directory: .github/skills/backlog-cli/ with SKILL.md
4. Write frontmatter: name=backlog-cli, keyword-rich description covering all trigger phrases (task management, backlog, kanban, AC, DoD, MCP)
5. Write skill body sections:
   - When to Use
   - Prerequisites (backlog CLI installed, config.yml present)
   - Core Workflows (task lifecycle, AC/DoD, search, board)
   - Multi-shell input patterns for newlines
   - MCP integration patterns
   - Troubleshooting table
6. Add references/ subdirectory with symlinks or summaries pointing to docs 7-14
7. Validate SKILL.md: name matches folder, description 10-1024 chars, body under 500 lines
8. git commit
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Analysis complete. No blockers. Deps (tasks 11-17) are docs already in backlog/docs/ — implementation agent reads those to distil skill content. make-skill-template format confirmed.

❌ QA REJECTED: AC/DoD incomplete.
- Missing: DoD #1 (All code is committed to git)

🔍 QA REVIEW FINDINGS:
- Issue #1: Medium Broken local reference link: `./references/USAGE.md` is listed but file does not exist; `references/` directory is empty (`.github/skills/backlog-cli/SKILL.md:334`, `.github/skills/backlog-cli/references/`).

Verdict: Fix required before approval.

✅ QA APPROVED: Re-review complete; prior findings resolved.
- AC/DoD: All checked (including DoD #1 committed; verified commit 8fb75356b561441dbe6ea189e2456071e206362a).
- make-skill-template validation: `name` matches folder (`backlog-cli`), description is keyword-rich and within length bounds, SKILL body is under 500 lines.
- References: All files in `SKILL.md` References section exist, including `./references/USAGE.md`.
- Reviewed files: `.github/skills/backlog-cli/SKILL.md`, `.github/skills/backlog-cli/references/USAGE.md`.
- Security/quality/spelling: No issues identified.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
