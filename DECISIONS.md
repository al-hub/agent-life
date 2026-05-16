# DECISIONS.md

This file records durable decisions. Keep it short and update it when direction
changes.

## Decisions

### 2026-05-16: Split public bootstrap and private brain

`agent-life` is the public repo. It contains bootstrap scripts, CLI framework,
runtime semantics, public docs, and shared command conventions.

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
2. `~/.agent-life/config` key `default-core-path`
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

### 2026-05-16: CLI output is human-oriented diagnostics

`agent-init` uses plain `[OK]`, `[WARN]`, and `[INFO]` labels for readability.
Verbose output may add discovery reasoning, but it must not change behavior.

Reason: current commands are observer/recommender tools, not a stable
machine-readable protocol or runtime control plane.

### 2026-05-16: Bootstrap installs the public framework only

`install.sh` supports external `curl | bash` execution by cloning or updating the
public `agent-life` framework checkout at `~/.agent-life/framework`.

Install means fetch/update and lightweight validation. It does not mean runtime
activation, shell ownership, PATH mutation, shell rc modification, alias
injection, symlink creation, `current-profile` writes, daemon startup, tmux
integration, AGENTS semantic parsing, or profile activation.

Reason: bootstrap ergonomics should improve without turning install into a
runtime controller or hidden shell mutation mechanism.

### 2026-05-16: Bootstrap update semantics are best-effort and reversible

Existing installs are handled with a lightweight `git pull --ff-only` when the
target path is already a git checkout. Failures leave the checkout in place and
ask the user to inspect manually.

Reason: reinstall/update behavior should remain deterministic, transparent,
idempotent, and easy to reverse by removing `~/.agent-life/framework`.

### 2026-05-16: First-run onboarding is diagnostics-first

Quickstart guidance starts with bootstrap, then `agent-init doctor`, then
private `agent-core` connection, `list`, and `auto`.

PATH and `AGENT_CORE_PATH` examples are manual guidance only. The installer does
not write shell configuration or create runtime state.

Reason: first-run UX should be clear and copy-pasteable without turning install
into activation, orchestration, or hidden shell ownership.

### 2026-05-16: Local config is optional preference only

The only local config path is `~/.agent-life/config`.

The current supported key is `default-core-path`, used for core discovery after
`AGENT_CORE_PATH` and before fallback paths. Config is not auto-generated, not
mutated by bootstrap, and not runtime state.

Malformed or unknown config lines may be ignored. There is no strict schema and
no JSON/YAML/TOML config system.

Reason: local preferences improve onboarding without introducing runtime
ownership, activation, session persistence, shell hooks, or hidden mutation.

### 2026-05-16: Core discovery is centralized in an internal helper

`agent-core` discovery semantics live in `lib/core-discovery.sh`, which is
sourced by `agent-init` and `install.sh`.

The helper preserves the existing order: `AGENT_CORE_PATH`,
`~/.agent-life/config` key `default-core-path`, `../agent-core`, then
`~/.agent-core`.

It is a private implementation detail, not a generic framework abstraction,
dynamic provider system, cache, state layer, activation mechanism, or plugin
interface.

Reason: `status`, `doctor`, `list`, `auto`, and bootstrap guidance should
resolve the same core path in the same environment without duplicating logic.

### 2026-05-16: Smoke tests stay POSIX shell and isolated

Regression tests live under `tests/smoke/` and run through
`tests/smoke/run.sh`.

They use POSIX shell scripts and isolated temporary `HOME` directories. They do
not use pytest, bats, TAP, a framework dependency, hidden mutation,
`current-profile` writes, activation, orchestration, daemons, or watchers.

Reason: the current need is lightweight semantic regression coverage for
bootstrap, discovery, `doctor`, `list`, and `auto`, not a full correctness proof
or heavy CI framework.

### 2026-05-16: `agent-init ready` is output-only preparation

`agent-init ready` is implemented as a preparation command that prints a
readiness briefing and does not mutate runtime state.

The future user-facing shortcut `agent-init [profile] [topic]` remains
unimplemented and documented only as a concept.

Reason: the command can be useful without becoming activation, orchestration,
shell ownership, or state persistence.

### 2026-05-16: `ready` MVP acceptance criteria are defined

The `ready` concept now has a minimal boundary and success definition in
`docs/ready-concept.md`, including minimum output, explicit non-goals, and the
rule that recommended files are read-first guidance only.

Reason: implementation should start from an agreed boundary, not from implicit
behavior expansion.

### 2026-05-16: Built-in commands are reserved and profile shortcuts stay conceptual

`help`, `doctor`, `status`, `list`, `auto`, and `version` are reserved built-in
commands. Profile names must not reuse them.

Future user-facing shorthand may be `agent-init [profile] [topic]`, which is a
preparation-only concept for a future `ready` flow. `ready` itself is not
implemented, and profile shortcut semantics are documented only.

Reason: users should not have to memorize a hidden `ready` keyword to understand
the future preparation direction, but current behavior must stay explicit and
free of hidden activation or mutation.

### 2026-05-16: `agent-life` name retained, scope reframed

The project keeps the `agent-life` name, but its public framing is a lightweight
bootstrap framework for preparing AI-ready work contexts, not a development-only
tool and not a full agent controller.

The official concept and identity document is `docs/what-is-agent-life.md`.

Reason: the name can stay stable while the scope is explained more precisely for
new readers and future agents.
