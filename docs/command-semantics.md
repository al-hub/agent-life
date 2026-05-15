# Command Semantics

`agent-init` commands are intentionally simple. The current MVP is centered on
inspection and discovery, not activation.

## Semantic Types

```text
inspect     read and report runtime facts
recommend   suggest a profile without switching or activating it
activate    prepare shell/runtime environment
attach      connect to an existing session
switch      change current runtime profile
```

Current MVP implements only `inspect` and `recommend` behavior.

It does not implement activation, attach, switch, shell mutation, tmux
orchestration, session restore, state synchronization, AGENTS.md semantic
parsing, RAG, or LLM integration.

See `docs/shell-boundary.md` for why plain child-process commands cannot mutate
the parent shell.

See `docs/runtime-lifecycle.md` for lifecycle vocabulary and current/future
stage boundaries.

CLI output is human-oriented diagnostics. `[OK]`, `[WARN]`, and `[INFO]` are
plain-text labels, not a stable machine interface.

## Command Table

```text
command              current semantic      current behavior
agent-init help      inspect               show command surface
agent-init status    inspect               report framework/core/state/profiles
agent-init list      inspect               list discovered profiles
agent-init auto      recommend             suggest a profile when unambiguous
agent-init doctor    inspect               run best-effort diagnostics
agent-init version   inspect               print framework/runtime version
agent-init develop   placeholder           future profile activation/recommendation
agent-init stock     placeholder           future profile activation/recommendation
```

## Command Details

### `agent-init help`

Semantic: inspect.

Current behavior:

- Prints available commands.
- Explains command-centered usage.
- Does not inspect private memory.
- Does not write state.

### `agent-init status`

Semantic: inspect.

Current behavior:

- Finds the framework path.
- Discovers `agent-core`.
- Reports local state path.
- Reports discovered profile names.
- Supports `--verbose` for additional checks.

It does not activate a profile or write `current-profile`.

### `agent-init list`

Semantic: inspect.

Current behavior:

- Discovers profiles from `agent-core/profiles/*`.
- Treats non-hidden directories as profile names.
- Does not parse `AGENTS.md`.
- Does not parse `profile.env`.
- Does not read profile memory.
- Does not activate anything.

### `agent-init auto`

Semantic: recommend.

Current behavior:

- Uses discovered profile names and local directory context.
- Recommends a profile only when the choice is unambiguous.
- If current directory name matches a profile, recommends that profile.
- If exactly one profile exists, recommends that profile.
- Otherwise reports no recommendation.

It does not switch profiles, source environment, restore a session, or write
state.

### `agent-init doctor`

Semantic: inspect.

Current behavior:

- Reports framework detection.
- Reports core discovery.
- Reports profile discovery.
- Reports `AGENT_CORE_PATH` status.
- Reports local config presence when relevant.
- Reports state path accessibility.
- Reports shell type as informational only.

It does not repair, activate, switch, sync, write runtime state, mutate shell
state, or start orchestration. Warnings are best-effort diagnostics and do not
always mean runtime failure. No strict exit-code contract is defined yet.
Verbose output adds reasoning only and does not change behavior.

### `agent-init version`

Semantic: inspect.

Current behavior:

- Prints the framework/runtime CLI version.
- Does not inspect core.
- Does not inspect profiles.
- Does not write state.

### `agent-init develop`

Semantic: placeholder.

Future direction:

- May target the `develop` profile.
- May recommend or activate development context later.

Current stage:

- Not implemented.
- Not a shell activation command.
- Not a session restore command.
- Does not define `current-profile` write behavior yet.

### `agent-init stock`

Semantic: placeholder.

Future direction:

- May target the `stock` profile.
- May recommend or activate stock context later.

Current stage:

- Not implemented.
- Not a trading engine.
- Not a shell activation command.
- Not a session restore command.
- Does not define `current-profile` write behavior yet.

## State Policy

Current commands should minimize state persistence.

Allowed at this stage:

- Reporting state path
- Defining future state file names in docs

Not allowed at this stage:

- Writing `current-profile`
- Writing session restore files
- Starting a daemon
- Synchronizing state
- Mutating shell environment

State file formats are intentionally not strict yet.
