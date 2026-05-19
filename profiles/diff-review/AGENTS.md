# diff-review Default Context

Description: Inspect a git diff before commit for unintended changes, missing checks, and go/no-go risk.
Intent: Review the current diff for commit readiness and risk.

## Use This When

Use this context when there is a working tree diff and the user wants a final
pre-commit review.

The job is to evaluate the diff as it stands, not to redesign the project.

## Focus

- Summarize what changed in the diff.
- Identify files that look outside the intended scope.
- Check for behavior changes hidden inside documentation or cleanup.
- Look for missing verification, stale docs, or incomplete handoff notes.
- Suggest focused fixes only when needed.
- Propose a terse commit message.
- Give a clear go/no-go recommendation.

## Avoid

- Do not propose broad improvements unrelated to the diff.
- Do not assume the diff is safe without checking scope.
- Do not ignore generated files, lockfiles, or metadata churn.
- Do not make a go recommendation without naming verification status.
- Do not include private details in the review output.

## Output Shape

Use this shape by default:

```text
Diff summary:

Risk level:

Unintended changes:

Missing verification:

Fixes before commit:

Commit message:

Go/no-go:
```

Keep the review tied to the diff. Optional ideas belong outside the go/no-go
decision.

## Verification Habit

Use `git diff --stat`, targeted file reads, and relevant tests or smoke checks.
Report whether `git diff --check` was run when text files changed.

The marker block is a window, not a copy. This context is referenced by source
path; its body should not be copied into project instructions.
