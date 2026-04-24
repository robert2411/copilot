---
id: TASK-35
title: Create agent file validation test suite
status: To Do
assignee: []
created_date: '2026-04-24 21:48'
updated_date: '2026-04-24 21:50'
labels:
  - testing
  - agents
milestone: Agent Validation Tests
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Build a shunit2 bash test suite under tests/agents/ that discovers every .github/agents/*.agent.md file and validates it is a well-formed Copilot agent. Covers frontmatter schema, required fields, non-empty prompt body, and no raw secrets.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All .github/agents/*.agent.md files are discovered and tested
- [ ] #2 Each agent file is validated for required frontmatter fields: name, description, color, user-invocable
- [ ] #3 Each agent file is validated to have a non-empty prompt body (content after frontmatter)
- [ ] #4 Tests fail clearly when a field is missing or empty
- [ ] #5 Test runner script exits non-zero when any test fails
- [ ] #6 Tests use shunit2 consistent with existing test-milestone-helper.sh pattern
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Create tests/agents/test-agents.sh (does not exist yet; tests/agents/ directory already exists but is empty).
2. At the top of the file, establish SCRIPT_DIR, REPO_ROOT (../../..), and AGENTS_DIR="$REPO_ROOT/.github/agents" path variables (same pattern as test-milestone-helper.sh).
3. Add two pure-bash helper functions used by every test:
   a. get_frontmatter <file> — prints the lines between the first and second YAML "---" delimiters using awk: `awk "/^---$/{n++; next} n==1" "$file"`
   b. get_body <file> — prints all lines after the second "---" delimiter using: `awk "/^---$/{n++; next} n>=2" "$file"`
4. Add test_agents_are_discovered — verifies that at least one *.agent.md file exists under $AGENTS_DIR; fail with a descriptive message if none found (guards against misconfigured AGENTS_DIR) — covers AC#1.
5. Add test_agents_have_name_field — loops over every *.agent.md file; for each, calls get_frontmatter and pipes to grep -qE "^name: .+"; uses assertTrue with the filename in the message; covers AC#2 & AC#4.
6. Add test_agents_have_description_field — loops over every *.agent.md file; checks description key exists AND has non-empty content. Strategy:
   a. first grep for `^description:` to confirm the key exists.
   b. if the value is inline (`^description: [^|>]` matches), assert value is non-empty on that line.
   c. if the value is a block scalar (`^description: [|>]` matches), assert that at least one indented (two-space prefix) line follows within the frontmatter section.
   Uses assertTrue/assertFalse with filename in message; covers AC#2 & AC#4.
7. Add test_agents_have_color_field — loops over every *.agent.md file; pipes frontmatter to grep -qE "^color: .+"; assertTrue with filename; covers AC#2 & AC#4.
8. Add test_agents_have_user_invocable_field — loops over every *.agent.md file; pipes frontmatter to grep -qE "^user-invocable: (true|false)"; assertTrue with filename; validates field exists AND value is the valid boolean string; covers AC#2 & AC#4.
9. Add test_agents_have_non_empty_body — loops over every *.agent.md file; calls get_body, strips blank lines (grep -v "^[[:space:]]*$"), asserts the result is non-empty; assertTrue with filename; covers AC#3 & AC#4.
10. Add the standard 4-way shunit2 sourcing block at the bottom (identical fallback chain to test-milestone-helper.sh: env SHUNIT2, command -v shunit2, /usr/share/shunit2/shunit2, /usr/local/opt/shunit2/libexec/shunit2); covers AC#6.
11. Mark the script executable (chmod +x tests/agents/test-agents.sh) — the exit-code behaviour is inherited from shunit2 which exits non-zero when any test fails; covers AC#5.
12. No setUp/tearDown needed because all tests are read-only operations on static agent source files.
13. Note: the task description mentions "no raw secrets" but none of the ACs specify it — no secrets-scanning test is required to satisfy the ACs; if added later it should grep body+frontmatter for patterns like AWS key formats or high-entropy strings.
<!-- SECTION:PLAN:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
