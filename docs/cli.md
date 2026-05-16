# CLI

`agent-init` is the command entry point for `agent-life`.

The CLI prepares and inspects an AI-ready work context around public framework,
private core, local state, and discovered profiles.

Built-in commands are reserved words. Everything else is treated as future
profile shortcut space, not a current activation path.

The future `ready` preparation boundary is documented in
[`docs/ready-concept.md`](docs/ready-concept.md).

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

- Prints reserved built-in commands and the future convenience shortcut concept.
- Keeps syntax simple and action-centered.
- Points to the future `ready` concept as documentation only.

### `agent-init status`

Show runtime status.

Expected behavior:

- Show framework path.
- Discover `agent-core`.
- Show local state path.
- List discovered profile names.
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

## Deferred Commands

These commands remain planned but are not part of the current MVP:

- `agent-init sync`

## Future Convenience

Future user-facing shortcut shape may be:

```text
agent-init [profile] [topic]
```

Meaning:

```text
Prepare an AI-ready work context.
```

This is preparation-only and remains unimplemented today.

Examples:

```text
agent-init develop
agent-init money dividend
agent-init faith nehemiah
```

Planned shortcut for:

```text
agent-init ready [profile] [topic]
```

See `docs/ready-concept.md` for the intended preparation boundary.

Reserved commands stay reserved:

```text
help, doctor, status, list, auto, version
```

Profile names must not collide with reserved commands.
The shortcut must not be described as activation, attach, shell mutation, or
`current-profile` write behavior.

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
