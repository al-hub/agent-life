# Shell Boundary

`agent-init` is currently a runtime inspector and recommender.

It is not a runtime controller.

This document defines the shell ownership boundary before future activation,
attach, or switch behavior is implemented.

## Child Process Limitation

A normal command runs as a child process of the user's shell.

That child process cannot directly change the parent shell's state. This is an
operating system process boundary, not an `agent-life` design preference.

Consequences:

- `agent-init develop` cannot directly change the parent shell's `cwd`.
- `agent-init develop` cannot directly export variables into the parent shell.
- `agent-init develop` cannot directly activate a shell environment.
- Hidden shell mutation from a plain executable command should not be promised.

Future activation may require a shell-owned wrapper, such as `source` or `eval`,
but that direction is intentionally unresolved.

## Current MVP Boundary

Current implemented behavior:

- inspect
- recommend

Current unimplemented behavior:

- activate
- attach
- switch
- runtime mutation
- shell ownership takeover
- shell hook installation
- tmux orchestration
- daemon or watcher
- runtime state synchronization

The CLI may print facts or recommendations. It should not silently mutate the
user's shell.

## Activate vs Attach vs Switch

### Activate

Activation means preparing a shell or runtime environment for a profile.

Possible future behavior:

- Set environment variables
- Change prompt/runtime context
- Prepare profile-specific paths
- Write `current-profile`

Current status:

- Not implemented.
- Not specified fully.
- Requires explicit shell boundary design first.

### Attach

Attach means connecting to an existing runtime or session.

Possible future behavior:

- Connect to a tmux session
- Rejoin a previous agent workspace
- Show existing runtime metadata

Current status:

- Not implemented.
- No tmux integration exists.
- No session restore exists.

### Switch

Switch means changing the active context from one profile to another.

Possible future behavior:

- Update a local `current-profile`
- Recompute runtime context
- Emit instructions for the next shell-owned activation step

Current status:

- Not implemented.
- `current-profile` remains a future placeholder.
- No command writes active profile state.

## Source And Eval Direction

Future activation may need a shell-level interface because a child process cannot
own parent shell state.

Possible future shapes:

```sh
source <(agent-init activate develop)
eval "$(agent-init activate develop)"
```

These are examples of possible direction, not committed API.

Before adding any source or eval workflow, the project should decide:

- Which command is allowed to emit shell code
- Whether emitted code is human-reviewable
- Whether state writes happen before or after shell mutation
- How failures avoid partial activation
- How to keep secrets out of public framework output

## Shell Ownership Rules

- The user's shell owns its `cwd`, environment, aliases, functions, and prompt.
- `agent-init` must not pretend to mutate parent shell state from a child
  process.
- `install.sh` must not take shell or runtime ownership during bootstrap.
- Shell rc files must not be modified automatically.
- Explicit shell integration may add or remove only the `agent-life` marker
  block with user consent.
- PATH must not be overwritten automatically.
- Aliases must not be injected automatically.
- Symlinks must not be created automatically.
- Shell hooks must require explicit user action.
- Future activation semantics must be documented before implementation.

## Install Is Not Activation

`install.sh` may clone or update the public framework checkout, optionally
register explicit shell integration, and print manual next steps.

It must not:

- activate a profile
- write `current-profile`
- edit shell startup files without explicit consent
- modify PATH
- inject aliases
- start daemons or watchers
- attach to tmux
- perform background self-update behavior

Any PATH or symlink integration belongs in explicit user-owned next-step
guidance, not hidden installer behavior.

## Design Principles

- Semantic clarity comes before automation.
- Current CLI remains inspection/recommendation first.
- Runtime activation is intentionally unresolved.
- Local state remains ephemeral and minimal.
- Markdown remains persistent memory.
- Hidden shell mutation is not acceptable.

Lifecycle vocabulary and future state transition boundaries are documented in
`docs/runtime-lifecycle.md`.
