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

### 2026-05-16: `agent-init ready` started as output-only preparation

`agent-init ready` is implemented as a preparation command that prints a
readiness briefing and does not mutate runtime state. It may accept one
explicit profile target, but it does not activate profiles or write
`current-profile`.

This was the original ready MVP. It is superseded for future target semantics
by the 2026-05-17 marker-block preview decision below.

Reason: the command can be useful without becoming activation, orchestration,
shell ownership, or state persistence.

### 2026-05-16: `ready` MVP acceptance criteria are defined

The `ready` concept now has a minimal boundary and success definition in
`docs/ready-concept.md`, including minimum output, explicit non-goals, and the
rule that recommended files are read-first guidance only.

Reason: implementation should start from an agreed boundary, not from implicit
behavior expansion.

### 2026-05-16: Built-in commands are reserved

`help`, `doctor`, `status`, `list`, `auto`, and `version` are reserved built-in
commands. Profile names must not reuse them.

This was later expanded to include `ready`, `select`, `remove`, and `update` as
reserved command names.

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

### 2026-05-16: MVP stabilization checkpoint reached

The current MVP is stable enough to document as a usable public bootstrap
surface: curl/bootstrap install, core discovery, built-in observer commands,
output-only `ready`, profile-aware `ready <profile>`, and lightweight smoke
tests are all in place.

The intentionally deferred areas remain deferred: shortcut implementation,
marker-block preview implementation, `current-profile` writes, activation,
shell/env mutation, source/eval wrappers, tmux/session orchestration,
daemons/watchers, AGENTS/NEXT/DECISIONS parsing or merging, and RAG/LLM
integration.

Reason: the checkpoint clarifies what is safe to use now versus what must stay
as a later decision boundary.

### 2026-05-16: Explicit shell integration is consent-based and reversible

`install.sh` may register or remove a marker block in bash or zsh rc files when
the user explicitly consents. The marker block is the only shell rc content
managed by `agent-life`, and it is limited to PATH and completion source lines.

The default bootstrap remains safe: if the shell cannot be detected or the user
declines, the installer prints guidance and leaves shell rc files untouched.

For `curl | bash`, the interactive consent prompt reads from `/dev/tty` when
available because stdin is occupied by the script stream. If no interactive
terminal input is available, shell integration must be requested explicitly with
`AGENT_LIFE_SHELL_INTEGRATION=yes` or `--shell-integration`.

After registration, users must source the target rc file, such as
`source ~/.zshrc` or `source ~/.bashrc`, or open a new terminal before the bare
`agent-init` command is available in the current shell.

Reason: pathless `agent-init` access and completion support are useful, but the
project still must avoid hidden shell ownership and keep rc edits reversible.

### 2026-05-16: Single context naming model chosen

The previous future shortcut shape `agent-init [profile] [topic]` is replaced
by a simpler single-context model:

```text
agent-init <context>
agent-init ready <context>
```

In this model, combinations are named by humans as one kebab-case
context, such as `python-arch`, `money-dividend`, or `faith-nehemiah`. The CLI
does not interpret multiple free arguments like `agent-init python arch` as
context composition.

Current runtime behavior is unchanged. `profiles/<name>` remains the discovered
private directory structure and can be understood as the current container for a
named context. No `contexts/` rename, shortcut implementation, activation,
shell/env mutation, `current-profile` write, orchestration, or automatic
parsing/merging is implemented.

Reason: a single context name keeps the user-facing preparation model simpler
than a profile/topic grammar while preserving the existing private profile
container until a storage decision is made.

### 2026-05-16: Context names use readable kebab-case

Future context shortcut planning should use readable kebab-case names. One
context name should express one briefing intent. Combined meanings should be
named as one context, such as `python-arch`, `money-dividend`, or
`travel-yeosu`, rather than passed as multiple CLI arguments.

Reserved built-in commands must not be used as context names: `help`, `doctor`,
`status`, `list`, `auto`, `version`, and `ready`.

Overly broad names such as `all`, `misc`, or `general`, temporary names such as
`temp` or `test-only`, and names that are too abbreviated to read should be
avoided.

This is a naming convention only. It does not implement `agent-init <context>`,
multi-context parsing, `contexts/` directories, runtime behavior changes,
activation, shell/env mutation, `current-profile` writes, orchestration, or
automatic parsing/merging.

Reason: context names need to be easy for humans and agents to infer without
turning the CLI into a composition language.

### 2026-05-16: `repo-review` is the first public sample context

The first practical public sample context is `repo-review`.

Candidates considered:

```text
repo-review
python-arch
work
cli-review
```

Reason: it is specific enough to follow the context naming convention, useful
for evaluating `agent-life` itself, and better suited than broad names like
`work` or development-only names like `develop` for baseline-vs-ready review
experiments.

The sample lives under `profiles/repo-review/` to preserve the existing profile
directory structure. It is a public-safe briefing context only. It does not
implement `agent-init <context>`, change `ready`, activate profiles, write
`current-profile`, mutate shell/env state, start orchestration, or parse/merge
context automatically.

### 2026-05-16: Evaluation stays lightweight and manual

Baseline-vs-ready evaluation is documented as a manual workflow in
`docs/evaluation.md`.

The first scenario compares ordinary AI CLI use against AI CLI use after
providing `agent-init ready repo-review` output for `agent-life` self-review.
The final task prompt must remain exactly the same in both flows; the intended
difference is only the presence or absence of ready context.

This is not an automatic benchmark. It does not run AI CLIs, automate scoring,
add a benchmark framework, integrate LLM/RAG behavior, change runtime behavior,
change `ready`, implement `agent-init <context>`, or treat public sample
profiles as automatic runtime contexts.

Reason: the project needs a practical way to inspect whether ready context
improves answers before adding automation or shortcut behavior.

### 2026-05-16: Project-local marker block selection direction

Direction: extend `agent-life` from ready-only briefing toward an explicit
project-local AI context switcher.

In this model, `agent-life` connects a selected `agent-core` context to the
current project's AI instruction surface. For the Codex MVP target, the surface
is the current project's `AGENTS.md` file.

The `select` command writes or refreshes only an `agent-life` marker block with
read-first references to the selected context. The `remove all` command removes
only that marker block. The `status` command reports the current project's
selected context state.

This is not profile activation, not a `current-profile` write, not shell/env
mutation, not tmux/session orchestration, not daemon/watch behavior, and not
`agent-core` file copying or merging.

Reason: project-local marker block selection may make AI tools pick up the
right context repeatedly while preserving the existing principles:
`explicit > magic`, `observer > controller`, and `reversible > ownership`.

### 2026-05-16: Project-local AGENTS marker block format

Future `agent-init select` and `agent-init remove` should use the marker block
specified in `docs/marker-block.md`.

The project-local tokens are:

```text
<!-- agent-life:start -->
<!-- agent-life:end -->
```

Future selection may append or replace only that marker block in the current
project's `AGENTS.md`. Future removal may remove only that marker block. If a
future selection created an `AGENTS.md` containing only the marker block and
whitespace, removal may delete the file as rollback. If any content exists
outside the marker block, the file must remain.

The initial implementation now follows this specification for the Codex
`AGENTS.md` target only. It does not add automatic parsing/merging, profile
activation, `current-profile` writes, shell/env mutation, orchestration, or
`agent-core` content copying.

Reason: the select/remove behavior needs a precise, reversible file boundary
before implementation is considered.

### 2026-05-16: Implement project-local select/remove MVP

`agent-init select <context>` is implemented for one selected context. It
requires `agent-core/profiles/<context>/AGENTS.md` to exist, then writes or
refreshes only the `agent-life` marker block in the current project's
`AGENTS.md`.

`agent-init remove all` is implemented as marker-only rollback. It removes only
the marker block, and deletes `AGENTS.md` only when the file contains nothing
except the marker block and whitespace.

`agent-init status` now reports project path, project `AGENTS.md` presence,
marker block state, selected context, context source path, and a warning when
the referenced source is missing.

Malformed or duplicate marker tokens cause select/remove to refuse mutation and
require manual repair.

This MVP intentionally does not support multiple contexts, context merging,
priority rules, `current-profile`, Claude/Copilot targets, non-AGENTS targets,
AI CLI handoff, RAG/LLM integration, profile activation, shell/env mutation,
tmux/session orchestration, daemons, or watchers.

Reason: the marker-block boundary is specific enough to implement safely while
preserving existing project guidance outside the marker block.

### 2026-05-17: Bare context shortcut maps to select

The marker block is the canonical representation of an `agent-life` context
connection.

`agent-init ready <context>` is defined as a dry-run marker block preview. It
prints the same marker block that `select` would write, but does not mutate
files.

`agent-init select <context>` writes or updates that marker block in the
current project's `AGENTS.md`.

`agent-init <context>` is defined as a shortcut for
`agent-init select <context>`, not for `ready <context>`.

Reserved command names keep their command meaning and must not be treated as
context shortcuts: `help`, `doctor`, `status`, `list`, `auto`, `version`,
`ready`, `select`, `remove`, and `update`.

This decision preserves the no-hidden-mutation philosophy by allowing only
explicit, reversible, project-local marker-block mutation. It does not add
activation, shell/env mutation, `current-profile`, tmux/session orchestration,
daemon/watch behavior, RAG/LLM integration, or `agent-core` content copying.

Reason: users need a short command for the common context switching path, while
the durable representation should remain the same small marker block. The
marker block is a window, not a copy.

### 2026-05-17: Update scope starts with public framework only

`agent-init update` is reserved for a future public `agent-life` framework
update command.

The initial scope should update only the public framework checkout, likely by
wrapping the existing safe bootstrap update behavior or instructing the user to
rerun `install.sh`. Existing shell integration should remain in place unless
the user explicitly requests a shell integration change.

`agent-init update` must not change selected context, write or refresh project
`AGENTS.md` marker blocks, update private `agent-core`, copy or merge
`agent-core` files, mutate shell rc files implicitly, activate profiles, write
`current-profile`, or start orchestration.

Private `agent-core` update remains deferred. If needed, it should be designed
later as a separate explicit command, for example `agent-init core update`,
because private repositories may contain sensitive or workflow-specific state.

Reason: framework update and private core update have different risk profiles.
The public framework can use a reversible git update model; private core update
must stay user-owned until a separate boundary is designed.
