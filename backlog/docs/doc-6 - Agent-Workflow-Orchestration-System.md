---
id: doc-6
title: Agent Workflow Orchestration System
type: other
created_date: '2026-04-16'
---

# Agent Workflow Orchestration System

## Overview

Multi-agent orchestration system for software project execution. Four specialized agents coordinate through a manager hub, handling planning, analysis, implementation, and quality assurance in cyclical workflow.

**Goal:** Automate project milestone completion with quality gates and structured handoffs.

All agents interact with the Backlog system exclusively through **CLI commands**. No direct file editing. All state managed via `backlog task edit`, `backlog task create`, etc.

---

## System Architecture

### Agents & Responsibilities

#### 1. **Manager Agent** (Orchestrator/Hub)
- **Role**: Workflow conductor and state keeper
- **Responsibilities**:
  - Scan backlog for next available milestone
  - Distribute milestones to Analyse agent
  - Route milestone to Implementation agent when Analyse complete
  - Monitor Implementation agent progress
  - Decide next actions (repeat cycle, create milestone grouping, completion)
  - Track overall project state

#### 2. **Analyse Agent** (Planning & Discovery)
- **Role**: Requirements analyst and blocker identifier
- **Responsibilities**:
  - Receive milestone from Manager
  - Study milestone description and acceptance criteria
  - Review all relevant backlog docs (references, design docs, decisions)
  - Create detailed implementation plan for each task in milestone
  - Identify blocking points, dependencies, risks
  - Flag missing information or clarifications needed
  - Hand off to Manager with green light or blockers

#### 3. **Implementation Agent** (Developer)
- **Role**: Code executor and test writer
- **Responsibilities**:
  - Receive milestone tasks from Manager
  - Mark each task as "In Progress" + assign to self
  - Implement functionality with unit tests
  - Maintain minimum 80% code coverage across milestone tasks
  - For each completed task:
    - Verify all acceptance criteria checked off
    - Verify Definition of Done reached
    - Hand to QA agent for review
    - Fix issues reported by QA
    - Commit changes with descriptive message
  - Request clarification from Analyse agent if needed
  - Report completion to Manager

#### 4. **QA Agent** (Quality Gatekeeper)
- **Role**: Quality assurance and code review
- **Responsibilities**:
  - Receive completed task from Implementation agent
  - Verify implementation matches acceptance criteria
  - Run code review checks:
    - Code duplication detection
    - General code quality review
    - Spelling/documentation errors
    - Security vulnerabilities
  - Report findings to Implementation agent
  - Approve or flag for rework

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AGENT ORCHESTRATION LOOP                            │
└─────────────────────────────────────────────────────────────────────────────┘

                                   START
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │  MANAGER AGENT       │
                         │  Read Backlog        │
                         └──────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
            ┌───────▼────────┐      │      ┌────────▼─────────┐
            │ Milestones     │      │      │ No Milestones    │
            │ Available?     │      │      │ Tasks Available? │
            │ YES            │      │      │ YES              │
            └────────────────┘      │      └──────────────────┘
                    │               │               │
                    │               │        ┌──────▼──────────────┐
                    │               │        │ ANALYSE AGENT       │
                    │               │        │ Group tasks into    │
                    │               │        │ logical milestones  │
                    │               │        └────────┬───────────┘
                    │               │                 │
                    │               │        ┌────────▼──────────────┐
                    │               │        │ Hand to Manager       │
                    │               └───────►│ Loop continues        │
                    │                        └──────────────────────┘
                    │
                    ▼
        ┌───────────────────────────┐
        │   ANALYSE AGENT           │
        │   - Study milestone       │
        │   - Review docs/refs      │
        │   - Plan per task         │
        │   - Identify blockers     │
        └────────────┬──────────────┘
                     │
        ┌────────────▼──────────────┐
        │  Blockers or Issues?      │
        │  - YES: Flag & Report     │
        │  - NO: Clear to implement │
        └────────────┬──────────────┘
                     │
                     ▼
        ┌─────────────────────────────┐
        │   MANAGER AGENT             │
        │   Route to Implementation   │
        └────────────┬────────────────┘
                     │
        ┌────────────▼──────────────────────┐
        │  IMPLEMENTATION AGENT START        │
        │  For each task in milestone:       │
        │  1. Mark "In Progress" + assign    │
        │  2. Implement with unit tests      │
        │  3. Maintain 80%+ coverage        │
        └────────────┬─────────────────────┘
                     │
        ┌────────────▼──────────────────────┐
        │  TASK COMPLETION GATE              │
        │  Per Task:                         │
        │  □ All AC checked off?             │
        │  □ DoD criteria met?               │
        │  □ Code coverage OK?               │
        └────────────┬─────────────────────┘
                     │
        ┌────────────▼────────────────────────┐
        │   PASS QA CHECK?                    │
        │   YES → Hand to QA AGENT            │
        │   NO → Request clarification        │
        └────────────┬────────────────────────┘
                     │
        ┌────────────▼──────────────────────┐
        │   QA AGENT REVIEW                  │
        │   - Verify implementation          │
        │   - Code duplication check         │
        │   - General code review            │
        │   - Spelling/docs check            │
        │   - Security audit                 │
        └────────────┬─────────────────────┘
                     │
        ┌────────────▼────────────────────────┐
        │   Issues Found?                     │
        │   - YES: Return to Implementation   │
        │   - NO: Approve                     │
        └────────────┬────────────────────────┘
                     │
        ┌────────────▼──────────────────────┐
        │  IMPLEMENTATION AGENT              │
        │  □ Fix QA issues (if any)          │
        │  □ Commit changes                  │
        │  □ Move to next task               │
        └────────────┬─────────────────────┘
                     │
        ┌────────────▼────────────────────────┐
        │   More tasks in milestone?          │
        │   - YES: Loop to next task          │
        │   - NO: Completion check            │
        └────────────┬────────────────────────┘
                     │
        ┌────────────▼─────────────────────────┐
        │  IMPLEMENTATION AGENT               │
        │  □ Verify 80% coverage across tasks │
        │  □ Report completion to Manager     │
        │  □ Flag any missing info needed     │
        └────────────┬──────────────────────────┘
                     │
        ┌────────────▼────────────────────────┐
        │   MANAGER AGENT                     │
        │   Decision Point:                   │
        │   - More milestones?                │
        │   - Unstarted tasks?                │
        │   - Project complete?               │
        └────────────┬────────────────────────┘
                     │
    ┌────────────────┼────────────────┐
    │                │                │
    ▼                ▼                ▼
 [MORE WORK]   [GROUP TASKS]    [COMPLETE]
    │                │              │
    └───────┬────────┘              │
            │                       │
            └───────────┬───────────┘
                        │
                        ▼
                  Loop to START
                  or
                  EXIT
```

---

## Detailed Workflow Phases

### Phase 1: Milestone Assignment

**Manager → Analyse Agent**

#### Manager: Identify Next Milestone

```bash
# Manager scans for available milestones (lists all non-Done milestones)
backlog task list -s "To Do" --plain

# Or search for milestone-tagged tasks
backlog search "milestone" --type task --plain

# View specific milestone for details
backlog task <id> --plain

# Example output shows:
#  - milestone-X with tasks [task-1, task-2, task-3]
#  - milestone-Y with tasks [task-4, task-5]
```

#### Manager: Notify Analyse Agent

```bash
# Manager creates a note/context by reading the milestone details
# Then communicates (out-of-band) with Analyse agent:
# "Analysing milestone-X with tasks: task-1, task-2, task-3"

# Manager may add references to tasks so Analyse can track them
backlog task edit <id> -a @analyse-agent  # Assign to Analyse (optional, for tracking)
backlog task edit <id> --notes "Ready for analysis"
```

#### Analyse Agent: Study Milestone & Tasks

```bash
# Analyse agent reads each task in milestone
backlog task 1 --plain
backlog task 2 --plain
backlog task 3 --plain

# Review all acceptance criteria, references, documentation
# Output includes:
#  - Description (the why)
#  - Acceptance Criteria (the what)
#  - Any references (--ref) or documentation (--doc)

# Read referenced docs/decisions
backlog docs  # Browse available docs
cat backlog/docs/doc-N.md  # Read specific doc

cat backlog/decisions/decision-M.md  # Read architectural decisions

# Search for related content
backlog search "topic" --plain
```

#### Analyse Agent: Create Implementation Plans

```bash
# For each task, Analyse agent creates a detailed implementation plan
# Format: Break down AC into implementation steps, identify dependencies

# Add plan to task-1 (ANSI-C quoting for multiline)
backlog task edit 1 --plan $'1. Review existing auth module\n2. Implement JWT validation\n3. Add error handling\n4. Write integration tests'

# Add plan to task-2
backlog task edit 2 --plan $'1. Design database schema\n2. Create migrations\n3. Add validation layer\n4. Document API'

# Add plan to task-3
backlog task edit 3 --plan $'1. Implement caching strategy\n2. Add TTL management\n3. Performance tests\n4. Document cache behavior'

# Append notes if blockers found
backlog task edit 1 --append-notes $'⚠️ BLOCKER: Third-party auth service documentation incomplete.\nRequires clarification on token refresh strategy.'

# Flag critical issues
backlog task edit 2 --append-notes $'⚠️ BLOCKER: Database schema conflicts with existing model.\nNeeds architect review before proceeding.'
```

#### Analyse Agent: Report to Manager

```bash
# Mark analysis complete and communicate status
# Update all tasks with completion notes
backlog task edit 1 --append-notes "Analysis complete. Plan ready. No blockers found."
backlog task edit 2 --append-notes "Analysis complete. Plan ready. BLOCKER: Schema needs review."
backlog task edit 3 --append-notes "Analysis complete. Plan ready. No blockers found."

# Add summary to milestone (via adding notes to first task or via search)
# If blocker: append-notes with blocker summary
# If ready: append-notes "Ready for implementation"
```

---

### Phase 2: Implementation Kickoff

**Manager → Implementation Agent**

#### Manager: Route to Implementation Agent

```bash
# Manager checks if milestone is clear of blockers
# (by reading task notes from Analyse agent)

backlog task 1 --plain  # Check for blocker flags
backlog task 2 --plain
backlog task 3 --plain

# If no blockers, Manager assigns milestone to Implementation agent
# For each task in milestone:
backlog task edit 1 -a @implementation-agent
backlog task edit 2 -a @implementation-agent
backlog task edit 3 -a @implementation-agent

# Manager communicates: "Milestone-X ready for implementation. Tasks: 1, 2, 3"
```

#### Implementation Agent: Start Task

```bash
# Implementation agent gets task assigned by Manager
# For each task, Implementation agent immediately:

# 1. Mark task as In Progress and assign to self
backlog task edit 1 -s "In Progress" -a @myself

# 2. Read task details and implementation plan
backlog task 1 --plain

# Output shows:
#  - Description (what needs to be done)
#  - Acceptance Criteria (verification checklist)
#  - Definition of Done (quality checklist)
#  - Implementation Plan (from Analyse agent)
#  - References and docs

# 3. Implement feature per the plan
# (Write code, follow acceptance criteria)

# 4. Write unit tests (target 80%+ coverage)
# (Run: npm test, coverage report, etc.)

# 5. Append progress notes during implementation
backlog task edit 1 --append-notes $'- Implemented JWT validation module\n- Added unit tests for token parsing\n- Coverage: 85%\n- Ready for QA'
```

#### Implementation Agent: Pre-QA Verification

```bash
# Before handing to QA, verify task readiness:

# 1. Check acceptance criteria are all marked done
backlog task 1 --plain

# View AC section - if any unchecked, mark them as complete:
backlog task edit 1 --check-ac 1 --check-ac 2 --check-ac 3

# 2. Check Definition of Done
# View DoD section - mark items as complete:
backlog task edit 1 --check-dod 1 --check-dod 2

# 3. Append final implementation notes
backlog task edit 1 --append-notes "All AC ticked. All DoD met. Code coverage: 87%. Ready for QA."

# 4. Hand to QA Agent
# (Out-of-band: "Task 1 ready for QA review")
```

---

### Phase 3: QA Review

**Implementation Agent → QA Agent → Implementation Agent**

#### QA Agent: Receive Task

```bash
# QA agent receives task from Implementation agent
# Reads task for review:

backlog task 1 --plain

# Checks:
#  □ Implementation notes confirm readiness?
#  □ AC all checked?
#  □ DoD all checked?
#  □ Code coverage adequate (80%+)?
```

#### QA Agent: Conduct Review

```bash
# QA agent performs checks (external to CLI):
#  1. Code duplication scan
#  2. General code quality review
#  3. Spelling/documentation check
#  4. Security vulnerability scan
#  5. Compare implementation vs AC

# If issues found, append QA report:
backlog task edit 1 --append-notes $'🔍 QA REVIEW FINDINGS:\n- Issue #1: Code duplication in auth.ts (lines 45-67)\n- Issue #2: Missing error handling for null tokens\n- Issue #3: Typo in error message: "authentification"\n- Severity: Medium - Fix required before approval'

# If approved:
backlog task edit 1 --append-notes $'✅ QA APPROVED: All checks passed. No issues found.'
```

#### Implementation Agent: Fix QA Issues (if any)

```bash
# If QA found issues, Implementation agent fixes them:

# 1. Re-read task to see QA findings
backlog task 1 --plain

# 2. Implement fixes for reported issues
# (Code changes, test updates, etc.)

# 3. Re-run coverage check
# Append updated notes
backlog task edit 1 --append-notes $'- Fixed code duplication in auth.ts\n- Added null token error handling\n- Fixed typo: authentification → authentication\n- New coverage: 88%\n- Resubmitting to QA'

# 4. Hand back to QA Agent for re-review
# If QA approves, continue to completion
```

#### Implementation Agent: Commit Task

```bash
# When QA approves (or if no issues):

# 1. Add final summary (PR-style description)
backlog task edit 1 --final-summary $'Implemented JWT authentication validation.\n\nChanges:\n- Added JWT token parser and validator\n- Integrated with auth middleware\n- Added comprehensive error handling\n\nTests:\n- Unit tests for token validation (85% coverage)\n- Integration tests for auth flow\n- Edge cases: expired tokens, invalid signatures\n\nImpact:\n- Secures API endpoints\n- Improves security posture\n- No breaking changes'

# 2. Commit code to repository
git add src/auth.ts src/tests/auth.test.ts
git commit -m "task-1: Implement JWT authentication validation"
# Or however your team structures commits

# 3. Move task to Done
backlog task edit 1 -s Done

# 4. Continue to next task in milestone
# Repeat Phase 2-3 for task-2, task-3, etc.
```

---

### Phase 4: Completion & Next Milestone

**Implementation Agent → Manager**

#### Implementation Agent: Report All Tasks Complete

```bash
# After all tasks in milestone are Done:

# 1. Verify all tasks marked as Done
backlog task list -s Done --plain | grep -E "task-1|task-2|task-3"

# 2. Collect final coverage report across all tasks
# (Run test suite for milestone, capture coverage output)

# 3. Append summary notes to each task
backlog task edit 1 --append-notes "✅ Milestone complete. Coverage: 85%"
backlog task edit 2 --append-notes "✅ Milestone complete. Coverage: 84%"
backlog task edit 3 --append-notes "✅ Milestone complete. Coverage: 86%"

# 4. Flag any missing information for Manager/Analyse
# Example: if clarifications were needed during implementation
backlog task edit 1 --append-notes $'⚠️ CLARIFICATION NEEDED from Analyse:\n- Token expiry strategy still unclear\n- Revisit design doc when available'

# 5. Report completion to Manager
# (Out-of-band: "Milestone-X complete. All tasks done. Coverage: 85% average")
```

#### Manager: Decide Next Action

```bash
# Manager evaluates project status:

# 1. Check for more available milestones
backlog task list -s "To Do" --plain

# If milestones found:
#    → Loop back to Phase 1: Assign to Analyse agent
#    → Example: backlog task edit 4 -a @analyse-agent

# 2. If no milestones but unstarted tasks exist
backlog task list -s "To Do" --plain

# If tasks found without milestone:
#    → Ask Analyse agent to group into logical milestone
#    → Out-of-band: "Group tasks X, Y, Z into a milestone"
#    → Analyse creates new milestone structure
#    → Loop back to Phase 1

# 3. If no milestones and no tasks
# Project complete!
backlog task list --plain  # Verify all Done

# Optional: Create final project report
backlog board  # View completion status
backlog search "*" --plain  # View all tasks

# Exit orchestration loop
```

---

## CLI Command Reference by Agent

### Manager Agent Commands

```bash
# SCAN BACKLOG
backlog task list -s "To Do" --plain
backlog search "milestone" --type task --plain
backlog task <id> --plain

# ASSIGN TASKS
backlog task edit <id> -a @analyse-agent
backlog task edit <id> -a @implementation-agent
backlog task edit <id> --notes "Ready for [phase]"

# VERIFY STATUS
backlog task list -s "In Progress" --plain
backlog task list -s "Done" --plain
backlog board  # Visual Kanban board
```

### Analyse Agent Commands

```bash
# READ TASKS & DOCS
backlog task <id> --plain
backlog task list -s "To Do" --plain
backlog search "topic" --plain
cat backlog/docs/doc-N.md
cat backlog/decisions/decision-M.md

# CREATE PLANS
backlog task edit <id> --plan $'1. Step one\n2. Step two\n3. Step three'

# FLAG BLOCKERS
backlog task edit <id> --append-notes $'⚠️ BLOCKER: Description\nDetails of blocking issue'

# REPORT STATUS
backlog task edit <id> --append-notes "Analysis complete. Plan ready. No blockers."
```

### Implementation Agent Commands

```bash
# START TASK
backlog task edit <id> -s "In Progress" -a @myself
backlog task <id> --plain

# IMPLEMENT & TEST
# (Write code, run tests locally)

# LOG PROGRESS
backlog task edit <id> --append-notes $'- Implemented feature\n- Added tests\n- Coverage: 85%'

# PRE-QA VERIFICATION
backlog task edit <id> --check-ac 1 --check-ac 2 --check-ac 3
backlog task edit <id> --check-dod 1 --check-dod 2
backlog task edit <id> --append-notes "All AC/DoD checked. Ready for QA."

# COMPLETE TASK
backlog task edit <id> --final-summary $'Implemented X feature.\n\nChanges:\n- File A\n- File B\n\nTests: 85% coverage'
backlog task edit <id> -s Done
git commit -m "task-<id>: Implementation complete"

# REQUEST CLARIFICATION (if needed)
backlog task edit <id> --append-notes "❓ Need clarification on X from Analyse agent"
```

### QA Agent Commands

```bash
# RECEIVE TASK
backlog task <id> --plain

# REVIEW & REPORT FINDINGS
backlog task edit <id> --append-notes $'🔍 QA FINDINGS:\n- Issue #1: Description\n- Issue #2: Description\n- Severity: Medium'

# APPROVE TASK
backlog task edit <id> --append-notes "✅ QA APPROVED: All checks passed."
```

---

## Common Workflow Scenarios

### Scenario 1: Smooth Flow (No Issues)

```bash
# Manager identifies milestone
backlog task 1 --plain
backlog task 2 --plain

# Manager assigns to Analyse
backlog task edit 1 -a @analyse-agent
backlog task edit 2 -a @analyse-agent

# Analyse adds plans
backlog task edit 1 --plan $'1. Design\n2. Implement\n3. Test'
backlog task edit 2 --plan $'1. Setup\n2. Deploy'

# Analyse signals ready
backlog task edit 1 --append-notes "Ready for implementation"

# Manager assigns to Implementation
backlog task edit 1 -a @implementation-agent
backlog task edit 2 -a @implementation-agent

# Implementation marks In Progress
backlog task edit 1 -s "In Progress"
backlog task edit 2 -s "In Progress"

# Implementation completes and marks Done
backlog task edit 1 --check-ac 1 --check-ac 2
backlog task edit 1 --check-dod 1 --check-dod 2
backlog task edit 1 --final-summary "Feature complete"
backlog task edit 1 -s Done

# Same for task 2...

# Manager identifies next milestone or completes
backlog task list -s "To Do" --plain
```

### Scenario 2: Blocker During Analysis

```bash
# Analyse identifies issue
backlog task edit 1 --append-notes $'⚠️ BLOCKER: Third-party API not documented'

# Manager reviews blocker
backlog task 1 --plain

# Manager decides: defer or reassign
backlog task edit 1 -s "Blocked"  # Or reassign to different milestone

# Continue with other tasks
backlog task edit 2 -a @implementation-agent
```

### Scenario 3: QA Finds Issues

```bash
# Implementation marks ready
backlog task edit 1 --append-notes "Ready for QA"

# QA reviews and finds issues
backlog task edit 1 --append-notes $'❌ QA ISSUES:\n- Code duplication in auth.ts\n- Missing error handler'

# Implementation fixes and resubmits
backlog task edit 1 --append-notes $'- Fixed duplication\n- Added error handler\n- Resubmitting to QA'

# QA re-reviews and approves
backlog task edit 1 --append-notes "✅ QA APPROVED"

# Implementation completes
backlog task edit 1 --final-summary "Feature complete with QA fixes"
backlog task edit 1 -s Done
```

### Scenario 4: Missing Info During Implementation

```bash
# Implementation hits ambiguity
backlog task edit 1 --append-notes "❓ Unclear: Should we cache results?"

# Analyse investigates and responds
backlog task edit 1 --append-notes "✓ Design doc says: Yes, cache with 1-hour TTL"

# Implementation continues
backlog task edit 1 --append-notes "- Implemented caching with 1-hour TTL"
```

---

## Task State Transitions

```
To Do
  │
  ├─ [Manager assigns to Implementation]
  │
  ▼
In Progress
  │
  ├─ [Implementation completes, hands to QA]
  │
  ├─ [QA finds issues]
  ├─ [Implementation fixes, re-hands to QA]
  │
  ├─ [QA approves]
  │
  ├─ [Implementation adds final summary & commits]
  │
  ▼
Done
```

---

## Handoff Protocols

### Format: Manager → Analyse

```yaml
milestone_id: milestone-X
milestone_title: "Feature Set Alpha"
tasks:
  - task-1
  - task-2
  - task-3
context:
  - See backlog/docs/doc-N for design
  - See backlog/decisions/decision-M for architecture choice
request: "Create implementation plan and identify blockers"
```

### Format: Analyse → Manager

```yaml
milestone_id: milestone-X
status: "ready" | "blocked"
implementation_plans:
  task-1: "Plan details"
  task-2: "Plan details"
blockers:
  - "Third-party API not documented"
  - "Design decision pending in doc-7"
ready_to_implement: true | false
questions:
  - "Should we use X or Y for persistence?"
```

### Format: Implementation → Manager

```yaml
milestone_id: milestone-X
status: "complete"
tasks_completed: 3
test_coverage: 82%
all_ac_ticked: true
all_dod_met: true
commits:
  - "sha: abc123, msg: Implemented feature X"
  - "sha: def456, msg: Added tests for Y"
next_action: "Ready for next milestone"
clarifications_needed:
  - "Need guidance on error handling strategy"
```

---

## Error Handling & Edge Cases

### Blocker Encountered During Analysis

```
Analyse Agent identifies blocker
  │
  ├─ Report to Manager with details
  ├─ Manager may:
    │ ├─ Request clarification from stakeholder
    │ ├─ Suggest workaround
    │ ├─ Defer milestone to later
    │ └─ Reassign tasks to different milestone
```

### QA Finds Critical Issues

```
QA reports critical issues (security, data loss risk, etc.)
  │
  ├─ Implementation Agent must fix before moving forward
  ├─ If fix requires design change: escalate to Analyse
  ├─ If architectural change needed: report to Manager
  └─ Loop until QA approves
```

### Missing Information During Implementation

```
Implementation Agent hits ambiguity
  │
  ├─ Request from Analyse Agent
  ├─ Analyse may:
    │ ├─ Clarify from original task description
    │ ├─ Check design docs
    │ ├─ Request stakeholder input
    │ └─ Update task with clarification
  │
  └─ Implementation continues
```

### Coverage Below 80%

```
Test coverage falls below 80%
  │
  ├─ Implementation Agent must add tests
  ├─ Can be before or after QA (preference: before)
  ├─ Re-run coverage report
  └─ Cannot commit until 80%+ reached
```

---

## Key Integration Points

### With Backlog System

- **Task Management**: All operations via `backlog task edit` CLI
- **Metadata**: Status, assignee, AC checks, DoD checks managed by agents
- **Documentation**: Agents read from `backlog/docs/`, `backlog/decisions/`
- **References**: Tasks may have `--ref` and `--doc` fields agents must review

### With Code Repository

- **Commits**: Implementation agent commits with structured messages
- **Branch Strategy**: Milestone-based or task-based branches (configurable)
- **Test Execution**: Coverage reports generated before task completion

### With External Services

- **Security Scanning**: QA agent may integrate with security tools
- **Code Analysis**: Duplication detection, linting, type checking
- **Deployment**: Manager may integrate with CD system for milestone releases

---

## Success Criteria

### Per Agent

**Manager**:
- ✅ Correctly identifies available milestones
- ✅ Routes work to appropriate agent at right time
- ✅ Handles edge cases (no milestones, blocking tasks)

**Analyse**:
- ✅ Creates detailed, actionable plans
- ✅ Identifies all blocking points before implementation
- ✅ Provides implementation plan in structured format

**Implementation**:
- ✅ Implements all AC without deviation
- ✅ Achieves 80%+ test coverage per milestone
- ✅ Fixes all QA issues before task completion
- ✅ Commits with clear, traceable messages

**QA**:
- ✅ Catches code quality issues
- ✅ Verifies security requirements
- ✅ Provides actionable feedback for fixes

### Overall System

- ✅ Milestone completes without rework (>90% first-pass QA approval)
- ✅ Average cycle time known and optimized
- ✅ Test coverage maintained across project
- ✅ No critical issues reaching production

---

## Configuration & Customization

### Adjustable Parameters

```yaml
implementation:
  test_coverage_target: 80  # Percentage
  critical_path_coverage: 100
  max_issues_before_escalation: 5
  commit_message_format: "task-X: description"

qa:
  auto_approve_if_no_issues: true
  require_security_scan: true
  require_duplication_check: true
  spelling_check_scope: "all"  # "comments", "docs", "all"

manager:
  auto_create_milestones_from_tasks: false
  milestone_batch_size: 5  # Tasks per milestone if auto-creating
  recheck_coverage_before_milestone_close: true
```

---

## Monitoring & Reporting

### Per Milestone

- Start → End timeline
- Tasks completed
- Average issues found by QA
- Coverage metrics
- Commit count
- Time per phase

### Per Agent

- Tasks processed
- First-pass approval rate
- Average cycle time
- Issues escalated

### Project Level

- Milestones completed
- Total coverage
- Critical issues (zero target)
- Time to production

---

## Implementation Roadmap

This document describes the system at maturity. Implementation phases:

1. **Phase 1**: Manager + Analyse agents (planning)
2. **Phase 2**: Add Implementation agent (basic flow)
3. **Phase 3**: Add QA agent with manual handoff
4. **Phase 4**: Automated handoff & decision making
5. **Phase 5**: Advanced features (escalation, re-routing)
6. **Phase 6**: Reporting & optimization

Each phase builds on previous, maintaining stable interfaces between agents.

---

## Related Documentation

- **AGENTS.md**: Agent system overview
- **GitHub Copilot Custom Agents Overview**: Base concepts
- **Tool Calls Reference**: Technical implementation details
- **Sub-Agents and MCP Servers**: Multi-agent coordination patterns






