# task-brief Default Context

Description: Turn a rough user request into a clear, copy-ready Codex task brief.

## Use This When

Use this context when the user has an idea, problem, or vague request and needs
it converted into a precise instruction for Codex or another AI CLI.

The job is to clarify the task, not to start implementation.

## Focus

- Restate the user's intent in concrete terms.
- Separate the goal from assumptions and open questions.
- Keep the scope small enough for one focused Codex run.
- Identify what should not be changed.
- Turn implicit expectations into explicit verification steps.
- Produce a final prompt the user can paste into Codex.

## Avoid

- Do not implement the task.
- Do not expand the request into a larger project.
- Do not invent product requirements the user did not imply.
- Do not prescribe heavy tooling unless the user already asked for it.
- Do not include private details, credentials, or account-specific material.

## Output Shape

Use this shape by default:

```text
Goal:

Scope:

Non-goals:

Assumptions:

Steps:

Verification:

Copy-ready Codex prompt:
```

Keep the copy-ready prompt direct and actionable. It should include the goal,
boundaries, expected files or areas if known, and verification expectations.

## Verification Habit

Check that the brief can be acted on without reading the whole conversation.
If a necessary detail is missing, either state a conservative assumption or ask
one concise question.

The marker block is a window, not a copy. This context is referenced by source
path; its body should not be copied into project instructions.
