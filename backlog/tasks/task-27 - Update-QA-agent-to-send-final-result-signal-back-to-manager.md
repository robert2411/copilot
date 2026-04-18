---
id: TASK-27
title: Update QA agent to send final result signal back to manager
status: In Progress
assignee:
  - '@implementation'
created_date: '2026-04-18 21:19'
updated_date: '2026-04-18 21:30'
labels:
  - agent
  - qa
milestone: Security Agent & Agent Pipeline Improvements
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the QA agent to emit a clear, machine-detectable final result signal that the manager can detect. The signal should be one of: ✅ QA APPROVED or ❌ QA REJECTED with a reason. The agent instructions should clarify it reports back to manager (not just appends notes) and document the re-review loop. Reference: doc-15.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 QA agent emits a clear final approval signal: ✅ QA APPROVED — all tests passing, no regressions
- [x] #2 QA agent emits a clear rejection signal: ❌ QA REJECTED — [reason]
- [x] #3 Agent instructions clarify QA reports back to manager, not just appends notes
- [x] #4 Re-review loop documented: QA rejects → manager → implementation fixes → manager → QA re-verifies
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Updated QA approval signal to ✅ QA APPROVED — all tests passing, no regressions. Added 'Reporting Back to Manager' section documenting the re-review loop and post-QA security gate routing.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 All code is committed to git
<!-- DOD:END -->
