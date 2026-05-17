# CLI

`agent-init` is the command entry point for `agent-life`.

The CLI prepares, inspects, and connects an AI-ready work context around public
framework, private core, local state, discovered profiles, and project-local
marker blocks.

Built-in commands are reserved words. The decided target for any non-reserved
single context argument is `agent-init select <context>`, not activation.

The `ready` preview boundary is documented in
[`docs/ready-concept.md`](docs/ready-concept.md).
The decided target meaning is that `agent-init ready <context>` previews the
marker block that `select` would write without modifying files.

Project-local marker block behavior is documented in
[`docs/marker-block.md`](docs/marker-block.md).

## Design Rules

- Command is action.
- Argument is target.
- Options are minimal.
- Complex behavior belongs in config files.
- Output should be readable by humans and useful to AI agents.
- Failures should explain the next concrete fix.
- `[OK]`, `[WARN]`, and `[INFO]` are human diagnostic labels, not a stable
  machine-readable protocol.

## Commands

See `docs/command-semantics.md` for the semantic meaning of each command.

### `agent-init help`

Show the command surface and design rules.

Current behavior:

- Prints reserved built-in commands and documented command direction.
- Keeps syntax simple and action-centered.
- Describes the current `ready`, `select`, and `remove` command surface.

### `agent-init status`

Show runtime status.

Expected behavior:

- Show framework path.
- Discover `agent-core`.
- Show local state path.
- List discovered profile names.
- Show project path.
- Show project `AGENTS.md` and `agent-life` marker block status.
- Show selected context and context source, or `none`.
- Warn when the selected context source is missing.
- Support only `--verbose` for extra checks.

Expected output:

```text
[OK] Framework detected
     Path: /path/to/agent-life
[OK] Core path found
     Path: /path/to/agent-core
     Source: sibling
[INFO] State path
     Path: /home/user/.local/state/agent-life
[INFO] Project path
     Path: /path/to/project
[OK] Project AGENTS.md: found
[OK] Agent-life marker block: found
     Selected context: repo-review
     Context source: /path/to/agent-core/profiles/repo-review/AGENTS.md
[OK] Discovered profiles: develop, stock, faith
```

### `agent-init list`

List profiles from `agent-core/profiles/*`.

Expected behavior:

- Do not hardcode profile names.
- Treat each non-hidden directory under `profiles/` as a profile.
- Print `Discovered profiles: none` when no core or profile directory exists.
- Do not parse or activate profile contents.

### `agent-init auto`

Select a profile from discovered profiles using local context.

Current MVP behavior:

- If current directory name matches a discovered profile directory, select it.
- If exactly one profile exists, select it.
- Otherwise print no selection and explain why.

This command does not activate environments, source shell files, restore
sessions, switch profiles, write state, or load private memory yet.

### `agent-init doctor`

Run best-effort runtime diagnostics.

Expected behavior:

- Check framework detection.
- Check whether `git` is available.
- Report `AGENT_CORE_PATH` status.
- Check core discovery.
- Check profile discovery.
- Check state path accessibility without creating it.
- Report shell type as informational only.
- In verbose mode, print reasoning about discovery paths.

`doctor` does not repair, activate, switch, sync, write `current-profile`, mutate
the shell, or start orchestration. Warnings are informational and do not always
mean runtime failure. No strict exit-code contract is defined yet.

### `agent-init version`

Print the CLI version.

### `agent-init ready`

Preview an AI-ready context marker block.

Expected behavior:

- Show the framework path.
- Show the core discovery result.
- Show discovered profiles.
- Show a suggested profile, a requested profile, or a no-profile warning.
- May accept one explicit profile target.
- Show read-first files, boundary reminders, verification commands, and a
  short task brief skeleton.
- Do not parse or merge recommended files.
- Do not activate profiles, mutate shell or runtime state, or perform
  orchestration.

Target behavior for `agent-init ready <context>`:

- Resolve `agent-core/profiles/<context>/AGENTS.md`.
- Print the same marker block that `agent-init select <context>` would write.
- Do not write `AGENTS.md` or any other file.
- Share marker block generation logic with `select` to prevent drift.

### `agent-init <context>`

Shortcut for `agent-init select <context>`.

Target behavior:

- Treat one non-reserved argument as a context name.
- Write or update the project-local marker block exactly as `select` would.
- Do not treat reserved commands as contexts.
- Do not activate profiles, write `current-profile`, mutate shell/env state,
  copy `agent-core` files, or start orchestration.

This shortcut delegates to the existing `select` handler.

### `agent-init select <context>`

Select one project-local AI context for the current project.

Current behavior:

- Requires `agent-core/profiles/<context>/AGENTS.md` to exist.
- Writes or refreshes only the `agent-life` marker block in project
  `AGENTS.md`.
- Appends the marker block when no marker exists.
- Replaces only the existing marker block when changing context.
- Refuses malformed or duplicate marker tokens.
- Does not copy or merge `agent-core` files.
- Does not activate profiles, write `current-profile`, mutate shell/env state,
  or start orchestration.

### `agent-init remove all`

Remove the project-local `agent-life` marker block.

Current behavior:

- Removes only the `agent-life` marker block from project `AGENTS.md`.
- Keeps all user-authored AGENTS content outside the marker block.
- Deletes `AGENTS.md` only when the file contains only the marker block and
  whitespace.
- Refuses malformed or duplicate marker tokens.

Expected output:

```text
agent-init ready

[OK] Framework detected
     Path: /path/to/agent-life
[OK] Core path found
     Path: /path/to/agent-core
     Source: sibling
[OK] Suggested profile: develop
[INFO] Reason: current directory name matches a discovered profile

[INFO] Discovered profiles
[OK] Discovered profiles: develop, stock, faith
     - develop
     - stock
     - faith

[INFO] Read first
     README.md
     docs/what-is-agent-life.md
     docs/cli.md
     docs/command-semantics.md
     docs/ready-concept.md
     agent-core/profiles/develop/AGENTS.md
```

## Deferred Commands

These commands remain planned but are not part of the current MVP:

- `agent-init sync`

## Context Shortcut

The decided shortcut shape is:

```text
agent-init <context>
```

Meaning:

```text
agent-init select <context>
```

This is project-local marker-block mutation only.

Examples:

```text
agent-init repo-review
agent-init infographic-format-a
agent-init cpp-review
```

Dry-run preview:

```text
agent-init ready <context>
```

See `docs/ready-concept.md` for the marker-block preview boundary.

Reserved commands stay reserved:

```text
help, doctor, status, list, auto, version, ready, select, remove, update
```

Profile names must not collide with reserved commands.
The shortcut must not be described as activation, attach, shell mutation,
`current-profile` write behavior, or `agent-core` content copying.

## Path Discovery

`agent-init` finds `agent-core` in this order:

1. `AGENT_CORE_PATH`
2. `~/.agent-life/config` key `default-core-path`
3. `../agent-core`
4. `~/.agent-core`

`status` reports the result. `list` and `auto` use the same discovery behavior.

Local config is optional and read-only from the CLI. See `docs/config.md`.
The discovery implementation is kept in an internal shell helper so observer
commands resolve the same core path in the same environment.

Current no-argument invocation still shows help. A future no-argument
preparation concept is documented only and not implemented.

## Option Policy

Prefer config over flags.

Allowed future options should be rare and practical, such as:

```text
agent-init status --verbose
agent-init list --verbose
agent-init auto --verbose
agent-init doctor --verbose
```

Do not add option-heavy command variants unless the command model cannot express
the behavior clearly.

## Non-Goals For MVP

The MVP does not implement:

- tmux orchestration
- shell export/source
- RAG engine
- LLM integration
- AGENTS.md parsing
- session restore
- environment activation

Shell/process ownership details are documented in `docs/shell-boundary.md`.

Lifecycle vocabulary is documented in `docs/runtime-lifecycle.md`.

## Profile Contract

See `docs/profile-contract.md`.

The CLI currently treats profiles as directories only. Directory existence is
the contract used for discovery. `AGENTS.md`, `prompts/`, `memory/`, `context/`,
and `profile.env` are documented conventions for humans and future agents, not
runtime inputs for the current MVP.

## Runtime State

See `docs/runtime-state.md`.

The CLI may report `~/.local/state/agent-life`, but current MVP commands should
not persist runtime state. `current-profile`, `last-context`, `sessions/`, and
`cache/` are documented future placeholders, not active runtime requirements.

## Verbose Output

Verbose output adds reasoning and diagnostic details only. It must not change
runtime behavior, write files, repair state, activate profiles, or mutate the
shell.

## Smoke Tests

Lightweight command regression checks live under `tests/smoke/`.

Run them with:

```sh
tests/smoke/run.sh
```

The smoke tests use isolated temporary `HOME` directories and POSIX shell
scripts. They cover install/bootstrap behavior, `doctor`, core discovery
precedence, `list`, and `auto` without adding activation, state writes, shell
mutation, or a test framework dependency.
