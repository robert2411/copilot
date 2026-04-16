---
id: doc-2
title: "GitHub Copilot Custom Agents — Built-in Tool Calls Reference"
type: other
created_date: '2026-04-15'
---

# GitHub Copilot Custom Agents — Built-in Tool Calls Reference

Built-in tools are available to the agent automatically in agent mode — no MCP server needed. The model decides when to call them; shape usage via `AGENTS.md` instructions.

---

## Tool Index

| Tool | Category | Blocking |
|---|---|---|
| `read_file` | File system | Yes |
| `create_file` | File system | Yes |
| `insert_edit_into_file` | File system | Yes |
| `replace_string_in_file` | File system | Yes |
| `list_dir` | File system | Yes |
| `open_file` | IDE | Yes |
| `show_content` | IDE | Yes |
| `run_in_terminal` | Shell | Yes / No |
| `get_terminal_output` | Shell | Yes |
| `semantic_search` | Search | Yes |
| `grep_search` | Search | Yes |
| `file_search` | Search | Yes |
| `get_errors` | Analysis | Yes |
| `validate_cves` | Security | Yes |
| `run_subagent` | Agent | Yes |

---

## File System Tools

### `read_file`

Read file contents with optional line range.

**Parameters**

| Param | Type | Required | Description |
|---|---|---|---|
| `filePath` | string | ✅ | Absolute path |
| `offset` | number | ❌ | 1-based start line |
| `limit` | number | ❌ | Max lines to read |

**Rules**
- Always use absolute paths
- Use `offset` + `limit` for large files (> ~500 lines) to avoid token waste
- Read in meaningful chunks — full functions, classes, modules

---

### `create_file`

Create a new file. Fails if the file already exists.

**Parameters**

| Param | Type | Required | Description |
|---|---|---|---|
| `filePath` | string | ✅ | Absolute path |
| `content` | string | ✅ | Full file content |

**Rules**
- Only for new files — use `insert_edit_into_file` or `replace_string_in_file` for existing files
- Include all necessary imports in content

---

### `insert_edit_into_file`

Make targeted edits to an existing file. Provide minimal diff hints; the tool applies them intelligently.

**Parameters**

| Param | Type | Required | Description |
|---|---|---|---|
| `filePath` | string | ✅ | Absolute path |
| `explanation` | string | ✅ | Short description of change |
| `code` | string | ✅ | Edit with `// ...existing code...` placeholders |

**Format — always use comment placeholders for unchanged regions:**

```typescript
// ...existing code...
export class UserService {
  // ...existing code...
  async findById(id: string): Promise<User | null> {
    return this.repo.findOne({ where: { id } });
  }
  // ...existing code...
}
```

**Rules**
- Read the file first if not already in context
- Group all changes to one file into a single call
- Prefer `replace_string_in_file` for simple, locatable string swaps
- After editing, call `get_errors` on the file to validate

---

### `replace_string_in_file`

Replace an exact string occurrence in a file.

**Parameters**

| Param | Type | Required | Description |
|---|---|---|---|
| `filePath` | string | ✅ | Absolute path |
| `explanation` | string | ✅ | Short description |
| `oldString` | string | ✅ | Text to replace (must be unique in file) |
| `newString` | string | ✅ | Replacement text |

**Rules**
- Include 3–5 lines of surrounding context in `oldString` to guarantee uniqueness
- Match whitespace and indentation exactly
- One replacement per call
- Fall back to `insert_edit_into_file` if string isn't uniquely locatable

---

### `list_dir`

List immediate children of a directory.

| Param | Type | Required | Description |
|---|---|---|---|
| `path` | string | ✅ | Absolute directory path |

Output: entries ending with `/` are folders.

---

## IDE Tools

### `open_file`

Open a file in the IDE editor. Use only when the user explicitly asks.

| Param | Type | Required | Description |
|---|---|---|---|
| `filePath` | string | ✅ | Absolute path |
| `isPreview` | boolean | ❌ | Open in preview tab |

---

### `show_content`

Render formatted content (Markdown, HTML, plain text) to the user. Use only when explicitly requested.

| Param | Type | Required | Description |
|---|---|---|---|
| `name` | string | ✅ | Filename with extension (e.g. `result.md`) |
| `content` | string | ✅ | Content string to render |

---

## Shell Tools

### `run_in_terminal`

Execute a shell command. Supports foreground (blocking) and background (non-blocking) modes.

| Param | Type | Required | Description |
|---|---|---|---|
| `command` | string | ✅ | Shell command (zsh on macOS) |
| `explanation` | string | ✅ | One-sentence description shown to user |
| `isBackground` | boolean | ✅ | `false` = block + return output; `true` = fire + return ID |

**Foreground (`isBackground: false`)**
- Blocks until complete, returns full stdout/stderr
- Use for builds, tests, installs, one-off scripts

**Background (`isBackground: true`)**
- Returns a terminal `id` immediately
- Use for long-running servers, watch processes
- Retrieve output later via `get_terminal_output`

**Rules**
- Never run multiple `run_in_terminal` calls in parallel — wait for each to finish
- Pipe pager commands to `cat`: `git log | cat`, `man ls | cat`
- Quote variables: `"$var"` not `$var`
- Never print credentials to terminal
- For Python use `python -u` to prevent buffered output

---

### `get_terminal_output`

Fetch buffered output from a background terminal process.

| Param | Type | Required | Description |
|---|---|---|---|
| `id` | string | ✅ | Terminal ID from `run_in_terminal` — copy exactly |

---

## Search Tools

### `semantic_search`

Find code by meaning using embedding-based search. Primary exploration tool for unfamiliar codebases.

| Param | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Space-separated keywords |
| `maxResults` | number | ❌ | Default 16, max 128 |

**Rules**
- Use for "how/where/what" questions about the codebase
- Keywords should be code-likely: exact symbol names, error types, library names
- Avoid generic words: "return", "function", "code", "method"
- Start broad, then narrow based on results
- Do NOT call in parallel with other `semantic_search` calls

```
// Good
semantic_search("UserRepository findById PostgreSQL")

// Bad
semantic_search("function that returns user")
```

---

### `grep_search`

Exact text or regex search across files.

| Param | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Plain text or regex pattern |
| `isRegexp` | boolean | ❌ | Enable regex mode |
| `includePattern` | string | ❌ | Glob to filter files (e.g. `*.ts`) |

**Rules**
- Use for exact symbol names, import paths, string literals
- Prefer over `semantic_search` when you know the exact text
- Combine with `includePattern` to scope results

---

### `file_search`

Find files by glob pattern, sorted by modification time.

| Param | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Glob pattern |
| `maxResults` | number | ❌ | Limit results |

---

## Analysis Tools

### `get_errors`

Get compile and lint errors for specific files. Call after every file edit.

| Param | Type | Required | Description |
|---|---|---|---|
| `filePaths` | string[] | ✅ | Absolute paths of files to check |

**Rules**
- Only call on files you've just edited — not a broad project scan
- Fix relevant errors; do not loop more than 3 times on the same file
- Errors shown are identical to what the user sees in the IDE

---

### `validate_cves`

Check dependencies for known CVEs.

| Param | Type | Required | Description |
|---|---|---|---|
| `dependencies` | string[] | ✅ | `package@version` strings |
| `ecosystem` | string | ✅ | `npm`, `pip`, `maven`, `go`, `rust`, `nuget`, etc. |

Format: `"express@4.18.0"` or for Maven `"org.springframework:spring-core@5.3.20"`.

Returns CVE details and minimum version resolving all known vulnerabilities.

---

## Tool Priority Decision Tree

```
Need to find something?
├── Know exact text/symbol  →  grep_search
├── Know filename pattern   →  file_search
└── Know concept/meaning    →  semantic_search

Need to change a file?
├── New file                         →  create_file
├── Simple unique text swap          →  replace_string_in_file
└── Structural / multi-location edit →  insert_edit_into_file

Need to run a command?
├── Short, need output               →  run_in_terminal (isBackground: false)
└── Long-running process             →  run_in_terminal (isBackground: true)
                                           + get_terminal_output

After any file edit → get_errors
```

