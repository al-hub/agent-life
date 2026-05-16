# Ready Concept

`ready` is a preparation flow for AI work contexts.

The current minimal command is `agent-init ready`.

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

## Relationship To The CLI Shortcut

The user-facing future shortcut shape is:

```text
agent-init [profile] [topic]
```

Its intended internal meaning is:

```text
agent-init ready [profile] [topic]
```

That relationship is documented here only.
The shortcut is not implemented in the current MVP.

## MVP Acceptance Criteria

The first usable `ready` MVP should:

- show the framework path
- show the core discovery result
- show a selected or suggested profile, or a no-profile warning
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
