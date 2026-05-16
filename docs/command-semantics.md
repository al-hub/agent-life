# Command Semantics

`agent-init` commands are intentionally simple. The current MVP is centered on
inspection and discovery, not activation.

Built-in commands are reserved words. Profile or context names must not reuse
them.

The `ready` preparation boundary is documented in
[`docs/ready-concept.md`](docs/ready-concept.md).
`agent-init ready` is the current output-only preparation command, and it may
accept one explicit profile target.

The previous `profile` plus optional `topic` shortcut idea is under review. The
simpler candidate model is a single context name:

```text
agent-init [context]
agent-init ready [context]
```

In this model, `context` means an AI-ready briefing context, not an executable
app, shell activation target, or runtime state transition.

## Semantic Types

```text
inspect     read and report runtime facts
recommend   suggest a profile without switching or activating it
prepare     show a readiness briefing without mutating runtime state
activate    prepare shell/runtime environment
attach      connect to an existing session
switch      change current runtime profile
```

Current MVP implements `inspect`, `recommend`, and `prepare` behavior.

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
agent-init ready     prepare               show readiness briefing
agent-init doctor    inspect               run best-effort diagnostics
agent-init version   inspect               print framework/runtime version
agent-init [context]  placeholder           future preparation shortcut concept
```

Reserved built-ins:

```text
help, doctor, status, list, auto, ready, version
```

## Command Details

### `agent-init help`

Semantic: inspect.

Current behavior:

- Prints current commands.
- Explains the current observer/recommender role.
- Shows the current `ready` briefing command and the future convenience
  shortcut concept.
- Does not inspect private memory.
- Does not write state.

### `agent-init ready`

Semantic: prepare.

Current behavior:

- Shows the framework path.
- Shows the core discovery result.
- Shows discovered profiles.
- Suggests a profile, or reports a requested profile.
- May accept one explicit profile target.
- Shows read-first files, boundary reminders, verification commands, and a
  short task brief skeleton.
- Does not parse or merge recommended files.
- Does not activate a profile.
- Does not write `current-profile`.

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

### `agent-init [context]`

Semantic: placeholder.

Future direction:

- May act as a user-friendly shortcut to a preparation-only `ready` flow.
- May prepare a work context for one named briefing context.
- May be used without arguments as a future default-ready concept.
- Planned shortcut candidate for `agent-init ready [context]`.
- Does not accept multiple context arguments in the current candidate model.

Current stage:

- Not implemented.
- Not a profile activation command.
- Not a shell activation command.
- Not a session restore command.
- Not a `current-profile` write command.
- Does not define `current-profile` write behavior yet.

The shortcut remains documentation-only until a future implementation decision
is made.

## Context Naming Model Candidate

The single context naming model is under consideration to avoid growing a CLI
grammar around profile/topic combinations.

Preferred shape:

```text
agent-init
agent-init python
agent-init python-arch
agent-init infographic
agent-init money-dividend
agent-init faith-nehemiah
agent-init ready python-arch
```

Discouraged shape:

```text
agent-init python arch
agent-init work arch python
agent-init money dividend report
```

Candidate rules:

- A context is one kebab-case name chosen by a human.
- One context name should express one briefing intent.
- A combined context is still one name, such as `python-arch` or
  `money-dividend`.
- Context names should be readable enough that a human can infer the intended
  briefing.
- Overly broad names such as `all`, `misc`, or `general` are discouraged.
- Temporary names such as `temp` or `test-only` are discouraged.
- Over-abbreviated names are discouraged.
- The CLI should not interpret multiple free arguments as context composition.
- The CLI should not automatically parse, merge, or layer context pieces.
- Context names are preparation targets only.
- Context names do not activate profiles, source environment, mutate shell
  state, write `current-profile`, attach sessions, or start orchestration.

Relationship to current profile discovery:

- Current runtime discovery still reads `agent-core/profiles/*`.
- Existing profile directories may continue to be the storage containers for
  named briefing contexts.
- A future rename from `profiles/<name>` to `contexts/<name>` is unresolved and
  should not be implemented until separately decided.

Reserved command note:

- Built-in commands remain reserved.
- Context or profile names must not be `help`, `doctor`, `status`, `list`,
  `auto`, `ready`, or `version`.

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
