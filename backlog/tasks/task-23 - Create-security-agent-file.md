---
id: TASK-23
title: Create security agent file
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-18 21:19'
updated_date: '2026-04-18 21:29'
labels:
  - agent
  - security
milestone: Security Agent & Agent Pipeline Improvements
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create the security auditor agent (.github/agents/security.agent.md) that acts as an always-on static security audit gate running after QA approves. The agent audits code for OWASP Top 10, path traversal, ReDoS, and missing input validation. It emits a structured verdict and supports re-audit mode scoped to a single finding. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Security agent file created at .github/agents/security.agent.md
- [ ] #2 Agent audits OWASP Top 10 + path traversal + ReDoS + input validation
- [ ] #3 Agent emits approval signal `✅ SECURITY APPROVED` (distinct from `✅ QA APPROVED`)
- [ ] #4 Agent emits findings signal `⚠️ SECURITY FINDINGS:` with severity tags [critical/high/medium/low] when
  vulnerabilities found
- [ ] #5 Agent supports re-audit mode scoped to a single finding ID
- [ ] #6 Agent does NOT write files or run code — static analysis only
- [ ] #7 Severity ranking (critical/high/medium/low) documented in agent
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
