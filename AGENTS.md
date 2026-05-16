# AGENTS.md

This file is the operating guide for future AI sessions working in `agent-life`.

Keep this file short, operational, and high-signal.

## Repository identity

`agent-life` is a lightweight public bootstrap framework for preparing AI-ready work contexts.

It is not a full AI agent framework.

It is not a runtime controller.

It is not an orchestrator.

Its current purpose is to help humans and AI start work with clearer context, boundaries, diagnostics, and verification.
It includes the output-only `agent-init ready` briefing command.

For the official concept and identity summary, see `docs/what-is-agent-life.md`.

## Mission

Maintain `agent-life` as the public bootstrap/runtime semantics repository for personal AI workflows.

Keep private memory, prompts, RAG content, account details, and personal workflow content in `agent-core`.

## Public / Private Boundary

Allowed in `agent-life`:

- bootstrap scripts
- public CLI framework
- runtime semantics
- documentation
- shared command conventions
- non-sensitive profile names and interfaces
- minimal non-sensitive sample profile templates
- smoke tests for public behavior

Not allowed in `agent-life`:

- secrets, tokens, API keys, credentials
- private prompts or personal memory
- RAG source material
- financial account details
- faith, travel, development, or personal workflow content
- private repo contents copied from `agent-core`

## Component roles

```text
agent-life   public bootstrap, CLI, runtime semantics, shared conventions
agent-core   private memory, prompts, workflows, profiles
agent-init   lightweight observer/recommender CLI
```

`agent-life` discovers `agent-core`.

It does not own `agent-core`.

It does not store private memory.

## Core principles

Preserve these principles unless an explicit decision changes them.

```text
explicit > magic
install ≠ activation
observer > controller
reversible > ownership
```

## Current scope

Current lifecycle:

```text
discover -> inspect -> recommend
```

Current implemented CLI surface:

```text
agent-init help
agent-init status
agent-init list
agent-init auto
agent-init ready
agent-init doctor
agent-init version
```

Built-in commands are reserved words. They are not profile names.

Future profile shortcut concept:

```text
agent-init [profile] [topic]
```

This is preparation-only and not implemented yet.
Planned shortcut for:

```text
agent-init ready [profile] [topic]
```

The `ready` preparation boundary is documented in
`docs/ready-concept.md`.

Current bootstrap target:

```text
~/.agent-life/framework
```

Current core discovery order:

```text
1. AGENT_CORE_PATH
2. ~/.agent-life/config default-core-path
3. ../agent-core
4. ~/.agent-core
```

## AGENTS.md hierarchy

Root `AGENTS.md` defines repository-wide rules for `agent-life`:

- public/private boundaries
- CLI principles
- runtime scope
- maintenance expectations

Profile `AGENTS.md` files define local behavior for one profile workspace, such as `develop`, `stock`, `faith`, or `travel`.

Current MVP behavior:

- no inheritance logic is implemented
- no merge logic is implemented
- no semantic parsing is implemented
- agents should read root and relevant profile guidance directly

## Working rules

- Preserve user changes.
- Do not revert unrelated edits.
- Prefer small, inspectable changes.
- Keep markdown executable: decisions, state, and next actions should help the next agent continue work.
- When changing architecture, update `DECISIONS.md`.
- When changing current context, update `CONVERSATION.md`.
- When leaving follow-up work, update `NEXT.md`.
- Keep public/private boundaries explicit in docs and code.

## Do not add hidden mutation

Do not add behavior that silently changes:

- PATH
- shell rc files
- aliases
- shell functions
- parent shell state
- current directory
- runtime state
- `current-profile`
- tmux sessions
- daemon/watch processes

Any future mutation must be explicit and documented.

## Do not expand into orchestration without a decision

Do not introduce these without an explicit decision:

- activation
- attach/switch
- source/eval wrappers
- tmux orchestration
- daemon/watcher
- automatic sync
- RAG engine
- LLM integration
- AGENTS.md semantic parsing
- plugin/provider framework
- lifecycle state machine

## CLI rules

`agent-init` follows a human-friendly command model:

- command means action
- argument means target
- options are rare
- complex behavior moves to config files

Current good command shapes:

```text
agent-init help
agent-init status
agent-init list
agent-init auto
agent-init ready
agent-init select <context>
agent-init remove all
agent-init doctor
agent-init version
```

Future possible shape:

```text
agent-init [profile] [topic]
```

Avoid option-heavy commands unless there is a strong reason.

Keep `agent-init` as an observer/recommender plus explicit project-local marker
selection unless an explicit decision changes that.

Profile names must not collide with reserved built-in commands:

```text
help, doctor, status, list, auto, ready, select, remove, version
```

## Profile rule

A profile is not an app.

A profile is a work context.

Examples:

```text
develop   development context
stock     investment analysis context
faith     faith study context
travel    travel planning context
writing   writing/document context
family    family knowledge context
```

`develop` is the first reference profile, not the whole purpose of `agent-life`.

## Implementation defaults

- Default `agent-core` layout is a sibling private repo: `../agent-core`.
- `agent-core` is not a submodule by default.
- Discovery order is `AGENT_CORE_PATH`, `~/.agent-life/config` `default-core-path`, `../agent-core`, `~/.agent-core`.
- Core discovery implementation lives in internal `lib/core-discovery.sh`.
- `install.sh` should be safe to run repeatedly.
- Bootstrap code must not print or persist secrets.

Prefer:

- POSIX shell compatibility
- plain text output
- human-readable diagnostics
- small helper functions
- deterministic behavior
- isolated smoke tests

Avoid:

- unnecessary abstraction layers
- framework-style plugin systems
- logging subsystems
- machine-readable protocols unless explicitly requested
- hidden caches
- automatic repair behavior

## Bootstrap rules

`install.sh` is a lightweight bootstrap fetcher.

It may:

- check for git
- clone or update the public framework
- validate the checkout
- print next steps

It must not:

- edit PATH
- edit shell rc files
- create aliases
- create symlinks automatically
- clone private repos automatically
- write secrets
- activate profiles
- start daemons
- attach sessions

## Testing rules

Use lightweight smoke tests for regression protection.

Run:

```sh
sh tests/smoke/run.sh
```

Smoke tests should remain:

- POSIX shell based
- deterministic
- isolated with temporary HOME
- free of hidden mutation
- free of activation/orchestration

Do not add pytest, bats, TAP, or heavy CI unless explicitly decided.

## Output rules

CLI output is for humans.

Use simple diagnostic prefixes:

```text
[OK]
[WARN]
[INFO]
```

Do not treat current output as a stable machine-readable protocol.

Do not add JSON/YAML output modes unless explicitly decided.

## Documentation rules

Markdown files are AI-readable runtime memory.

Update the relevant files after meaningful changes:

```text
DECISIONS.md      durable architecture decisions
NEXT.md           next concrete actions
CONVERSATION.md   executable conversation context
README.md         public entry point
docs/*            focused conceptual or operational docs
```

Keep documentation focused.

Do not create long documents when a short boundary note is enough.

## Ready concept

A future command may be:

```text
agent-init ready
agent-init ready <profile>
```

Its intended meaning:

```text
prepare the current work context before AI starts working
```

It must remain preparation-only unless a future decision changes that.

```text
ready ≠ activate
ready ≠ attach
ready ≠ shell mutation
ready ≠ orchestration
```

## Decision discipline

When adding or changing behavior, ask:

```text
Does this preserve explicit behavior?
Does this avoid hidden ownership?
Does this keep agent-init as observer/recommender?
Does this help current workflows now?
Is this avoiding premature abstraction?
Can this be verified with a lightweight smoke test?
```

If the answer is unclear, prefer documentation or a smaller diagnostic step before implementation.

## Session handoff

Before ending substantial work, leave the repo in a state where another agent can answer these questions quickly:

- What is this repo for?
- What has already been decided?
- What is the next concrete action?
- Where is private context expected to live?
- What commands should exist and what should they do?
