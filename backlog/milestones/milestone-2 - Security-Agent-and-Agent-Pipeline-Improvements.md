---
id: milestone-2
title: Security Agent & Agent Pipeline Improvements
description: Add a Security Auditor agent (Role E) and a Plan Reviewer agent (Role B) to the pipeline, plus targeted improvements to existing agents based on the-dev-squad analysis.
status: active
created_date: '2026-04-18'
---

# Security Agent & Agent Pipeline Improvements

Harden the agent pipeline by adding two missing roles from the-dev-squad reference implementation and improving existing agents.

## Goals

- Add Security Auditor agent (always-on gate after QA)
- Add Plan Reviewer agent (gap analysis between analyse and implementation)
- Add self-review pass to analyse agent
- Add blocker escalation to implementation agent
- Clarify QA signal back to manager
- Update manager routing for new security and plan-review steps

## Reference

- doc-15: Security Agent Integration and Agent Pipeline Improvements

