#!/usr/bin/env bash
# =============================================================================
# test-agents.sh — shunit2 tests for .github/agents/*.agent.md files
# =============================================================================
# HOW TO INSTALL shunit2:
#   macOS:          brew install shunit2
#   Debian/Ubuntu:  sudo apt-get install shunit2
#   Manual:         https://github.com/kward/shunit2
#                   Download shunit2 and place it somewhere on your PATH, or set
#                   SHUNIT2 env var to the full path of the shunit2 script.
#
# HOW TO RUN TESTS:
#   From the repo root:
#     bash tests/agents/test-agents.sh
#
#   With a custom shunit2 path:
#     SHUNIT2=/path/to/shunit2 bash tests/agents/test-agents.sh
#
# WHAT IS TESTED:
#   - All .github/agents/*.agent.md files are discovered
#   - Each agent file has required frontmatter fields: name, description, color, user-invocable
#   - Each agent file has a non-empty prompt body (content after frontmatter)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AGENTS_DIR="$REPO_ROOT/.github/agents"

# ---------------------------------------------------------------------------
# Helper: get_frontmatter <file>
# Prints lines between the first and second "---" delimiters.
# ---------------------------------------------------------------------------
get_frontmatter() {
  awk '/^---$/{n++; next} n==1' "$1"
}

# ---------------------------------------------------------------------------
# Helper: get_body <file>
# Prints all lines after the second "---" delimiter.
# ---------------------------------------------------------------------------
get_body() {
  awk '/^---$/{n++; next} n>=2' "$1"
}

# ---------------------------------------------------------------------------
# test_agents_are_discovered
# Verifies that at least one *.agent.md file exists under $AGENTS_DIR.
# ---------------------------------------------------------------------------
test_agents_are_discovered() {
  local files
  files=("$AGENTS_DIR"/*.agent.md)
  assertTrue "At least one *.agent.md file should be found in $AGENTS_DIR" \
    "[ -f '${files[0]}' ]"
}

# ---------------------------------------------------------------------------
# test_agents_have_name_field
# Each agent file must have a non-empty "name:" field in frontmatter.
# ---------------------------------------------------------------------------
test_agents_have_name_field() {
  for file in "$AGENTS_DIR"/*.agent.md; do
    local agent_name
    agent_name="$(basename "$file")"
    assertTrue "Agent '$agent_name' must have a non-empty 'name:' field in frontmatter" \
      "get_frontmatter '$file' | grep -qE '^name: .+'"
  done
}

# ---------------------------------------------------------------------------
# test_agents_have_description_field
# Each agent file must have a "description:" field in frontmatter.
# ---------------------------------------------------------------------------
test_agents_have_description_field() {
  for file in "$AGENTS_DIR"/*.agent.md; do
    local agent_name
    agent_name="$(basename "$file")"

    # Check that description key exists
    get_frontmatter "$file" | grep -q '^description:'
    assertTrue "Agent '$agent_name' must have a 'description:' field in frontmatter" $?

    # Check non-empty value: inline or block scalar
    if get_frontmatter "$file" | grep -qE '^description: [^|>]'; then
      # Inline value — must be non-empty on the same line
      get_frontmatter "$file" | grep -qE '^description: .+'
      assertTrue "Agent '$agent_name' 'description:' must have a non-empty inline value" $?
    elif get_frontmatter "$file" | grep -qE '^description: [|>]'; then
      # Block scalar — extract lines indented under description: (up to next non-indented line)
      local desc_content
      desc_content="$(get_frontmatter "$file" | \
        awk '/^description: [|>]/{found=1; next} found && /^  /{print} found && /^[^ ]/{exit}' | \
        grep -v '^[[:space:]]*$')"
      assertNotNull "Agent '$agent_name' 'description:' block scalar must have content" \
        "$desc_content"
    else
      # description: with no value (empty) — fail
      fail "Agent '$agent_name' 'description:' has an empty value (no inline value and not a block scalar)"
    fi
  done
}

# ---------------------------------------------------------------------------
# test_agents_have_color_field
# Each agent file must have a non-empty "color:" field in frontmatter.
# ---------------------------------------------------------------------------
test_agents_have_color_field() {
  for file in "$AGENTS_DIR"/*.agent.md; do
    local agent_name
    agent_name="$(basename "$file")"
    assertTrue "Agent '$agent_name' must have a non-empty 'color:' field in frontmatter" \
      "get_frontmatter '$file' | grep -qE '^color: .+'"
  done
}

# ---------------------------------------------------------------------------
# test_agents_have_user_invocable_field
# Each agent file must have a "user-invocable:" field (true or false) in frontmatter.
# ---------------------------------------------------------------------------
test_agents_have_user_invocable_field() {
  for file in "$AGENTS_DIR"/*.agent.md; do
    local agent_name
    agent_name="$(basename "$file")"
    assertTrue "Agent '$agent_name' must have a 'user-invocable: (true|false)' field in frontmatter" \
      "get_frontmatter '$file' | grep -qE '^user-invocable: (true|false)'"
  done
}

# ---------------------------------------------------------------------------
# test_agents_have_non_empty_body
# Each agent file must have a non-empty prompt body (content after frontmatter).
# ---------------------------------------------------------------------------
test_agents_have_non_empty_body() {
  for file in "$AGENTS_DIR"/*.agent.md; do
    local agent_name
    agent_name="$(basename "$file")"
    local body
    body="$(get_body "$file" | grep -v '^[[:space:]]*$')"
    assertNotNull "Agent '$agent_name' must have a non-empty prompt body after frontmatter" \
      "$body"
  done
}

# ---------------------------------------------------------------------------
# Source shunit2
# ---------------------------------------------------------------------------
if [[ -n "${SHUNIT2:-}" ]]; then
  # shellcheck disable=SC1090
  . "$SHUNIT2"
elif command -v shunit2 &>/dev/null; then
  . "$(command -v shunit2)"
elif [[ -f /usr/share/shunit2/shunit2 ]]; then
  . /usr/share/shunit2/shunit2
elif [[ -f /usr/local/opt/shunit2/libexec/shunit2 ]]; then
  . /usr/local/opt/shunit2/libexec/shunit2
else
  echo "Error: shunit2 not found. Install with: brew install shunit2  (macOS) or  sudo apt-get install shunit2  (Debian/Ubuntu)" >&2
  exit 1
fi


