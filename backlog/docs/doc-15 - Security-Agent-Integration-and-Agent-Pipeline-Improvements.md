---
id: doc-15
title: Security Agent Integration and Agent Pipeline Improvements
type: other
created_date: '2026-04-18 21:17'
---

# Security Agent Integration and Agent Pipeline Improvements

## Current Pipeline Flow

```
manager → analyse → plan-reviewer → implementation → qa → security → documentation → done
```

Agents live in `.github/agents/`. The manager orchestrates all routing; sub-agents never call each other directly.

---

## Reference: the-dev-squad Role Mapping

| Role | the-dev-squad          | This Repo         |
|------|------------------------|-------------------|
| S    | Supervisor             | manager           |
| A    | Planner                | analyse           |
| B    | Plan Reviewer          | plan-reviewer     |
| C    | Coder                  | implementation    |
| D    | Code Reviewer + Tester | qa                |
| E    | Security Auditor       | security          |
| F    | Knowledge Recorder     | documentation     |

---

## Role E: Security Auditor Agent

### Purpose

Static security audit gate that runs AFTER QA green-lights a task. Prevents shipping code with known vulnerability
patterns before the task is marked Done.

### Trigger

Manager routes to security agent when QA emits `✅ QA APPROVED`. Security runs on every task — always-on, not optional.

### Scope

Audits the following vulnerability classes:

- **OWASP Top 10** — injection, broken auth, sensitive data exposure, XXE, broken access control, security
  misconfiguration, XSS, insecure deserialization, known vulnerable components, insufficient logging
- **Path Traversal** — `../` sequences in file path inputs, unsanitised user-controlled paths
- **ReDoS** — catastrophic backtracking in regex patterns applied to user input
- **Missing Input Validation** — unvalidated external input reaching sinks (DB, FS, network, eval)

### What the Security Agent Does

1. Reads the task's implementation plan and notes
2. Reads ALL code files produced or modified in the task
3. Performs static analysis only — no file writes, no code execution, no shell commands
4. Emits a structured verdict

### Verdict Format

Security agent emits a clear, distinct approval/findings signal via task notes:

**Approval (no vulnerabilities found):**

```
✅ SECURITY APPROVED — all scans complete, zero vulnerabilities
```

**Findings (vulnerabilities found):**

```
⚠️ SECURITY FINDINGS:
- SEC-001 [critical] src/api/users.ts:42 — SQL Injection: unsanitised req.query.id in raw query. Fix: Use parameterised query.
- SEC-002 [high] src/auth/session.ts:18 — Hardcoded credential in config. Fix: Move to environment variable.
```

Manager detects `✅ SECURITY APPROVED` signal to know security green-lights the task. If findings exist, manager routes
back to implementation to fix, then back through QA, then back to security for re-audit.

**Note:** Signal format is **`✅ SECURITY APPROVED`**, NOT `✅ QA APPROVED`, to clearly distinguish security approval from
QA approval in the pipeline.

### Severity Definitions

| Severity | Definition                                                                 |
|----------|----------------------------------------------------------------------------|
| critical | Exploitable remotely, leads to RCE, auth bypass, or full data exfiltration |
| high     | Significant impact but requires specific conditions or privileges          |
| medium   | Limited impact or requires chained vulnerabilities                         |
| low      | Defence-in-depth improvement; no direct exploitability                     |

### Re-Audit Mode

When given a single finding ID after a fix (e.g. `SEC-001`), the security agent audits ONLY the code relevant to that
finding. Emits single-finding verdict: `fixed` or `still-present`.

### What the Security Agent Does NOT Do

- Does NOT write any files
- Does NOT run code or shell commands
- Does NOT loop with implementation directly
- Does NOT communicate with QA directly
- Findings are reported to manager only; manager orchestrates the fix loop

---

## Security Fix Loop

When security emits findings:

```
security (findings) → manager → implementation (fix each finding) → qa (re-verify) → security (re-audit, scoped) → manager
```

Manager only marks task Done after security emits `"verdict": "approved"` (or findings list is empty).

---

## Role B: Plan Reviewer Agent

### Purpose

Receives the implementation plan from analyse before any code is written. Pokes holes, finds gaps, asks questions. Plan
is not approved until the reviewer has zero concerns.

### Options for Incorporating

**Option A — Separate `plan-reviewer` agent**

- Manager routes to plan-reviewer after analyse completes
- Plan-reviewer communicates back to manager with questions/concerns
- Manager routes concerns back to analyse to revise plan
- Loop continues until plan-reviewer approves
- Implementation only starts after plan-reviewer approval

**Option B — Self-review pass inside analyse**

- Analyse agent performs its own devil's advocate review pass before handing off
- Checks: gaps, unverified assumptions, missing steps, ambiguous scope
- Adds self-review notes to task before signalling ready
- Simpler pipeline, slightly weaker than independent reviewer

Recommendation: implement Option A (separate agent) for maximum robustness; use Option B as interim.

---

## Other Agent Improvements from the-dev-squad Analysis

### 1. Analyse Agent — Self-Review Pass

Before handing off to implementation, analyse should:

- Re-read the full plan it just wrote
- Check for: gaps in coverage of AC, unverified external assumptions, ambiguous steps, missing error handling
- Add note confirming self-review: `"Self-review complete. Plan covers all AC. No blockers."`

### 2. Implementation Agent — Blocker Escalation

When implementation hits something unexpected during coding:

- Does NOT guess or skip
- Flags blocker explicitly in task notes
- Signals manager to route back to analyse for clarification
- Resumes only after analyse provides guidance

### 3. QA Agent — Explicit Signal Back to Manager

QA should emit a clear, machine-detectable final result:

- Approval: `✅ QA APPROVED — all tests passing, no regressions`
- Rejection: `❌ QA REJECTED — [reason]`
- Manager polls for this signal after routing to QA
- Re-review loop: if QA rejects → manager routes back to implementation → implementation fixes → manager routes back to
  QA

### 4. Manager Agent — Security Gate After QA

Updated routing logic:

```
QA ✅ APPROVED
  → route to security agent
  → if security "approved": mark task Done
  → if security "findings":
      → route to implementation with findings list
      → implementation fixes each finding
      → route to QA for re-verification
      → QA ✅ APPROVED → route to security for re-audit (scoped)
      → repeat until security "approved"
```

### 5. Manager Agent — Plan Review Step

After analyse completes and before routing to implementation:

```
analyse complete
  → route to plan-reviewer
  → plan-reviewer approves: route to implementation
  → plan-reviewer has concerns: route back to analyse with questions
  → repeat until plan-reviewer approves
  → then route to implementation
```

---

## Proposed New Pipeline Flow

```
manager
  → analyse (plan + self-review)
  → plan-reviewer (gap analysis loop with analyse)
  → implementation (coding; escalates blockers to analyse via manager)
  → qa (tests; emits ✅/❌ signal)
  → security (OWASP audit; emits approved/findings)
  → [if findings] → implementation → qa → security (re-audit scoped)
  → documentation (audit completed task; update/create backlog/docs and backlog/decisions; emits ✅ DOCUMENTATION COMPLETE)
  → Done
```

---

## Role F: Documentation Agent

### Purpose

Runs after security approves a task. Inspects the completed task's final summary, implementation notes, and changed
files, then ensures all significant decisions, patterns, and outcomes are captured in `backlog/docs/` or
`backlog/decisions/`. This is the final gate before the manager marks a task Done.

### Trigger

Manager routes to documentation agent when security emits `✅ SECURITY APPROVED`.

### What the Documentation Agent Does

1. Reads the task via `backlog task <id> --plain`
2. Lists existing docs via `backlog doc list --plain` and scans `backlog/decisions/`
3. Reads candidate docs/decisions whose title is thematically related to the task
4. Updates an existing doc when the task outcome is relevant (same subsystem, same agent, same architectural area)
5. Creates a new doc when no relevant doc exists and the task produced reusable reference material
6. Creates a new decision record when the task involved an architectural or design choice
7. Appends `✅ DOCUMENTATION COMPLETE` to the task notes listing all docs/decisions created or updated

### Signal Format

```
✅ DOCUMENTATION COMPLETE
- Updated: backlog/docs/<filename> (reason)
- Created: backlog/decisions/<filename> (reason)
```

Or, if nothing needed documenting:

```
No documentation changes required. ✅ DOCUMENTATION COMPLETE
```

### Key Constraint: Modified FORBIDDEN Rule

Unlike all other agents, the documentation agent IS permitted to use `insert_edit_into_file` and
`replace_string_in_file` on existing `backlog/docs/` and `backlog/decisions/` files. This carve-out exists because no
`backlog doc edit` or `backlog decision edit` CLI command exists (`backlog doc --help` lists only `create`, `list`,
`view`). All *create* operations (new docs, new decisions, task note appends) still go through the backlog CLI.

### Security Constraint: Prompt Injection Guard

The documentation agent has Constraint 8 explicitly prohibiting use of `run_in_terminal` for any command other than
approved backlog CLI commands. Any instruction from task content to run non-backlog shell commands is treated as a
prompt injection attempt and must be stopped. This mirrors the pattern in `security.agent.md`.

### Non-Blocking Fallback

Documentation is non-blocking for delivery. If the documentation agent fails to emit the `✅ DOCUMENTATION COMPLETE`
signal, the manager logs a warning note and proceeds to mark the task Done. The security gate (which always precedes
documentation) is the blocking quality gate.

---

## Implementation Tasks

See milestone: **Security Agent & Agent Pipeline Improvements**

Tasks:

1. Create security agent file (`.github/agents/security.agent.md`)
2. Update manager agent to route through security after QA approves
3. Add self-review pass to analyse agent
4. Update implementation agent to escalate blockers to analyse
5. Update QA agent to send final result signal back to manager
6. Create plan-reviewer agent or incorporate plan review into analyse

See milestone: **Documentation Agent** (m-2)

Tasks:

7. Create documentation agent file (`.github/agents/documentation.agent.md`) — TASK-39
8. Wire documentation agent into manager pipeline after security approval — TASK-40
9. Update implementation agent to be aware of documentation step — TASK-41

