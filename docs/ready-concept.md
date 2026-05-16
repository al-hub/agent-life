# Ready Concept

`ready` is a preparation flow for AI work contexts.

The current minimal command is `agent-init ready`, with an optional explicit
profile target such as `agent-init ready develop`.

`ready` prints a briefing for the current session. It does not connect that
briefing to a project file.

The simpler shortcut concept now under review is:

```text
agent-init
agent-init <context>
agent-init ready <context>
```

`agent-init` means a default ready briefing. `agent-init <context>` would be a
future shortcut for a context-specific ready briefing. `agent-init ready
<context>` is the explicit form.

In this concept, a context is a single AI-ready briefing name. If a combination
is useful, it should be named as one kebab-case context such as `python-arch`,
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

Good names are readable and imply one briefing intent. Avoid reserved command
names such as `help`, `doctor`, `status`, `list`, `auto`, `version`, and
`ready`.

## Public Sample Context

`repo-review` is the first recommended public sample context candidate for
evaluating `agent-life` itself.

It is useful because it gives an AI a concrete review lens:

- current repository state
- documented decisions and next actions
- improvement candidates
- risks and unclear boundaries
- verification habits

`repo-review` is a briefing context, not automatic analysis. It does not make
`agent-init repo-review` work, does not activate a profile, and does not change
the current `ready` behavior. Runtime discovery still reads private
`agent-core/profiles/*`; public sample profiles are templates only.

It describes what `agent-init` should prepare before work begins:

- detected framework
- detected core
- selected or suggested profile
- relevant files to read first
- boundary reminders
- suggested verification commands
- a task brief skeleton

`ready` does not run the task.
It does not activate a profile.
It does not mutate shell state, environment variables, or runtime state.
It does not manage tmux sessions, daemons, or orchestration.

## Ready Versus Select

`ready` and the future `select` flow solve different problems.

```text
ready   print a one-time briefing for the current AI session
select  connect a context reference to the current project's AI instruction file
remove  remove only that project-local context reference
status  report whether a project-local context reference is selected
```

For the Codex MVP target, `select` would use the current project's `AGENTS.md`
as the AI instruction surface. It would write only an explicit `agent-life`
marker block with read-first references to the selected `agent-core` context.

`select` is not activation. It must not source environment, write
`current-profile`, mutate shell state, start orchestration, copy `agent-core`
files, merge private memory, or edit content outside the `agent-life` marker
block.

`ready` remains useful when the user wants a transient briefing without
project-local mutation. `select` is useful when the user wants the current
project to carry a durable, reversible reference to the selected AI context.

## Relationship To The CLI Shortcut

The user-facing future shortcut candidate is:

```text
agent-init [context]
```

Its intended internal meaning is:

```text
agent-init ready [context]
```

That relationship is documented here only.
The shortcut is not implemented in the current MVP.

The shortcut must remain preparation-only. It must not activate a profile,
source environment, mutate shell state, write `current-profile`, attach a
session, start orchestration, or automatically parse and merge private
memory/prompts/workflows.

## MVP Acceptance Criteria

The first usable `ready` MVP should:

- show the framework path
- show the core discovery result
- show discovered profiles, or a no-profile warning
- show a selected, suggested, or requested profile, or a no-profile warning
- show a short recommended file list to read first
- show boundary reminders
- show suggested verification commands
- show a short task brief skeleton

The first usable `ready` MVP must not:

- run the task
- activate a profile
- mutate shell state, environment variables, or runtime state
- manage tmux sessions, daemons, or orchestration
- parse `AGENTS.md` semantically

Acceptance is about boundary and usefulness, not automation. The listed files
are recommendations for a human or AI to read first; the command must not
automatically parse or merge their contents.

## Example Shape

```text
Framework: detected
Core: detected
Profile: develop

Read first:
- README.md
- AGENTS.md
- NEXT.md
- DECISIONS.md
- docs/cli.md
- agent-core/profiles/develop/AGENTS.md

Boundary reminders:
- do not activate profiles
- do not write current-profile
- do not mutate shell state
- do not start orchestration

Suggested verification:
- ./bin/agent-init doctor
- ./bin/agent-init status
- sh tests/smoke/run.sh

Task brief:
Summarize the current goal, constraints, and next action.
```

This document is for meaning and boundary definition only.
