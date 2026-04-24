---
id: milestone-6
name: Milestone: Add agent validation tests
description: Add a test suite under tests/agents that validates every file in .github/agents is a valid Copilot agent; ensure CI runs validation on push/PR.
status: active
created_date: '2026-04-24'
---

# Milestone: Add agent validation tests

Create tests to validate agent files in `.github/agents/` and integrate them into CI. Tests live under `tests/agents/` and include discovery, parsing, schema validation, prompt/actions checks, secrets scanning, fixtures, helpers, and CI integration.

