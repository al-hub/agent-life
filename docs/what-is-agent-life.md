# What is agent-life?

This is the official concept and identity document for `agent-life`.

`agent-life` is a lightweight public bootstrap framework and project-local AI
context switcher for preparing AI-ready work contexts.

It helps a human and AI start work with clearer context, boundaries, diagnostics, and verification.

It is not limited to development.

Development is the first reference use case.

The same structure can support other personal workflows such as investing, faith study, writing, travel planning, and family knowledge.

## One-sentence definition

`agent-life` prepares the working context before AI starts working and can, in a
project-local explicit flow, connect a selected private context to the current
project's AI instruction surface.

## Shorter definition

```text
agent-life = public bootstrap + runtime semantics + project-local context selection
agent-core = private memory + prompts + workflows + profiles
agent-init = observer/recommender CLI
```

## Why agent-life exists

AI tools can generate code, text, and analysis quickly.

But without enough context, they often guess:

- the goal
- the boundary
- the correct profile
- the verification method
- what should not be changed

That guessing can cause unnecessary expansion.

Examples:

- a small script becomes a framework
- a diagnostic command becomes an auto-fixer
- a profile becomes an activation engine
- a bootstrap script starts owning the shell
- a development workflow becomes a general orchestration system before it is needed

`agent-life` exists to make the beginning of work clearer.

It helps prepare the context before AI starts.

## The real problem

The problem is not only that AI may produce bad code.

The deeper problem is that AI may work from unclear meaning.

When the meaning is unclear, AI may still produce something that looks useful.

But it may be pointed in the wrong direction.

`agent-life` tries to reduce that ambiguity.

It does this by preparing:

- context
- boundary
- diagnostics
- next actions
- verification

## Existing way vs agent-life way

### Existing way

```text
enter workspace
-> open AI CLI
-> ask a broad question
-> AI guesses goal/boundary/tests
-> suggestions may expand too widely
```

### agent-life way

```text
enter workspace
-> inspect readiness
-> discover relevant private context
-> check diagnostics
-> clarify boundaries
-> start AI work with better context
```

The goal is not to make AI magically smarter.

The goal is to help AI start with fewer wrong assumptions.

## What agent-life does

`agent-life` helps with several preparation tasks.

### Bootstrap

It installs or updates the public framework.

```text
~/.agent-life/framework
```

### Discovery

It discovers private `agent-core` context.

Discovery order:

```text
1. AGENT_CORE_PATH
2. ~/.agent-life/config default-core-path
3. ../agent-core
4. ~/.agent-core
```

### Diagnostics

It reports readiness using commands such as:

```text
agent-init doctor
agent-init status
agent-init list
agent-init auto
```

### Project-local context selection

Future `select` and `remove` commands may connect or disconnect a selected
`agent-core` context from the current project.

For the Codex MVP target, the proposed instruction surface is the current
project's `AGENTS.md` file. Selection would write only an explicit
`agent-life` marker block containing read-first references to the selected
context.

This is not profile activation. It does not source environment, write
`current-profile`, copy `agent-core` files, merge private memory, or start any
session/orchestration behavior.

### Runtime semantics

It defines current behavior and boundaries.

Examples:

```text
install ≠ activation
observer > controller
explicit > magic
reversible > ownership
```

### Documentation

It keeps AI-readable project context in markdown.

Examples:

```text
AGENTS.md
DECISIONS.md
NEXT.md
CONVERSATION.md
docs/*
```

### Regression protection

It uses lightweight smoke tests to prevent core behavior from drifting.

```sh
sh tests/smoke/run.sh
```

## What agent-life does not do

`agent-life` does not:

- own your shell
- modify PATH automatically
- edit shell rc files automatically
- activate profiles automatically
- attach tmux sessions
- run daemons
- watch files in the background
- store private memory in the public repo
- replace human judgment
- perform hidden automation
- mutate project files outside an explicit `agent-life` marker block

This is intentional.

`agent-life` prepares the work context.

It does not take ownership of the work environment.

## agent-life and agent-core

`agent-life` and `agent-core` have different responsibilities.

| Component | Role | Visibility |
|---|---|---|
| `agent-life` | public bootstrap, CLI, runtime semantics | Public |
| `agent-core` | private memory, prompts, workflows, profiles | Private |
| `agent-init` | observer/recommender CLI | Public command |

`agent-life` discovers `agent-core`.

It does not own it.

It does not clone it automatically.

It does not store private memory.

## Why public and private are separated

The public layer should be shareable.

The private layer should remain personal.

Public:

```text
install.sh
agent-init
runtime semantics
docs
smoke tests
profile conventions
```

Private:

```text
personal prompts
memory
investment notes
faith notes
family context
workflow-specific profiles
private RAG materials
```

This separation allows the framework to be public while keeping personal context private.

## Profiles are work contexts

A profile is not an app.

A profile is a work context.

Examples:

| Profile | Meaning |
|---|---|
| `develop` | code, documentation, tests, engineering tasks |
| `stock` | investment analysis, watchlists, valuation context |
| `faith` | scripture study, faith notes, expression rules |
| `travel` | itinerary planning, places, preferences, constraints |
| `writing` | essays, summaries, drafts, documents |
| `family` | family knowledge, shared records, preferences |

`develop` is the first reference profile.

It is not the whole purpose of `agent-life`.

## What agent-init currently does

Current commands:

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

Current lifecycle:

```text
discover -> inspect -> recommend
```

Current role:

```text
agent-init = lightweight observer/recommender
```

It does not currently activate, attach, switch, sync, restore, or orchestrate.
It also includes the output-only `agent-init ready` preparation briefing.

## Future ready concept

The boundary and meaning of `ready` are documented in
[`docs/ready-concept.md`](docs/ready-concept.md).

At a high level, `ready` is a preparation flow for AI work contexts.
It is not implemented in the current MVP.

## Why non-goals matter

AI tends to expand.

That expansion is not always bad, but uncontrolled expansion creates maintenance problems.

Good non-goals reduce that risk.

Examples:

```text
Do not add activation in this step.
Do not mutate shell state.
Do not introduce a daemon.
Do not create a plugin framework.
Do not parse AGENTS.md semantically yet.
```

The point is not to block future work.

The point is to prevent accidental work.

## Why documentation matters here

In traditional projects, code often becomes the main source of truth.

In AI-assisted projects, markdown context becomes more important.

It tells future agents:

- what the project is
- what the current scope is
- what decisions have already been made
- what not to change
- what to verify next

This is why `agent-life` treats markdown as AI-readable runtime memory.

## Current maturity

`agent-life` is currently a lightweight operational skeleton.

It already has:

- curl-based bootstrap
- deterministic install location
- observer/recommender CLI
- shared core discovery helper
- optional local config semantics
- quickstart onboarding
- smoke tests
- runtime boundary documentation

It intentionally does not yet have:

- activation
- attach/switch
- daemon
- automatic sync
- tmux orchestration
- RAG engine
- LLM integration
- profile activation

## How to think about agent-life

Do not think of `agent-life` as:

```text
a big AI framework
```

Think of it as:

```text
a preparation layer for AI-assisted work
```

Or:

```text
a lightweight operating manual + bootstrap layer for personal AI workflows
```

## Summary

`agent-life` is not a tool that makes AI do the work automatically.

It is a lightweight operational workspace framework that prepares the context in which AI tools can work more safely, coherently, and repeatably.

It helps AI start with less guessing.

It helps humans keep ownership.

It keeps private memory private.

It keeps automation explicit.

It keeps future expansion possible without letting it happen accidentally.
