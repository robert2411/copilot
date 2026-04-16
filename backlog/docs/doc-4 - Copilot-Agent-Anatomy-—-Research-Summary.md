---
id: doc-4
title: Copilot Agent Anatomy — Research Summary
type: other
created_date: '2026-04-16 07:30'
---

# Copilot Agent Anatomy — Research Summary

Source docs: doc-1 (Overview), doc-2 (Tool Calls), doc-3 (Sub-Agents & MCP).

---

## 1. Frontmatter Fields

Agent files (`.github/agents/*.agent.md` or `.claude/agents/*.md`) require YAML frontmatter:

| Field | Required | Purpose | Valid Values |
|---|---|---|---|
| `name` | ✅ | Identifier used in `agentName` param of `run_subagent`; case-sensitive | kebab-case string (e.g. `code-reviewer`) |
| `description` | ✅ | Shown in agent picker; drives skill routing. Must include "Use this agent when:" trigger phrases | Multi-line string |
| `color` | ✅ | UI accent colour in the agent picker | Hex string e.g. `"#0078D4"` |

**Rules:**
- `name` must match `agentName` in all `run_subagent` calls exactly (case-sensitive)
- `description` should include 2–3 concrete trigger phrases after "Use this agent when:"
- `color` is cosmetic only but must be present

---

## 2. System Prompt Best Practices

Structure system prompts with these sections (in order):

```markdown
# <Agent Name> — System Prompt

You are a <specific role/persona>. <One sentence on primary responsibility>.

---

## Role & Scope
<What the agent does AND does not do. Explicit scope limits.>

---

## Requirements Gathering
Before acting, ensure you have:
<Numbered list of all information the agent needs from the user>

---

## Tool Usage

### Built-in Tool Best Practices
- Always use absolute file paths with read_file, create_file, insert_edit_into_file, etc.
- Use replace_string_in_file for unique text swaps; insert_edit_into_file for structural edits.
- Never run multiple run_in_terminal calls in parallel — wait for each to finish.
- Pipe pager commands to cat: `git log | cat`.
- Call get_errors after every file edit to validate changes.
- For semantic_search: use specific symbol names, not generic words.
- Do NOT call semantic_search in parallel.

### Sub-Agent Delegation (if applicable)
<task string must be fully self-contained: file paths, constraints, current state, target state, expected output>

### MCP Tool Usage (if applicable)
<List MCP tools and when to use each. Use server-prefixed names: server-name.tool_name>

---

## Output
<Exact description of what the agent produces: file paths, formats, structure>

---

## Constraints
<Numbered list of hard constraints. Pair each DON'T with a DO alternative.>
```

Key principles:
- Open with a clear, specific persona (not "You are a helpful assistant")
- Explicitly state what the agent does NOT do (scope boundary)
- List every piece of information required before the agent can act
- Specify output format precisely — file paths, structure, rendering method

---

## 3. Sub-Agent Declaration Pattern

Sub-agents are declared in `AGENTS.md` via `<subagent-instructions>` block:

```markdown
<subagent-instructions>
You should ALWAYS use the `run_subagent` tool to delegate tasks to specialized agents
when the task matches the agent's description. Do NOT attempt tasks yourself when a
relevant agent exists.

Available Agents:
- **Plan**: Researches and outlines multi-step implementation plans
- **Review**: Code review — security, performance, correctness
- **Test**: Generates unit, integration, and e2e test suites

IMPORTANT: The `agentName` parameter MUST be one of the exact agent names listed above.
Do NOT use any other name.
</subagent-instructions>
```

`run_subagent` call pattern:
- `agentName`: must match AGENTS.md declaration exactly
- `task`: fully self-contained — include file paths, language/framework, current state, target state, constraints, expected output format
- Sub-agent has **no conversation history** — the task string is its entire context

Sub-agent system prompts are configured **in the IDE**, not in agent files:
- **JetBrains**: Settings → GitHub Copilot → Customization → Custom Agents
- **VS Code**: `.vscode/settings.json` → `"github.copilot.agents"` object

---

## 4. MCP Integration Pattern

MCP servers are declared in `.mcp.json` at the workspace root:

```json
{
  "servers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start"]
    }
  }
}
```

MCP tools are referenced with server-prefixed names: `backlog.task_create`, `backlog.task_list`.

Document MCP tool usage in `AGENTS.md`:

```markdown
## MCP Tools Available
This project has a `backlog` MCP server — ALWAYS use it for task management.
- Before complex work: backlog.task_search
- To track new work: backlog.task_create
- Never edit backlog/ files directly
```

---

## 5. Anatomy Checklist (use for task-4 verification)

- [ ] Frontmatter present: `name`, `description`, `color`
- [ ] `name` is kebab-case and case-consistent with intended `agentName` usage
- [ ] `description` includes "Use this agent when:" + trigger phrases
- [ ] System prompt opens with specific role/persona
- [ ] System prompt has explicit Role & Scope (including what agent does NOT do)
- [ ] System prompt lists all required information to gather
- [ ] System prompt specifies exact output format
- [ ] Built-in tool best practices included (absolute paths, no parallel terminal, get_errors after edits)
- [ ] Sub-agent patterns included if applicable (self-contained task strings)
- [ ] MCP patterns included if applicable (server-prefixed tool names)
- [ ] File is self-contained — usable without additional context

