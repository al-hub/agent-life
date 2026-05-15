# CLI

`agent-init` is the command entry point for the personal AI operating system.

The CLI initializes and inspects an agent runtime around public framework,
private core, local state, and discovered profiles.

## Design Rules

- Command is action.
- Argument is target.
- Options are minimal.
- Complex behavior belongs in config files.
- Output should be readable by humans and useful to AI agents.
- Failures should explain the next concrete fix.

## Commands

See `docs/command-semantics.md` for the semantic meaning of each command.

### `agent-init help`

Show the command surface and design rules.

Current behavior:

- Prints available MVP commands.
- Keeps syntax simple and action-centered.

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
Framework: OK
Framework Path: /path/to/agent-life
Core: Found
Core Path: /path/to/agent-core
Core Source: sibling
State: Local
State Path: /home/user/.local/state/agent-life
Profiles: develop, stock, faith
```

### `agent-init list`

List profiles from `agent-core/profiles/*`.

Expected behavior:

- Do not hardcode profile names.
- Treat each non-hidden directory under `profiles/` as a profile.
- Print `Profiles: none` when no core or profile directory exists.
- Do not parse or activate profile contents.

### `agent-init auto`

Select a profile from discovered profiles using local context.

Current MVP behavior:

- If current directory name matches a discovered profile directory, select it.
- If exactly one profile exists, select it.
- Otherwise print no selection and explain why.

This command does not activate environments, source shell files, restore
sessions, switch profiles, write state, or load private memory yet.

### `agent-init version`

Print the CLI version.

## Deferred Commands

These commands remain planned but are not part of the current MVP:

- `agent-init develop`
- `agent-init stock`
- `agent-init sync`
- `agent-init doctor`

## Path Discovery

`agent-init` finds `agent-core` in this order:

1. `AGENT_CORE_PATH`
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

`status` reports the result. `list` and `auto` use the same discovery behavior.

## Option Policy

Prefer config over flags.

Allowed future options should be rare and practical, such as:

```text
agent-init status --verbose
agent-init list --verbose
agent-init auto --verbose
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
