# Backlog CLI Skill — Usage Guide

Companion reference for the [`backlog-cli` skill](../SKILL.md). Covers installation, common patterns, troubleshooting, and contributing guidelines.

---

## Installation & Activation

### 1. Install the Backlog CLI

```bash
# npm
npm install -g backlog.md

# bun (faster)
bun install -g backlog.md

# Verify
backlog --version
```

### 2. Initialise a Project

Run once per project root:

```bash
cd /path/to/your/project
backlog init
```

This creates:
```
backlog/
├── config.yml        # Project settings, global DoD defaults
├── tasks/            # Task markdown files
├── docs/             # Documentation
└── decisions/        # Architecture decision records
```

### 3. Activate the Skill in GitHub Copilot

Place the skill directory in `.github/skills/` inside any repository:

```
.github/
└── skills/
    └── backlog-cli/
        ├── SKILL.md          ← required
        └── references/
            └── USAGE.md      ← this file
```

GitHub Copilot auto-discovers skills by scanning `.github/skills/*/SKILL.md`. No additional configuration needed. The skill activates when your prompt mentions task management, backlog, kanban, AC, DoD, MCP, or related keywords.

### 4. Configure Global Definition of Done

Edit `backlog/config.yml`:

```yaml
definition_of_done:
  - All tests pass
  - Documentation updated
  - Code reviewed
```

---

## Common Use Patterns

### Full Task Lifecycle

```bash
# 1. Create
backlog task create "Add login endpoint" \
  -d "Implement POST /auth/login with JWT response" \
  --ac "Returns 200 + JWT for valid credentials" \
  --ac "Returns 401 for invalid credentials" \
  -l backend,auth \
  --priority high

# 2. Start
backlog task edit <id> -s "In Progress" -a @me
backlog task edit <id> --plan $'1. Review auth module\n2. Implement handler\n3. Write tests'

# 3. Track
backlog task edit <id> --append-notes $'- Handler implemented\n- Tests: 12/12 pass'

# 4. Check off ACs
backlog task edit <id> --check-ac 1 --check-ac 2

# 5. Check DoD
backlog task edit <id> --check-dod 1 --check-dod 2

# 6. Wrap up
backlog task edit <id> --final-summary $'Implemented POST /auth/login.\n\nChanges:\n- src/auth/handler.ts\n- tests/auth.test.ts\n\nAll ACs verified, tests pass.'
backlog task edit <id> -s Done
```

### AC/DoD Workflows

```bash
# Add multiple ACs at creation
backlog task create "Feature" --ac "First" --ac "Second" --ac "Third"

# Check multiple at once (preferred)
backlog task edit <id> --check-ac 1 --check-ac 2 --check-ac 3

# Mixed operations in one command
backlog task edit <id> --check-ac 1 --uncheck-ac 2 --remove-ac 3 --ac "Replacement criterion"

# DoD — same pattern
backlog task edit <id> --dod "Tests pass" --dod "Docs updated"
backlog task edit <id> --check-dod 1 --check-dod 2
```

### Multi-Shell Newline Patterns

The CLI stores input literally — `"...\n..."` in normal quotes is **not** a newline.

| Shell | Pattern | Example |
|-------|---------|---------|
| Bash/Zsh | `$'...'` | `--notes $'Line 1\nLine 2'` |
| POSIX | `printf` | `--notes "$(printf 'Line 1\nLine 2')"` |
| PowerShell | backtick-n | `--notes "Line 1\`nLine 2"` |

```bash
# Bash/Zsh (recommended)
backlog task edit <id> --plan $'1. Research\n2. Implement\n3. Test'

# POSIX portable
backlog task edit <id> --notes "$(printf 'Done A\nDone B\nTODO C')"

# PowerShell
backlog task edit <id> --final-summary "Added X`nUpdated Y`nTests pass"
```

### Search and Board

```bash
# Fuzzy search (searches titles, descriptions, content)
backlog search "authentication" --plain

# Filter by type and status
backlog search "login" --type task --status "In Progress" --plain

# Filter by priority
backlog search "bug" --priority high --plain

# Kanban board in terminal
backlog board

# Kanban board in browser
backlog browser
```

### MCP Server Usage

```bash
# Start MCP server (stdio transport)
backlog mcp start

# Or use the shorthand
backlog mcp
```

**Claude Desktop config** (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "backlog": {
      "command": "backlog",
      "args": ["mcp", "start"],
      "cwd": "/absolute/path/to/your/project"
    }
  }
}
```

After restart, Claude can call `backlog_task_create`, `backlog_task_edit`, `backlog_task_view`, `backlog_task_list`, and `backlog_search` as MCP tools.

### AI Agent Workflow

```bash
# Agent claims task
backlog task edit <id> -s "In Progress" -a @agent-name

# Agent reads plan
backlog task <id> --plain

# Agent logs progress
backlog task edit <id> --append-notes $'- Completed X\n- Coverage: 87%'

# Agent marks done
backlog task edit <id> --check-ac 1 --check-ac 2
backlog task edit <id> --final-summary "Implemented X; all ACs verified"
backlog task edit <id> -s Done
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `backlog: command not found` | CLI not installed | `npm install -g backlog.md` |
| `No config found` | Not in project root | Run `backlog init` or `cd` to project root |
| Task not found by ID | Wrong ID or archived | `backlog task list --plain` to list active tasks |
| AC index out of range | Stale index reference | `backlog task <id> --plain` to see current AC indices |
| `\n` appearing as literal text | Wrong quote style | Use `$'...'` in bash/zsh or `printf` |
| Skill not auto-activating | Keywords not matching | Mention "backlog", "task", "kanban", "AC", or "DoD" explicitly |
| MCP tools not available | Server not configured | Add `backlog mcp start` to MCP client config with correct `cwd` |
| MCP wrong project | `cwd` misconfigured | Ensure `cwd` in MCP config points to folder with `backlog/config.yml` |
| Metadata out of sync | Direct file edit | Re-edit via CLI: `backlog task edit <id> -s <current-status>` |
| Board shows empty columns | All tasks in same status | Check `backlog task list --plain` for actual statuses |
| Search returns no results | Term too specific | Use shorter keywords; backlog uses fuzzy matching |

---

## Contributing — Updating the Skill

### When to Update SKILL.md

- New Backlog CLI commands released
- New agent workflow patterns discovered
- Additional troubleshooting entries needed
- New shell environments to support

### How to Update

1. Edit `.github/skills/backlog-cli/SKILL.md`
2. Validate with the checklist below
3. Update this `USAGE.md` if the change affects user-facing patterns
4. Commit: `git commit -m "skill(backlog-cli): <describe change>"`

### Validation Checklist

- [ ] `name:` in frontmatter still matches folder name (`backlog-cli`)
- [ ] `description:` is 10–1024 characters and wrapped in single quotes
- [ ] `description:` explains WHAT the skill does AND WHEN to use it (keywords present)
- [ ] Body is under 500 lines (`wc -l SKILL.md`)
- [ ] All code examples tested in bash/zsh
- [ ] Troubleshooting table updated for any new failure modes
- [ ] References section links are valid relative paths

### Adding New Sections

Follow the existing structure:

```markdown
## New Section Title

Brief intro sentence.

### Subsection

Content with code blocks for all examples.
```

### Linking to Documentation

Reference existing backlog docs relatively from the skill root:

```markdown
[Complete Reference](../../../backlog/docs/doc-7 - Backlog-CLI-Complete-Reference-Guide.md)
```

Or add new docs to `backlog/docs/` and reference from `SKILL.md`.

---

## Quick Reference Card

```bash
# Most used commands
backlog task create "Title" --ac "Criterion"    # Create
backlog task list --plain                        # List
backlog task <id> --plain                        # View
backlog task edit <id> -s "In Progress"          # Status
backlog task edit <id> --check-ac 1              # Check AC
backlog task edit <id> --append-notes $'...'     # Log progress
backlog task edit <id> --final-summary $'...'    # PR summary
backlog task edit <id> -s Done                   # Complete
backlog search "keyword" --plain                 # Search
backlog board                                    # Kanban
backlog mcp start                                # MCP server
```



