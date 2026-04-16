---
id: doc-1
title: GitHub Copilot Custom Agents — Overview & Getting Started
type: other
created_date: '2026-04-15'
---

# GitHub Copilot Custom Agents — Overview & Getting Started

## What Are Custom Agents?

GitHub Copilot supports **agent mode** — an autonomous loop where the model plans, calls tools, observes results, and iterates until a task is complete. Custom agents extend this with:

- **Per-project identity & behaviour** via `AGENTS.md`
- **Reusable prompt templates** via `.github/prompts/*.prompt.md`
- **Scoped coding instructions** via `.github/instructions/*.instructions.md`
- **Custom tooling** via MCP servers (`.mcp.json`)
- **Sub-agent delegation** via the `run_subagent` tool + AGENTS.md declarations

---

## Agent Mode vs Chat Mode

| | Chat Mode | Agent Mode |
|---|---|---|
| Autonomy | Single response | Multi-step autonomous loop |
| Tool access | None by default | Full tool suite |
| File edits | Suggests only | Writes directly |
| Terminal | No | Yes (foreground + background) |
| MCP servers | Varies by client | Yes |
| Sub-agents | No | Yes |

Switch to agent mode in JetBrains via the Copilot chat panel → mode selector → **Agent**.

---

## Project-Level Agent Identity: `AGENTS.md`

Place `AGENTS.md` at the workspace root. Copilot reads it at session start.

### Sections

#### 1. Coding Instructions

Free-form markdown. Describe project conventions, tech stack, style rules.

```markdown
## Project: Payments API
Stack: Node 22, Fastify, PostgreSQL, TypeScript strict.
Always use `zod` for runtime validation.
No `any` types. Prefer `unknown` + type guards.
```

#### 2. Sub-Agent Declarations

Tells the model which named agents are available to delegate to.

```markdown
<subagent-instructions>
You should ALWAYS use the `run_subagent` tool to delegate tasks to specialized agents.
Available Agents:
- **Plan**: Researches and outlines multi-step plans
- **Review**: Performs code review and suggests improvements
- **Test**: Generates and runs test suites
IMPORTANT: The `agentName` parameter MUST be one of the exact agent names listed above.
</subagent-instructions>
```

#### 3. MCP Guidelines (Optional)

If the project uses Backlog.md or other MCP servers, document critical instructions here so every session loads them.

```markdown
<CRITICAL_INSTRUCTION>
This project uses the Backlog.md MCP server for all task and project tracking.
MANDATORY: Before any complex work call backlog.task_search for existing tasks.
Never edit files in backlog/ directly — always go through MCP tools.
</CRITICAL_INSTRUCTION>
```

---

## Instruction Files: `.github/instructions/*.instructions.md`

Scoped instruction files Copilot applies automatically based on glob patterns.

### Format

```markdown
---
applyTo: "**/*.ts"
---
# TypeScript Instructions
Always use `satisfies` operator for object literals conforming to an interface.
Prefer `const` assertions for readonly tuple/object literals.
```

### `applyTo` glob examples

| Pattern | Scope |
|---|---|
| `**/*.ts` | All TypeScript files |
| `src/api/**` | API layer only |
| `**/*.test.ts` | Test files only |
| `**` | All files (global) |

Multiple instruction files can match simultaneously — Copilot merges them.

---

## Prompt Files: `.github/prompts/*.prompt.md`

Reusable, parameterised prompt templates. Invoke from chat with `/` or reference in agent workflows.

### Format

```markdown
---
mode: agent
description: "Generate a CRUD module for a given entity"
---
Generate a complete CRUD module for the `${entity}` domain model.

Include:
- Zod schema in `src/schemas/${entity}.schema.ts`
- Repository in `src/repositories/${entity}.repo.ts`
- Service in `src/services/${entity}.service.ts`
- Route handler in `src/routes/${entity}.routes.ts`
- Tests for each layer
```

### Frontmatter fields

| Field | Values | Description |
|---|---|---|
| `mode` | `ask`, `edit`, `agent` | Which Copilot mode runs this prompt |
| `description` | string | Shows in the prompt picker |
| `tools` | array | Restrict which tools are available |

---

## Recommended Directory Layout

```
project-root/
├── AGENTS.md                           # Agent identity, sub-agent declarations
├── .mcp.json                           # Project MCP server definitions
├── .github/
│   ├── copilot-instructions.md         # Legacy global instructions (still supported)
│   ├── instructions/
│   │   ├── global.instructions.md      # applyTo: "**"
│   │   ├── typescript.instructions.md  # applyTo: "**/*.ts"
│   │   └── tests.instructions.md       # applyTo: "**/*.test.*"
│   └── prompts/
│       ├── new-feature.prompt.md
│       ├── code-review.prompt.md
│       └── generate-crud.prompt.md
```

---

## System Prompt Injection Order

When Copilot builds the context for an agent turn it assembles:

1. Model system prompt (built-in Copilot instructions)
2. `AGENTS.md` content
3. Matched `.github/instructions/*.instructions.md` files (for active file)
4. Any prompt file being executed
5. Conversation history + tool results

Instructions closer to the top have higher precedence in case of conflict.

---

## JetBrains-Specific Notes

- Agent mode is set per-workspace in `.idea/workspace.xml` → `CopilotUserSelectedChatMode`
- Instruction and prompt file locations declared in `.idea/workspace.xml` → `github-copilot-workspace`
- MCP servers added project-wide (`.mcp.json`) or via IDE Settings → Copilot → MCP
- The IDE's Copilot plugin re-reads `AGENTS.md` on each new conversation

---

## See Also

- `doc-2` — Built-in Tool Calls Reference
- `doc-3` — Sub-Agents & MCP Servers

