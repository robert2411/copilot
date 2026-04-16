---
id: doc-3
title: "GitHub Copilot Custom Agents — Sub-Agents & MCP Servers"
type: other
created_date: '2026-04-15'
---

# GitHub Copilot Custom Agents — Sub-Agents & MCP Servers

---

## Part 1: Sub-Agents

Sub-agents are named, specialised agents the primary agent can delegate to via the `run_subagent` built-in tool. Each runs with its own system prompt, toolset, and model configuration.

### How Sub-Agents Work

```
User prompt
    │
    ▼
Primary Agent (reads AGENTS.md)
    │
    ├─ calls run_subagent("Plan", task="...")
    │       ▼
    │   Plan Agent (separate isolated context)
    │       │  researches, outlines plan
    │       └─ returns result string
    │
    └─ incorporates result, continues implementing
```

- Sub-agent gets its own isolated context window — no conversation history
- Primary agent provides a `task` string that must be fully self-contained
- Sub-agent returns a string; primary agent uses it to continue
- Sub-agents can themselves call tools (including further sub-agents if configured)

---

### `run_subagent` Tool

| Param | Type | Required | Description |
|---|---|---|---|
| `agentName` | string | ✅ | Exact name from AGENTS.md `<subagent-instructions>` |
| `task` | string | ✅ | Detailed, self-contained task description |

**Critical rules**
- `agentName` must match exactly — case-sensitive
- `task` must be fully self-contained: include file paths, code snippets, constraints
- Do NOT invent agent names — only use names declared in `AGENTS.md`

```typescript
// Correct
run_subagent({
  agentName: "Plan",
  task: `Outline a plan to migrate UserService from REST to gRPC.
         Current: src/services/user.service.ts — 12 endpoints.
         Target: zero-downtime migration.
         Output: phased plan with complexity per phase.`
})

// Wrong — name not declared in AGENTS.md
run_subagent({ agentName: "Architect", task: "..." })  // ❌
```

---

### Declaring Sub-Agents in `AGENTS.md`

The `<subagent-instructions>` block tells the primary agent which agents exist.

**Minimal example**

```markdown
<subagent-instructions>
You should ALWAYS use the `run_subagent` tool to delegate tasks to specialized agents
when the task matches the agent's description. Do NOT attempt tasks yourself when a
relevant agent exists.

Available Agents:
- **Plan**: Researches and outlines multi-step plans

IMPORTANT: The `agentName` parameter MUST be one of the exact agent names listed above.
Do NOT use any other name.
</subagent-instructions>
```

**Multi-agent example**

```markdown
<subagent-instructions>
Delegate to specialized agents. Available Agents:
- **Plan**:     Researches and outlines multi-step implementation plans
- **Review**:   Code review — security, performance, correctness
- **Test**:     Generates unit, integration, and e2e test suites
- **Migrate**:  DB schema migrations and data transformation scripts
- **Document**: API docs, README sections, inline JSDoc

IMPORTANT: `agentName` must be one of the exact names above.
</subagent-instructions>
```

---

### Configuring Sub-Agent System Prompts

Sub-agent behaviour is configured in the IDE, not in `AGENTS.md`.

**JetBrains**

Settings → GitHub Copilot → Customization → Custom Agents

Each entry has:
- **Name** — matches `agentName` in `run_subagent` calls
- **System Prompt** — full instructions for that agent
- **Model** — optional model override
- **Tools** — optional tool restriction

**VS Code**

`.vscode/settings.json`:

```json
{
  "github.copilot.agents": {
    "Plan": {
      "systemPrompt": "You are a senior software architect. Produce a structured implementation plan with phases, risks, and effort estimates.",
      "model": "gpt-4o"
    },
    "Review": {
      "systemPrompt": "You are a code reviewer. Identify issues, rate severity (critical/high/medium/low), suggest fixes.",
      "tools": ["read_file", "grep_search", "semantic_search"]
    }
  }
}
```

---

### Writing Good Sub-Agent Tasks

Sub-agents get no context outside the `task` string. Write as if briefing a new developer.

**Include:**
- Exact output format expected
- File paths of relevant code
- Language, framework, style constraints
- Current state vs target state
- Definition of done for the sub-task

**Bad:**
```
"Plan the auth refactor"
```

**Good:**
```
Research and outline a plan to refactor authentication in this Node/Fastify/TypeScript project.

Current: JWT validation duplicated in 8 route handlers. Search 'verifyJWT' in src/routes/.
Target: Centralised middleware at src/middleware/auth.ts used by all protected routes.

Constraints:
- TypeScript strict mode
- Must not break existing JWT token format
- Zero downtime — gradual rollout preferred
- Include rollback steps

Output: Numbered phases, each with: description, files affected, risk level, estimated hours.
```

---

## Part 2: MCP Servers

Model Context Protocol (MCP) is an open standard for giving agents structured access to external tools and data sources. Each MCP server exposes tools the agent calls exactly like built-in tools.

### Architecture

```
GitHub Copilot Agent
        │  (tool call)
        ▼
  MCP Client (built into IDE)
        │  stdio / SSE / HTTP
        ▼
  MCP Server process
        ├─ backlog.task_create(...)
        ├─ backlog.task_list(...)
        └─ backlog.document_create(...)
```

---

### Project-Level Config: `.mcp.json`

Place at workspace root — Copilot loads it automatically.

**stdio server (local process)**

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

**HTTP/SSE server (remote)**

```json
{
  "servers": {
    "my-remote-server": {
      "url": "http://localhost:3100/mcp",
      "type": "sse"
    }
  }
}
```

**Multiple servers**

```json
{
  "servers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "postgresql://localhost/mydb"
      }
    }
  }
}
```

---

### IDE-Level MCP Config

For global/user-level servers not tied to one project.

**JetBrains**

Settings → GitHub Copilot → MCP Servers → **+**

Or in `~/Library/Application Support/JetBrains/<IDE>/copilot-mcp.json`.

**VS Code**

User `settings.json`:

```json
{
  "github.copilot.mcp.servers": {
    "my-server": {
      "command": "node",
      "args": ["/absolute/path/to/server/index.js"]
    }
  }
}
```

---

### Building a Custom MCP Server

**Install SDK**

```bash
npm install @modelcontextprotocol/sdk
```

**Minimal stdio server (TypeScript)**

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  { name: "my-project-tools", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "get_feature_flags",
      description: "Fetch current feature flags from the config service",
      inputSchema: {
        type: "object",
        properties: {
          environment: {
            type: "string",
            enum: ["development", "staging", "production"],
          },
        },
        required: ["environment"],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  switch (name) {
    case "get_feature_flags": {
      const flags = await fetchFeatureFlags(args.environment as string);
      return { content: [{ type: "text", text: JSON.stringify(flags, null, 2) }] };
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

**Register in `.mcp.json`**

```json
{
  "servers": {
    "my-project-tools": {
      "command": "node",
      "args": ["./mcp-server/dist/index.js"]
    }
  }
}
```

---

### SSE Server Example

```typescript
import express from "express";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";

const app = express();
const transports = new Map<string, SSEServerTransport>();

app.get("/mcp", async (req, res) => {
  const transport = new SSEServerTransport("/mcp/message", res);
  transports.set(transport.sessionId, transport);
  await server.connect(transport);
});

app.post("/mcp/message", async (req, res) => {
  const transport = transports.get(req.query.sessionId as string);
  await transport?.handlePostMessage(req, res);
});

app.listen(3100);
```

Register:

```json
{
  "servers": {
    "my-remote-server": {
      "url": "http://localhost:3100/mcp",
      "type": "sse"
    }
  }
}
```

---

### MCP Tool Naming

When Copilot loads MCP servers, tools are prefixed by server name:

```
backlog.task_create
backlog.document_create
github.create_pull_request
my-project-tools.get_feature_flags
```

Reference in `AGENTS.md` to guide the agent:

```markdown
## MCP Tools Available
This project has a `backlog` MCP server — ALWAYS use it for task management.
- Before complex work: backlog.task_search
- To track new work: backlog.task_create
- Never edit backlog/ files directly
```

---

### MCP Server Types

| Type | Transport | Use case |
|---|---|---|
| stdio | stdin/stdout | Local CLI tools, scripts |
| SSE | HTTP Server-Sent Events | Remote/shared team servers |
| HTTP Streamable | HTTP POST + streaming | Modern remote servers |

---

### Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Tools not appearing | Server not starting | Verify `command` is in `$PATH`; run it manually |
| "Unknown tool" error | Name mismatch | Check server name in `.mcp.json` |
| Server crashes on start | Missing env vars | Check `env` block; verify values |
| Stale tools after code change | Server not restarted | Restart IDE or reload MCP in settings |
| Timeout on tool call | Slow operation | Add progress notifications; increase timeout |

