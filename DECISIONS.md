# DECISIONS.md

This file records durable decisions. Keep it short and update it when direction
changes.

## Decisions

### 2026-05-16: Split public bootstrap and private brain

`agent-life` is the public repo. It contains bootstrap scripts, CLI framework,
shell integration, public docs, and shared command conventions.

`agent-core` is the private repo. It contains prompts, memory, RAG, personal
workflows, and domain profiles.

Reason: future AI sessions need stable public runtime structure without exposing
private context.

### 2026-05-16: Use markdown as runtime memory

Markdown files in this repo act as AI-readable persistent context. They should
capture state, decisions, and next actions in a form another agent can execute.

Reason: markdown is portable across ChatGPT, Codex, Claude, local LLMs, GitHub,
and terminal workflows.

### 2026-05-16: CLI name is `agent-init`

The primary CLI entry point is `agent-init`.

Reason: the command expresses session/runtime initialization and leaves room for
profile targets like `develop`, `stock`, and `auto`.

### 2026-05-16: CLI is command-centered

Command means action. Argument means target. Options stay minimal. Complex
configuration belongs in config files.

Reason: the CLI should be human-friendly and easy for agents to invoke without
remembering option-heavy syntax.

### 2026-05-16: `agent-core` is not a submodule by default

`agent-core` is connected as a sibling private repo or through explicit path
configuration. It is not vendored or embedded into `agent-life` by default.

Discovery order:

1. `AGENT_CORE_PATH`
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

Reason: sibling repos preserve the public/private boundary, avoid submodule
friction, and reduce the chance that private memory is treated as public repo
content.

### 2026-05-16: `agent-init` MVP stays bash-only

The first `agent-init` implementation is a simple bash script. It avoids Python
orchestration, tmux control, shell activation, RAG, LLM integration, and session
restore.

Reason: the current goal is to validate the command-centered CLI shape and
runtime boundaries before adding heavier orchestration.

### 2026-05-16: Profiles are discovered, not hardcoded

Profiles are recognized by scanning `agent-core/profiles/*` directories. Public
framework code should not hardcode profile names as behavior.

Reason: private core owns profile inventory and personal context.

### 2026-05-16: Profiles are context workspaces, not apps

A profile is a lightweight workspace for an area of life or work. The minimal
convention is `AGENTS.md`, `prompts/`, `memory/`, `context/`, and `profile.env`.

Reason: the runtime needs shared semantics that humans and AI agents can inspect
without introducing activation, parsing, or a strict schema too early.

### 2026-05-16: Profile contract is convention-first

The current profile contract is a lightweight convention. The MVP recognizes
profiles by directory existence only and does not implement inheritance, merge
logic, shell sourcing, semantic parsing, RAG, or LLM integration.

Reason: current simplicity and human-editable files are more important than
future abstraction.

### 2026-05-16: Memory and state are separate concepts

Memory is persistent context in markdown and repositories. State is local,
ephemeral runtime data under `~/.local/state/agent-life`.

Reason: future agents need durable context, while runtime details should remain
machine-local and disposable.

### 2026-05-16: Current commands are inspection and recommendation only

The MVP command semantics are limited to inspection and recommendation.
`status`, `list`, `help`, and `version` inspect. `auto` recommends. `develop`
and `stock` remain semantic placeholders until activation behavior is designed.

Reason: command meaning should be stable before adding shell activation, tmux,
session restore, state persistence, RAG, or LLM integration.

### 2026-05-16: Shell ownership boundary is explicit

`agent-init` is currently a child-process CLI that inspects and recommends. It
does not mutate the parent shell. Activation, attach, and switch semantics remain
unimplemented and intentionally unresolved.

Reason: a child process cannot directly change parent shell `cwd`, environment,
aliases, functions, or prompt. Future source/eval or shell-wrapper behavior must
be designed explicitly before implementation.

### 2026-05-16: Runtime lifecycle is conceptual, not a strict FSM

The current lifecycle is `discover -> inspect -> recommend`. Future vocabulary
includes `activate`, `attach`, `switch`, `sync`, `restore`, and `shutdown`, but
these stages are placeholders and not execution guarantees.

Reason: lifecycle language should clarify future runtime behavior without
committing to activation, orchestration, state transitions, or shell ownership
too early.

### 2026-05-16: `agent-init doctor` is diagnostics-only

`doctor` is a best-effort observer command. It reports framework, core, profile,
state, git, shell, and `AGENT_CORE_PATH` status without repairing, activating,
switching, syncing, or writing runtime state.

Reason: diagnostics are useful now, but runtime ownership and activation
semantics remain intentionally unresolved.
