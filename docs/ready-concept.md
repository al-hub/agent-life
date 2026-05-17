# Ready Concept

`ready` is a marker-block preview flow for AI work contexts.

The decided target command is `agent-init ready <context>`.

`ready <context>` prints the same `agent-life` marker block that
`agent-init select <context>` would write into the current project's
`AGENTS.md`, but it prints the block to stdout only.

That makes `ready <context>` a dry-run for the project-local context
connection.

```text
agent-init ready repo-review
```

Means:

```text
preview the repo-review marker block, with no file mutation
```

The marker block is the canonical representation of an `agent-life` context
connection. It is a small window pointing at `agent-core`, not a copy of private
context.

## Command Relationship

The marker-block-centered command model is:

```text
agent-init ready <context>   preview the context marker block on stdout
agent-init select <context>  write/update that marker block in project AGENTS.md
agent-init <context>         shortcut for agent-init select <context>
agent-init remove all        remove only the agent-life marker block
agent-init status            inspect the current project marker block
```

`ready` is useful when the user wants to inspect what would be connected before
writing it. `select` is useful when the user wants the current project to carry
a durable, reversible reference to the selected AI context.

This document records target semantics. The current implementation may still
show the older readiness briefing until the CLI is updated.

## Context Names

A context is a single AI-ready context name. If a combination is useful, it
should be named as one kebab-case context such as `python-arch`,
`money-dividend`, or `faith-nehemiah`. The CLI should not compose contexts from
multiple free arguments like `agent-init python arch`.

Good context names:

```text
work
repo-review
python
python-arch
cli
shell-cli
infographic
money-dividend
faith-nehemiah
travel-yeosu
```

Context names to avoid:

```text
python arch
work arch python
all
misc
temp
dev-stuff
```

Good names are readable and imply one context intent. Avoid reserved command
names such as `help`, `doctor`, `status`, `list`, `auto`, `version`, `ready`,
`select`, `remove`, and `update`.

## Public Sample Context

`repo-review` is the first recommended public sample context candidate for
evaluating `agent-life` itself.

It is useful because it gives an AI a concrete review lens:

- current repository state
- documented decisions and next actions
- improvement candidates
- risks and unclear boundaries
- verification habits

`repo-review` is a context, not automatic analysis. `agent-init repo-review`
means `agent-init select repo-review`.

Runtime discovery still reads private `agent-core/profiles/*`; public sample
profiles are templates only.

The selected context describes what an AI should read before work begins:

- detected framework
- detected core
- selected or suggested context
- relevant files to read first
- boundary reminders
- suggested verification commands
- a task brief skeleton

`ready <context>` does not run the task.
It does not activate a profile.
It does not mutate shell state, environment variables, or runtime state.
It does not manage tmux sessions, daemons, or orchestration.
It does not write `AGENTS.md`.
It does not copy or merge `agent-core` files.

## Ready Versus Select

`ready` and `select` solve different problems using the same marker block.

```text
ready   preview the marker block without file mutation
select  write/update the marker block in the current project's AI instruction file
remove  remove only that project-local marker block
status  report whether a project-local marker block is selected
```

For the Codex MVP target, `select` uses the current project's `AGENTS.md` as
the AI instruction surface. It writes only an explicit `agent-life` marker
block with read-first references to the selected `agent-core` context.

`ready <context>` should use the same marker block generation logic as
`select <context>`. The preview and the written marker block must not drift.

`select` is not activation. It must not source environment, write
`current-profile`, mutate shell state, start orchestration, copy `agent-core`
files, merge private memory, or edit content outside the `agent-life` marker
block.

`ready` remains useful when the user wants a dry-run preview without
project-local mutation.

## Relationship To The CLI Shortcut

The user-facing shortcut decision is:

```text
agent-init <context>
```

Its intended internal meaning is:

```text
agent-init select <context>
```

That relationship is implemented by delegating to the existing select handler.

The shortcut must remain project-local marker-block mutation only. It must not
activate a profile, source environment, mutate shell state, write
`current-profile`, attach a session, start orchestration, or automatically
parse and merge private memory/prompts/workflows.

## MVP Acceptance Criteria

The marker-block preview implementation should:

- resolve the requested context through `agent-core`
- generate the same marker block as `select`
- print the marker block to stdout
- keep the marker block small and reference-only
- make no file changes
- preserve the `select` and `remove all` marker block invariants

The marker-block preview implementation must not:

- run the task
- activate a profile
- mutate shell state, environment variables, or runtime state
- manage tmux sessions, daemons, or orchestration
- parse `AGENTS.md` semantically
- write `AGENTS.md`
- copy or merge `agent-core` contents

Acceptance is about preview accuracy and boundary clarity, not automation.

## Example Shape

```text
<!-- agent-life:start -->
## Agent-life selected context

Selected context:
- repo-review

Read first:
- <agent-core>/profiles/repo-review/AGENTS.md

Rules:
- Treat this context as guidance for the current AI session.
- Do not modify agent-core files unless explicitly asked.
- Follow project AGENTS.md and selected context together.
- This is not activation, orchestration, or shell/runtime mutation.
<!-- agent-life:end -->
```

This document is for meaning and boundary definition only.
