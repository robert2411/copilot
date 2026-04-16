---
id: doc-5
title: create-copilot-agent Skill — Usage Guide
type: other
created_date: '2026-04-16'
---

# `create-copilot-agent` Skill — Usage Guide

This guide explains how to use the `create-copilot-agent` agent to scaffold new Copilot
custom agent files.

---

## What Is It?

`create-copilot-agent` is a Claude Code sub-agent (`.claude/agents/create-copilot-agent.md`)
that generates complete, production-quality Copilot custom agent files. Given a description of
what you want an agent to do, it handles all the boilerplate — frontmatter, system prompt
structure, tool usage guidance, sub-agent declarations, and MCP config snippets.

---

## When to Use It

Use `create-copilot-agent` when you want to:

- Create a new specialised agent for a project (e.g. a code-reviewer, migration helper, test generator)
- Scaffold a sub-agent that will be delegated to from a primary agent
- Author an agent file that follows all Copilot agent anatomy best practices without writing it manually

**Trigger phrases that invoke this skill:**

- "create a code-reviewer agent"
- "scaffold a migration agent for this project"
- "build me a documentation agent"
- "I need an agent that reviews PRs"
- "create a copilot agent that generates tests"

---

## Required Inputs

The skill will ask for the following if not provided upfront. Providing them all at once
produces the fastest result.

| Input | Description | Example |
|---|---|---|
| **Agent purpose** | What problem does the agent solve? | "Review code for security issues and style violations" |
| **Agent name** | Preferred name (kebab-case or Title Case) | `code-reviewer` or `Review` |
| **Required tools** | Built-in tools the agent needs | `read_file`, `semantic_search`, `show_content` |
| **Sub-agents** | Named agents to delegate to (if any) | `Plan` — outlines implementation plans |
| **MCP servers** | MCP tools used (if any) | `backlog` — for task tracking |
| **Output format** | What should the agent produce? | A Markdown review report rendered with `show_content` |
| **Constraints** | Hard limits on what the agent must never do | Never edit files, never run terminal commands |

---

## Expected Output

The skill produces:

1. **Agent file** written to `.claude/agents/<name>.md` with:
   - Valid YAML frontmatter (`name`, `description` with trigger examples, `color`)
   - System prompt with sections: Role & Scope, Requirements Gathering, Tool Usage, Output Format, Constraints

2. **`AGENTS.md` snippet** (if the agent uses sub-agents) — a `<subagent-instructions>` block
   to paste into your `AGENTS.md`

3. **`.mcp.json` snippet** (if the agent uses MCP tools) — the server config to add

4. **IDE setup reminder** if sub-agents require system prompt configuration in JetBrains/VS Code

---

## Worked Example

**User invocation:**

> Create a code-reviewer agent. It should review files for bugs, security issues, and style
> problems. It only needs read_file, semantic_search, grep_search, list_dir, and show_content.
> It should never edit files. Output a structured Markdown report.

**Skill produces** `.claude/agents/code-reviewer.md`:

```yaml
---
name: code-reviewer
description: |
  Performs thorough code review on files or diffs, identifying issues by severity.
  Use this agent when: "review this file", "code review src/", "review my changes".
color: "#D4380D"
---
```

System prompt includes:
- Persona: "You are a senior software engineer and code reviewer…"
- Scope: reviews files, rates issues by severity (critical/high/medium/low), never edits
- Requirements gathering: target files, language, review focus, severity threshold
- Tool usage: `read_file`, `grep_search`, `semantic_search`, `list_dir`, `show_content`
- Built-in tool best practices (absolute paths, no parallel semantic_search, etc.)
- Output: structured Markdown report with severity sections, rendered via `show_content`
- Constraints: no file edits, no terminal commands, always cite file:line

**No sub-agents or MCP → no AGENTS.md snippet or .mcp.json snippet needed.**

---

## Tips

- **Name consistency**: The `name` in frontmatter must exactly match the `agentName` you use in
  `run_subagent` calls — case-sensitive. Agree on the name before the skill writes the file.
- **One agent per invocation**: The skill completes one agent fully before moving to the next.
  If you need multiple agents, run the skill once per agent.
- **IDE sub-agent config**: If your agent uses sub-agents, remember to configure their system
  prompts in the IDE — the `.claude/agents/` file only declares availability.
  - **JetBrains**: Settings → GitHub Copilot → Customization → Custom Agents
  - **VS Code**: `.vscode/settings.json` → `"github.copilot.agents"` object
- **Anatomy checklist**: After generation, the skill self-verifies against the checklist in
  `doc-4 §5`. If something looks wrong, cite the checklist item and ask the skill to fix it.

---

## File Location

```
.claude/agents/create-copilot-agent.md   ← the skill itself
.claude/agents/<generated-name>.md       ← agents it produces
```

---

## See Also

- `doc-1` — GitHub Copilot Custom Agents Overview & Getting Started
- `doc-2` — Built-in Tool Calls Reference
- `doc-3` — Sub-Agents & MCP Servers
- `doc-4` — Copilot Agent Anatomy Research Summary (anatomy checklist in §5)
