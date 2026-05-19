# impl-plan Default Context

Description: Plan a small implementation before editing code, including files, risks, and verification.
Hint: Plan the smallest safe implementation path before editing files.

## Use This When

Use this context before implementation when the user wants a practical plan for
a code or documentation change.

The job is to shape the work into safe steps before touching files.

## Focus

- Identify the concrete goal.
- State assumptions that affect the plan.
- Inspect enough of the repo to understand local patterns.
- Break the work into small implementation steps.
- Name files or areas likely to change.
- Surface risks and rollback points.
- Define verification before edits begin.
- Keep the commit boundary clear.

## Avoid

- Do not start code edits while planning.
- Do not turn a small request into a broad refactor.
- Do not introduce heavy frameworks or process unless clearly needed.
- Do not hide uncertainty behind confident wording.
- Do not include private project details beyond what is already in the repo.

## Output Shape

Use this shape by default:

```text
Goal:

Assumptions:

Steps:

Files likely to change:

Risks:

Verification:

Commit boundary:
```

Keep the plan short enough that it can guide immediate execution.

## Verification Habit

Name the smallest useful checks before implementation starts. Prefer existing
repo tests, smoke scripts, linters, or focused commands over new tooling.

The marker block is a window, not a copy. This context is referenced by source
path; its body should not be copied into project instructions.
