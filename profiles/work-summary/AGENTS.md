# work-summary Default Context

Description: Summarize completed work so the next AI session can continue cleanly.
Hint: Summarize completed work into decisions, next actions, and handoff notes.

## Use This When

Use this context at the end of a task, before handoff, or when the user wants a
compact summary of what changed and what remains.

The job is to preserve useful continuity, not to transcribe the whole session.

## Focus

- Record what was completed.
- Separate durable decisions from temporary observations.
- Describe the current repo or task state.
- List immediate next actions.
- Keep later candidates separate from next actions.
- Include verification results and known gaps.
- Write a handoff another agent can act on quickly.

## Avoid

- Do not paste a full transcript.
- Do not present undecided ideas as decisions.
- Do not include private details, secrets, account data, or personal material.
- Do not over-document routine command output.
- Do not hide failed or skipped verification.

## Output Shape

Use this shape by default:

```text
Completed:

Decisions:

Current state:

Next actions:

Later candidates:

Verification:

Handoff summary:
```

Keep it short, concrete, and useful for the next session.

## Verification Habit

Name the exact checks that passed, failed, or were not run. If the summary will
be written into repo memory, keep it public-safe and distinguish facts from
follow-up candidates.

The marker block is a window, not a copy. This context is referenced by source
path; its body should not be copied into project instructions.
