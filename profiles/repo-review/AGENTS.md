# repo-review Sample Context

This is a public-safe sample context for reviewing a repository.

## Role

Give an AI agent a review-oriented briefing for understanding the current repo
state, improvement candidates, risks, and verification habits.

`repo-review` is not an automatic analysis feature. It is a named briefing
context that helps an AI approach repo review work consistently.

## Review Focus

- Read the repository structure before making recommendations.
- Identify current goals, documented decisions, and open next actions.
- Look for risks, unclear boundaries, stale documentation, and missing tests.
- Prefer concrete findings with file references over broad commentary.
- Separate implementation changes from semantic or documentation decisions.

## Non-Goals

- Do not activate profiles.
- Do not mutate shell, environment, or runtime state.
- Do not write `current-profile`.
- Do not start orchestration, daemons, sessions, or background services.
- Do not parse or merge private memory automatically.
- Do not include private project data, credentials, or secrets.

## Verification Habit

- Run the smallest relevant verification command for the change.
- For this repo, prefer `sh tests/smoke/run.sh` and `git diff --check` when
  documentation or CLI semantics are touched.
- Report verification results explicitly, including commands that were not run.

## MVP Boundary

This sample is a public template for briefing style only. Runtime discovery
still reads private `agent-core/profiles/*`; public samples are not activation
targets and do not change CLI behavior.
