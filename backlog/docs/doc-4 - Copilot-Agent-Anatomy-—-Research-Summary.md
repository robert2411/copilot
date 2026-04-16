---
id: doc-4
title: Copilot Agent Anatomy — Research Summary
type: other
created_date: '2026-04-16 07:30'
---

# Copilot Agent Anatomy — Research Summary

Ground truth synthesised from doc-1, doc-2, and doc-3 for all tasks in the Copilot Agent Creation Skill milestone.

---

## 1. Agent Identity: `AGENTS.md`

Placed at workspace root. Copilot reads it at session start. Three main sections:

### 1.1 Coding Instructions
Free-form markdown. Project conventions, tech stack, style rules. No special wrapper.

### 1.2 Sub-Agent Declarations
Wrapped in `<subagent-instructions>` tags. Declares available named sub-agents.

```markdown
<subagent-instructions>
You should ALWAYS use the `run_subagent` tool to delegate tasks to specialized agents
when the task matches the agent's description. Do NOT attempt tasks yourself when a
relevant agent exists.

Available Agents:
- **Plan**: Researches and outlines multi-step plans
- **Review**: Code review — security, performance, correctness

IMPORTANT: The `agentName` parameter MUST be one of the exact agent names listed above.
Do NOT use any other name.
</subagent-instructions>
```

### 1.3 MCP Guidelines (optional)
Documents which MCP tools are available and mandatory usage rules. Often wrapped in `<CRITICAL_INSTRUCTION>` tags.

---

## 2. Claude Code Agent File: `.claude/agents/*.md`

Custom agents for Claude Code use this format:

### 2.1 Frontmatter Fields

| Field | Purpose | Valid Values |
|---|---|---|
| `name` | Agent identifier — must match `agentName` in `run_subagent` calls (case-sensitive) | Any string; kebab-case or Title Case consistent with declaration |
| `description` | Shown in agent picker; include when-to-use examples so the model knows when to delegate | Free-form string with usage trigger examples |
| `color` | Visual accent in the UI | Hex colour e.g. `"#7B5EA7"` or named colour |

### 2.2 System Prompt Best Practices

- **Clear persona**: Open with "You are a…" role statement
- **Explicit output format**: Enumerate exactly what to produce
- **Constraints listed**: What the agent must NOT do
- **Worked examples**: Show ideal input → output where ambiguity is likely
- **Authoritative sources referenced**: Point to docs, files, patterns to follow
- **Self-contained**: Agent gets no external context beyond system prompt + `task` argument
- **Structured sections**: Headers help the model parse instructions
- **Pair negation with alternatives**: Each "don't" paired with a "do"

### 2.3 Sub-Agent Declaration Pattern

Sub-agents are **declared** in `AGENTS.md` via `<subagent-instructions>` block.

Sub-agent **behaviour** is configured in the IDE:
- **JetBrains**: Settings → GitHub Copilot → Customization → Custom Agents
- **VS Code**: `.vscode/settings.json` → `"github.copilot.agents"` object

Each entry: `name` (matches declaration), `systemPrompt`, optional `model`, optional `tools`.

For Claude Code, sub-agents live in `.claude/agents/<name>.md` — each file is a full agent spec.

### 2.4 MCP Integration Pattern

`.mcp.json` at workspace root:

```json
{
  "servers": {
    "server-name": {
      "command": "cli-command",
      "args": ["arg1", "arg2"]
    }
  }
}
```

- Tools prefixed by server name: `server-name.tool_name`
- Reference MCP tools in `AGENTS.md` to guide the model
- For remote servers: use `"url"` + `"type": "sse"` instead of `command`/`args`
- Mandatory usage rules go in `AGENTS.md` MCP Guidelines section

---

## 3. Instruction & Prompt Files

### `.github/instructions/*.instructions.md`
```yaml
---
applyTo: "**/*.ts"
---
Instructions applied to all .ts files.
```
Auto-applied by Copilot based on `applyTo` glob. Multiple files can match simultaneously.

### `.github/prompts/*.prompt.md`
```yaml
---
mode: agent   # ask | edit | agent
description: "What this prompt does"
tools: []     # optional restriction
---
Prompt body with ${variable} interpolation.
```

---

## 4. System Prompt Injection Order

1. Model built-in instructions
2. `AGENTS.md`
3. Matched `.github/instructions/` files (for active file)
4. Prompt file being executed
5. Conversation history + tool results

Earlier items take precedence on conflict.

---

## 5. Anatomy Checklist (use for task-4 verification)

- [ ] Frontmatter present with `name`, `description`, `color`
- [ ] `name` is consistent with sub-agent declaration (case-sensitive match)
- [ ] `description` explains when to invoke with usage examples
- [ ] System prompt opens with clear role/persona statement
- [ ] System prompt states what to gather from user
- [ ] System prompt states expected output format
- [ ] System prompt includes constraints/scope limits
- [ ] System prompt references source-of-truth docs/patterns
- [ ] File is self-contained (no external dependencies)
- [ ] Sub-agents (if any): declared correctly in `<subagent-instructions>` block
- [ ] MCP (if any): `.mcp.json` present and tools referenced in `AGENTS.md`
