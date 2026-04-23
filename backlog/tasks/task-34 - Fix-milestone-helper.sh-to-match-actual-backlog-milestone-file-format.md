---
id: TASK-34
title: Fix milestone-helper.sh to match actual backlog milestone file format
status: To Do
assignee: []
created_date: '2026-04-23 09:13'
labels:
  - bug
  - milestone-helper
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The milestone-helper.sh script creates milestone files with an incorrect format and naming convention. The actual backlog CLI creates milestones with the file name pattern 'm-N - <slug>.md' and a minimal frontmatter containing only 'id' (as 'm-N') and 'title', plus a '## Description' section. The script currently uses 'milestone-N - <slug>.md', a different id format, and extra frontmatter fields (description, status, created_date) that are not part of the real format.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 File is named using pattern 'm-N - <slug>.md' (e.g. m-1 - sprint-1.md)
- [ ] #2 Frontmatter contains only 'id: m-N' and 'title: "<Title>"'
- [ ] #3 File body contains a '## Description' section with text 'Milestone: <Title>'
- [ ] #4 ID auto-increment scans existing 'm-N - *.md' files instead of 'milestone-N - *.md'
- [ ] #5 Duplicate check uses the new file naming pattern
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 All code is committed to git
<!-- DOD:END -->
