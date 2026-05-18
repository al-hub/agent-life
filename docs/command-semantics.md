# Command Semantics

`agent-init` commands are intentionally simple. The current MVP is centered on
inspection, discovery, and explicit project-local context connection, not
activation.

`agent-life` supports project-local AI context switching: connecting a selected
private or public context to the current project's AI instruction surface
through explicit, reversible marker-block edits.

Built-in commands are reserved words. Profile or context names must not reuse
them.

The `ready` preparation boundary is documented in
[`docs/ready-concept.md`](docs/ready-concept.md).
The decided target meaning is that `agent-init ready <context>` previews the
same marker block that `select` would write, without modifying files.

The project-local AGENTS marker block specification is documented in
[`docs/marker-block.md`](docs/marker-block.md).

The previous `profile` plus optional `topic` shortcut idea is replaced by a
single context name:

```text
agent-init <context>
agent-init ready <context>
```

In this model, `context` means one AI-ready context connection, not an
executable app, shell activation target, or runtime state transition.

The decided target meaning is:

```text
agent-init ready <context>   preview the context marker block on stdout
agent-init select <context>  write/update that marker block in project AGENTS.md
agent-init <context>         shortcut for agent-init select <context>
agent-init remove all        remove only the agent-life marker block
agent-init status            inspect the current project marker block
```

The marker block is the canonical representation of an `agent-life` context
connection. It is a small reference window into the resolved context source,
not a copy of private or public context.

Context discovery is hybrid:

- Private contexts are discovered from `agent-core/profiles/*`.
- Public contexts are discovered from `agent-life/profiles/*`.
- Private contexts override public contexts with the same name.
- Public contexts act as fallback/default reusable contexts for fresh installs
  without a private `agent-core`.
- The selected marker block references the resolved actual source path, whether
  that source is private or public.

## Semantic Types

```text
inspect      read and report runtime facts
recommend    suggest a profile without switching or activating it
preview      print the marker block that would connect a context
select       connect a context reference to the current project's AI instructions
shortcut     shorthand for a longer explicit command
remove       remove only the agent-life project-local marker block
update       update the public agent-life framework checkout
ui           thin interactive wrapper around existing commands
activate     prepare shell/runtime environment
attach       connect to an existing session
switch       change current runtime profile
```

Current MVP implements `inspect`, `recommend`, `select`, `remove`, the bare
context shortcut, and marker-block preview for `ready <context>`.

It does not implement update, activation, attach, switch, shell mutation, tmux
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
command                  semantic      behavior
agent-init help          inspect       show command surface
agent-init status        inspect       report framework/core/state/profiles and selected context status
agent-init list          inspect       list discovered profiles
agent-init auto          recommend     suggest a profile when unambiguous
agent-init ready         preview       show default readiness information
agent-init ready <ctx>   preview       print marker block preview, no file mutation
agent-init <ctx>         shortcut      shortcut for agent-init select <ctx>
agent-init select <ctx>  select        select one project-local context
agent-init remove all    remove        remove project-local marker block
agent-init doctor        inspect       run best-effort diagnostics
agent-init version       inspect       print framework/runtime version
agent-init update        placeholder   future framework update command
agent-init fzf           ui            one-page context selector with fzf
```

Reserved built-ins:

```text
help, doctor, status, list, auto, version, ready, select, remove, update
```

## Command Details

### `agent-init help`

Semantic: inspect.

Current behavior:

- Prints current commands.
- Explains the current observer/recommender role.
- Shows the current `ready`, `select`, and `remove` command surface.
- May describe the documented bare context shortcut target once implemented.
- Does not inspect private memory.
- Does not write state.

### `agent-init ready`

Semantic: preview.

Current behavior:

- With no context argument, shows the existing readiness briefing.
- With one context argument, previews the exact marker block that
  `agent-init select <context>` would write.
- Prints the marker block to stdout.
- Shares marker block generation logic with `select` so preview and write
  behavior do not drift.
- Does not parse or merge recommended files.
- Does not activate a profile.
- Does not write `current-profile`.
- It does not modify `AGENTS.md` or any other file.
- It does not activate a profile, source environment, write `current-profile`,
  start sessions, or copy/merge `agent-core` files.

### `agent-init status`

Semantic: inspect.

Current behavior:

- Finds the framework path.
- Discovers `agent-core`.
- Reports local state path.
- Reports discovered profile names.
- Supports `--verbose` for additional checks.

It does not activate a profile or write `current-profile`.

Project-local behavior:

- Shows whether the current project has an `agent-life` marker block in
  `AGENTS.md`.
- Shows the selected context name and referenced files from that marker
  block.
- Shows the current project path.
- Shows whether project `AGENTS.md` exists.
- Shows `selected context: none` when no complete marker block exists.
- Shows a context source path when a selected context is present.
- Warns when the selected context source path is missing.
- Does not repair, select, remove, refresh, or rewrite the marker block.
- Does not inspect or modify content outside the marker block.

Project-local status output:

```text
Framework: <framework-path>
Core: <core-path or not found>
Project: <current-project-path>
Project AGENTS.md: found | missing
Agent-life marker block: found | missing | malformed
Selected context: <context> | none
Context source: <agent-core>/profiles/<context>/AGENTS.md | none
Warnings:
- selected context source missing: <path>
```

This is human-readable output, not a stable output protocol.

### `agent-init list`

Semantic: inspect.

Current behavior:

- Discovers private contexts from `agent-core/profiles/*`.
- Discovers public contexts from `agent-life/profiles/*`.
- Treats non-hidden directories as profile names.
- Merges by context name, with private contexts overriding public contexts.
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

### `agent-init <context>`

Semantic: shortcut.

Decided target behavior:

- `agent-init <context>` is a shortcut for `agent-init select <context>`.
- It writes or updates the same project-local `AGENTS.md` marker block as
  `select`.
- It accepts one context name only.
- It is not used when `<context>` is a reserved command.
- Reserved command names keep their command meaning.

Current stage:

- Implemented as routing to `select_context`.
- Not a profile activation command.
- Not a shell activation command.
- Not a session restore command.
- Not a `current-profile` write command.
- Does not copy or merge private `agent-core` content.

The shortcut delegates to the existing select handler rather than reimplementing
marker block logic.

### `agent-init select <context>`

Semantic: select.

Current behavior:

- Connects one selected resolved context to the current project.
- For the Codex MVP target, writes or refreshes only an `agent-life` marker
  block in the current project's `AGENTS.md`.
- The marker block contains read-first references to the selected context,
  not copied or merged private content.
- The marker block is the canonical context connection representation.
- The marker block is a window, not a copy.
- Marker block tokens, insertion, update, and rollback rules are defined in
  [`docs/marker-block.md`](docs/marker-block.md).
- Replaces only the previous `agent-life` marker block when changing selected
  context.
- Creates a project-local selection reference, not a runtime activation.
- Resolves `<context>` through private then public discovery.
- Requires either `agent-core/profiles/<context>/AGENTS.md` or
  `agent-life/profiles/<context>/AGENTS.md` to exist.
- Does not activate a profile.
- Does not write `current-profile`.
- Does not source environment or mutate shell state.
- Does not copy, merge, or persist private or public context files into the
  project.
- Does not modify content outside the `agent-life` marker block.
- Refuses malformed or duplicate marker blocks and asks for manual repair.

### `agent-init remove all`

Semantic: remove.

Current behavior:

- Removes only the `agent-life` marker block from the current project's
  `AGENTS.md`.
- Leaves all user-authored AGENTS content untouched.
- May delete `AGENTS.md` only when the file was marker-only, as defined by
  [`docs/marker-block.md`](docs/marker-block.md).
- Does not delete or modify `agent-core`.
- Does not change shell, runtime state, sessions, or profile activation.
- Refuses malformed or duplicate marker blocks and asks for manual repair.
- Currently supports only the explicit form `agent-init remove all`.

### `agent-init update`

Semantic: placeholder for public framework update.

Future direction:

- Updates only the public `agent-life` framework checkout.
- Uses the same safe update model as bootstrap: an existing framework checkout
  may be updated with best-effort `git pull --ff-only`, or the user may rerun
  `install.sh`.
- Preserves shell integration unless the user explicitly requests a shell
  integration change through an explicit option or installer flow.
- Does not change the selected context.
- Does not create, update, refresh, or remove project `AGENTS.md` marker
  blocks.
- Does not update, clone, fetch, or modify private `agent-core`.
- Does not copy or merge `agent-core` files.
- Does not mutate shell rc files unless an explicit shell integration option is
  used.

Out of scope for this command:

- `agent-core` update. A future separate command such as
  `agent-init core update` may be considered later.
- Marker block refresh. A future explicit command should be designed separately
  if marker refresh becomes necessary.

Current stage:

- Not implemented.

### `agent-init fzf`

Semantic: optional interactive selector UI.

Current behavior:

- Shows discovered contexts in an `fzf` list.
- Lets the user search context names.
- Shows a preview window powered by `agent-init ready <context>`.
- Pressing Enter runs `agent-init select <context>`.
- Pressing Esc quits without changing project files.
- Acts as a thin wrapper around existing `agent-init` commands.
- Uses `agent-init list --tsv` as the list source.
- Uses the first TSV column as the context name.
- Treats the second TSV column as display-only description text.

Required command foundations:

- `agent-init list --tsv` for machine-friendly context rows.
- `agent-init ready <context>` for marker block preview.
- `agent-init select <context>` for project-local selection.

Example:

```sh
agent-init fzf
```

When `fzf` is not installed, the command prints fallback commands and exits
without changing files:

```text
agent-init list
agent-init ready <context>
agent-init select <context>
agent-init remove all
```

Description convention:

- A context may include a lightweight line-based description in its
  `AGENTS.md`.
- The description line shape is:

```text
Description: short human-readable context summary
```

- If no `Description:` line exists, the description may be empty or `-`.
- Do not introduce YAML, TOML, frontmatter, or heavy metadata for the MVP.

Out of scope for MVP:

- `ctrl-r` remove all.
- `ctrl-s` status. This can conflict with terminal flow control.
- Rename or profile directory mutation.
- Alias management.
- Multi-select.
- Context merge or layering.
- `y/N/all` confirmation UI.
- Command palette behavior.
- `agent-core` mutation.

Boundary:

- `fzf` is not a new execution engine.
- `fzf` must not change selected context except by invoking
  `agent-init select <context>`.
- Remove/status remain explicit commands in the MVP.
- Destructive actions such as `remove all` remain explicit commands.
- It must not mutate shell state, write `current-profile`, start tmux/session
  orchestration, run daemons, or integrate RAG/LLM behavior.

Deferred follow-up candidates:

- `agent-init show <context>` if `ready <context>` becomes too verbose for fzf
  preview.
- remove/status keybindings if the UI can avoid destructive surprises and
  terminal keybinding conflicts.
- alias support if alternate context names are needed without renaming private
  `agent-core` directories.
- multi-select or context merge only after explicit precedence and conflict
  semantics are designed.

Rename remains excluded because it can mutate private `agent-core` directory
names and break existing marker block or human references.

Current stage:

- Implemented for search, preview, and select only.

## Context Naming Model

The single context naming model is the chosen direction for the bare shortcut.
It avoids growing a CLI grammar around profile/topic combinations.

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

Rules:

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
- Context names are project-local context connection targets.
- Context names do not activate profiles, source environment, mutate shell
  state, write `current-profile`, attach sessions, or start orchestration.

Relationship to current profile discovery:

- Current runtime discovery reads private `agent-core/profiles/*` and public
  `agent-life/profiles/*`.
- Existing profile directories may continue to be the storage containers for
  named briefing contexts.
- Public `agent-life/profiles/*` directories are fallback/default runtime
  contexts.
- Precedence is private first, public second.
- Name collisions resolve to the private context.
- A future rename from `profiles/<name>` to `contexts/<name>` is unresolved and
  should not be implemented until separately decided.

Reserved command note:

- Built-in commands remain reserved.
- Context or profile names must not be `help`, `doctor`, `status`, `list`,
  `auto`, `version`, `ready`, `select`, `remove`, `fzf`, or `update`.

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

## Project-Local Marker Policy

Project-local context selection may mutate the current project's
`AGENTS.md`, but only under these constraints:

- The command must be explicit, such as `agent-init select <context>`.
- The mutation must be reversible through `agent-init remove all`.
- The mutation must be project-local, not global.
- The command may edit only the `agent-life` marker block.
- The marker block may contain references to read first, not copied private
  content.
- The command must not modify user-authored content outside the marker block.
- The command must not write `current-profile`, activate profiles, source
  environment, mutate shell state, start sessions, or run daemons.
- Detailed token, insert, update, remove, and remove-all rules live in
  [`docs/marker-block.md`](docs/marker-block.md).

Proposed Codex MVP marker target:

```text
<current-project>/AGENTS.md
```

This policy is documentation-only until implementation is separately decided.

State file formats are intentionally not strict yet.
