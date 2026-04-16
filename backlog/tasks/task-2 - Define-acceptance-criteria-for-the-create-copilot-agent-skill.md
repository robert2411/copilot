---
id: TASK-2
title: Define acceptance criteria for the create-copilot-agent skill
status: Done
assignee:
  - '@copilot'
created_date: '2026-04-16 07:23'
updated_date: '2026-04-16 07:32'
labels:
  - agents
  - skill
  - documentation
milestone: Copilot Agent Creation Skill
dependencies:
  - TASK-1
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Based on the agent anatomy research from task-1, define the scope, input/output contract, and quality checklist for the create-copilot-agent skill. This spec drives the implementation in the next task.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Skill responsibilities clearly defined (what it does and does not do)
- [x] #2 Input contract specified: what the user must provide (purpose, tools, sub-agents, MCP servers)
- [x] #3 Output contract specified: what the skill produces (agent .md file structure)
- [x] #4 Quality checklist for generated agents defined
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Skill Spec: create-copilot-agent

### Responsibilities
DOES:
- Gather requirements for a new Copilot custom agent from the user
- Author a complete, valid .claude/agents/<name>.md file
- Include frontmatter (name, description, color) and a thorough system prompt
- Embed tool-call best practices, sub-agent patterns, and MCP patterns where applicable

DOES NOT:
- Configure IDE settings for sub-agents (user must do that manually)
- Create .mcp.json files (out of scope)
- Create AGENTS.md (out of scope)

### Input Contract
The user must provide (skill will prompt/ask if missing):
1. **Agent purpose**: What problem does this agent solve?
2. **Required tools**: Which built-in tools does the agent need? (read_file, run_in_terminal, etc.)
3. **Sub-agents**: Does it delegate to any named sub-agents? Names + descriptions.
4. **MCP servers**: Does it use any MCP tools? Server names + tool names.
5. **Output format**: What should the agent produce? (file, report, code, etc.)
6. **Constraints**: What must the agent never do?

### Output Contract
A single `.claude/agents/<kebab-name>.md` file containing:
- YAML frontmatter: name, description (with usage examples), color
- System prompt with sections: Role, Gather Requirements, Output Format, Tool Usage, Constraints
- All sub-agent declarations in AGENTS.md `<subagent-instructions>` block (provided as a code block the user can paste)

### Quality Checklist
- [ ] Frontmatter valid: name, description, color present
- [ ] name matches intended agentName exactly (case-sensitive)
- [ ] description includes when-to-use trigger phrases
- [ ] System prompt opens with clear persona
- [ ] System prompt lists all required information to gather
- [ ] System prompt specifies exact output format
- [ ] System prompt includes tool-call best practices from doc-2
- [ ] System prompt includes sub-agent patterns from doc-3 if applicable
- [ ] System prompt includes MCP patterns from doc-3 if applicable
- [ ] File is self-contained — no external references needed to use it
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Defined full skill spec: responsibilities (what skill does/doesn't do), input contract (6 required inputs), output contract (.claude/agents/<name>.md with frontmatter + structured system prompt + AGENTS.md snippet), and quality checklist (10 items). Spec captured in task notes.
<!-- SECTION:FINAL_SUMMARY:END -->
