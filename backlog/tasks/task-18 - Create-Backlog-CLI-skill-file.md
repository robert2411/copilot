---
id: TASK-18
title: Create Backlog CLI skill file
status: To Do
assignee: []
created_date: '2026-04-16 20:59'
updated_date: '2026-04-16 21:48'
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
- [ ] #1 Skill directory structure created with proper assets
- [ ] #2 Comprehensive system prompt written covering CLI usage
- [ ] #3 Reference materials embedded or linked
- [ ] #4 Skill SKILL.md file with frontmatter and content completed
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

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
