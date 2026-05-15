# CLI

`agent-init` is the command entry point for the personal AI operating system.

The CLI initializes an agent session around a target context: development,
stock analysis, automatic detection, status checks, synchronization, or
diagnostics.

## Design Rules

- Command is action.
- Argument is target.
- Options are minimal.
- Complex behavior belongs in config files.
- Output should be readable by humans and useful to AI agents.
- Failures should explain the next concrete fix.

## Commands

### `agent-init develop`

Load the development profile.

Expected behavior:

- Discover `agent-core`.
- Load development-oriented prompts and memory from private context.
- Print session handoff instructions for coding agents.
- Avoid exposing private content unless running in a trusted local session.

### `agent-init stock`

Load the stock or market-analysis profile.

Expected behavior:

- Discover `agent-core`.
- Load finance/stock profile context.
- Prepare agent instructions for market research workflows.
- Keep account details and private financial data in `agent-core`.

### `agent-init auto`

Detect the current context and choose a profile.

Expected behavior:

- Inspect current directory.
- Detect whether the session looks like development, finance, docs, or general
  work.
- Select the best available profile.
- Show the selected profile and reason.

### `agent-init status`

Show runtime status.

Expected output:

```text
agent-life: found
agent-core: found at ../agent-core
core source: sibling
profile: not loaded
shell integration: unknown
```

### `agent-init sync`

Synchronize safe context between public and private layers.

Expected behavior:

- Sync only approved public summaries.
- Never copy private memory into `agent-life`.
- Surface files that require manual review.

### `agent-init doctor`

Diagnose installation and runtime readiness.

Expected checks:

- `agent-life` repo root exists.
- `agent-core` path can be discovered.
- Discovered core path is a git repo.
- `bin/agent-init` is executable.
- Shell path can reach `agent-init`.
- No obvious private files are tracked by `agent-life`.

## Path Discovery

`agent-init` finds `agent-core` in this order:

1. `AGENT_CORE_PATH`
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

`status` reports the result. `doctor` validates it.

## Option Policy

Prefer config over flags.

Allowed future options should be rare and practical, such as:

```text
agent-init doctor --verbose
agent-init sync --dry-run
```

Do not add option-heavy command variants unless the command model cannot express
the behavior clearly.
