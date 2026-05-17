# agent-life

`agent-life` is a lightweight public bootstrap framework and project-local AI
context switcher for preparing AI-ready work contexts across personal workflows
such as development, investing, faith study, writing, travel, and family
knowledge.

It gives ChatGPT, Codex, Claude, and local LLM sessions a stable repository-based runtime they can inspect, update, and hand off through.

Private memory, prompts, RAG material, personal workflows, and profile-specific context live outside this public repository in `agent-core`.

For the concept and identity of this project, see [`docs/what-is-agent-life.md`](docs/what-is-agent-life.md).
For the `ready` preparation command, see [`docs/ready-concept.md`](docs/ready-concept.md).
For a project-local context switching demo, see [`docs/demo-context-switching.md`](docs/demo-context-switching.md).
For manual baseline-vs-ready evaluation, see [`docs/evaluation.md`](docs/evaluation.md).

## One-sentence definition

`agent-life` prepares the working context before AI starts working and, in a
project-local explicit flow, can connect a selected private context to the
current project's AI instruction surface.

It is a public framework for:

- discovering private context
- reporting current readiness
- selecting project-local AI context through explicit marker blocks
- preserving lightweight runtime semantics
- preventing hidden mutation
- guiding the next safe step

## Repository Roles

```text
agent-life   public bootstrap, CLI, runtime semantics, shared commands
agent-core   private prompts, memory, RAG, personal workflows, profile context
agent-init   lightweight observer/recommender CLI
```

Default layout:

```text
~/workspace/
  agent-life/
  agent-core/
```

`agent-core` is discovered by path, config, or environment.

It is not a git submodule by default.

`agent-life` discovers `agent-core`.

It does not own `agent-core`.

It does not clone private repositories, write secrets, install private memory, or activate profiles.

Project-local selection means linking a context reference into the current
project's AI instruction surface. For Codex, the MVP surface is the current
project's `AGENTS.md` marker block. This is not profile activation and does not
copy or merge `agent-core` files.

The marker block is a window, not a copy. It points the AI toward the selected
`agent-core` context without copying private context into the project.

## Why agent-life exists

Without preparation, AI tools often start by guessing:

- What is the goal?
- What should not be changed?
- Which context matters?
- Which profile or workflow is relevant?
- Which tests or checks matter?
- Is this a development task, investment analysis, faith study, travel plan, writing task, or family knowledge task?

When those questions are unclear, AI may produce useful-looking suggestions that expand too broadly.

`agent-life` exists to make the starting point clearer.

It helps prepare:

- context: which profile or workflow is relevant
- boundary: what should not be changed automatically
- diagnostics: what is missing or misconfigured
- next actions: what the human or AI should inspect next
- verification: what should be checked before and after work

The point is not to make AI magically smarter.

The point is to help AI start with fewer wrong assumptions.

## What agent-life is

`agent-life` is:

- a public bootstrap layer
- a lightweight operational workspace framework
- a place for shared runtime semantics
- a CLI surface for readiness inspection
- a bridge between public framework and private context
- a project-local context switcher for AI instruction files
- a way to make future AI sessions continue work without guessing

## What agent-life is not

`agent-life` is not:

- a full AI agent framework
- a daemon or background service
- a shell owner
- a tmux/session orchestrator
- a private memory store
- an automatic activator
- a replacement for human judgment

It does not silently mutate your shell, PATH, aliases, runtime state, or profile activation.
Explicit shell integration is optional, consent-based, and marker-block reversible.
Project-local context selection follows the same rule: only explicit,
reversible marker-block edits in the current project are allowed, and only
inside the `agent-life` marker block.

## Core philosophy

```text
explicit > magic
install ≠ activation
observer > controller
reversible > ownership
```

These principles apply across all profiles, not just development.

## Runtime Idea

This repo treats markdown files as AI-readable runtime memory.

The goal is not to store full transcripts.

The goal is to preserve enough structured context for a future human or AI session to continue work without guessing.

Important files:

- `README.md` explains the public framework.
- `AGENTS.md` defines rules for future agent sessions.
- `CONVERSATION.md` preserves executable conversation context.
- `DECISIONS.md` records durable architecture decisions.
- `NEXT.md` lists the next concrete actions.
- `docs/what-is-agent-life.md` explains the concept and identity.
- `docs/architecture.md` explains the runtime model.
- `docs/bootstrap.md` defines external bootstrap and install semantics.
- `docs/quickstart.md` defines first-run onboarding.
- `docs/shell-integration.md` defines explicit marker-block shell integration.
- `docs/config.md` defines optional local preferences.
- `docs/cli.md` defines the `agent-init` command surface.
- `docs/ready-concept.md` defines the `ready` preparation boundary.
- `docs/demo-context-switching.md` demonstrates project-local context switching.
- `docs/evaluation.md` defines lightweight manual baseline-vs-ready evaluation.
- `docs/profile-contract.md` defines the lightweight profile convention.
- `docs/runtime-state.md` separates persistent memory from local state.
- `docs/command-semantics.md` defines current command behavior.
- `docs/shell-boundary.md` defines the process and shell ownership boundary.
- `docs/runtime-lifecycle.md` defines conceptual lifecycle vocabulary.

## Memory And State

Memory is persistent context.

It belongs in markdown files in `agent-life` and private profile workspaces in `agent-core`.

State is ephemeral runtime data.

It belongs outside public git history:

```text
~/.local/state/agent-life/
```

Current MVP commands may report the state path, but they do not activate profiles, restore sessions, mutate shell environment, or write `current-profile`.

## Shell Boundary

`agent-init` currently inspects and recommends.

It is not a runtime controller.

A child process cannot directly mutate the parent shell's `cwd`, environment, aliases, functions, or prompt.

Future activation may require explicit shell-owned `source` or `eval` behavior, but that API is intentionally unresolved.

The current CLI performs no hidden shell mutation.

## Runtime Lifecycle

Current lifecycle:

```text
discover -> inspect -> recommend
```

Future lifecycle vocabulary includes:

```text
activate
attach
switch
sync
restore
shutdown
```

These are conceptual placeholders, not execution guarantees.

The CLI is not yet a runtime controller or orchestrator.

## CLI Direction

The main command is:

```text
agent-init
```

Current command surface:

```text
agent-init help
agent-init status
agent-init list
agent-init auto
agent-init ready
agent-init ready <context>   # preview marker block, no file mutation
agent-init select <context>
agent-init <context>         # shortcut for select <context>
agent-init fzf               # optional search/preview/select UI
agent-init remove all
agent-init doctor
agent-init version
```

The bare context shortcut delegates to `agent-init select <context>`.

`agent-init fzf` is optional convenience UI. It searches contexts from
`agent-init list --tsv`, previews with `agent-init ready <context>`, and selects
by invoking `agent-init select <context>`. If `fzf` is unavailable, use
`agent-init list`, `agent-init ready <context>`, and
`agent-init select <context>` or the `agent-init <context>` shortcut directly.

`agent-init update` is reserved for a future public framework update command.
For now, rerun `install.sh` to update the framework checkout.

Built-in commands are reserved words. They are not profile names.

Design rules:

- A command is an action.
- An argument is the target.
- Options stay minimal.
- Complex configuration belongs in config files.
- Public framework stays in `agent-life`.
- Private memory stays in `agent-core`.

MVP scope:

- `help` prints the command surface.
- `status` reports framework, core, state, and profile status.
- `list` discovers profiles from `agent-core/profiles/*`.
- `auto` selects a profile only when local context is unambiguous.
- `doctor` reports best-effort diagnostics without changing runtime state.
- `version` prints the CLI version.

CLI output is plain text for humans.

`[OK]`, `[WARN]`, and `[INFO]` prefixes are diagnostic labels, not a stable machine-readable protocol.

Deferred:

- tmux orchestration
- shell export/source
- RAG engine
- LLM integration
- session restore
- environment activation

## Context Shortcut Decision

The documented target shortcut is:

```text
agent-init <context>
```

Meaning:

```text
agent-init select <context>
```

Examples:

```text
agent-init repo-review
agent-init infographic-format-a
agent-init cpp-review
```

The shortcut is project-local marker-block mutation only. It is explicit and
reversible, but it is not activation.

```text
agent-init <context> ≠ activate
agent-init <context> ≠ attach
agent-init <context> ≠ shell mutation
agent-init <context> ≠ write current-profile
agent-init <context> ≠ orchestration
```

The dry-run form is:

```text
agent-init ready <context>
```

It should preview the same marker block that `select` would write, without
modifying files.

Marker block preview shape:

```text
<!-- agent-life:start -->
## Agent-life selected context
...
<!-- agent-life:end -->
```

## Core Discovery

`agent-life` finds `agent-core` in this order:

```text
1. AGENT_CORE_PATH
2. ~/.agent-life/config key: default-core-path
3. ../agent-core
4. ~/.agent-core
```

`install.sh` installs only the public framework checkout.

It does not clone private repositories, write secrets, install private memory, or activate profiles.
It can optionally register PATH and completion source lines in a marker block
with explicit consent.

## Bootstrap

`install.sh` is a lightweight bootstrap fetcher for the public framework.

It can be run from an existing checkout or through a `curl | bash` flow.
It can also register explicit shell integration for PATH and completion source
lines if you consent.

Default install location:

```text
~/.agent-life/framework
```

Recommended external bootstrap shape:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
```

Bootstrap behavior:

- checks that `git` exists
- prints the target clone/update path
- clones the framework when the target path is missing
- runs a best-effort `git pull --ff-only` when the target is an existing checkout
- performs lightweight validation
- prints manual next-step guidance
- may register or remove a reversible marker block in bash or zsh rc files

Framework update currently means rerunning `install.sh`. It updates only the
public framework checkout and does not update private `agent-core`, change
selected context, or modify project `AGENTS.md` marker blocks.

The installer does not edit:

- `PATH` without explicit consent
- shell rc files without explicit consent
- aliases
- runtime state
- `current-profile`
- tmux
- daemons
- watchers
- profile activation

See `docs/shell-integration.md` for the explicit marker-block flow.

See `docs/bootstrap.md` for the full bootstrap contract.

## Quickstart

See `docs/quickstart.md` for the minimal first-run flow.

Copy-paste shape:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
$HOME/.agent-life/framework/bin/agent-init doctor
```

If you accepted shell integration during install, apply it to the current
terminal or open a new terminal:

```sh
# zsh
source ~/.zshrc

# bash
source ~/.bashrc

command -v agent-init
agent-init help
```

Private core example:

```sh
mkdir -p "$HOME/workspace"
git clone <private-agent-core-url> "$HOME/workspace/agent-core"

AGENT_CORE_PATH="$HOME/workspace/agent-core" \
  "$HOME/.agent-life/framework/bin/agent-init" doctor
```

Diagnostics-first flow:

```sh
$HOME/.agent-life/framework/bin/agent-init doctor
$HOME/.agent-life/framework/bin/agent-init list
$HOME/.agent-life/framework/bin/agent-init auto
```

Optional shell integration and manual PATH guidance:

```sh
AGENT_LIFE_SHELL_INTEGRATION=yes "$HOME/.agent-life/framework/install.sh"

# zsh
source ~/.zshrc

# bash
source ~/.bashrc

agent-init help
```

Manual PATH-only alternative:

```sh
export PATH="$HOME/.agent-life/framework/bin:$PATH"
```

The project does not assume global or system-wide install.

Any PATH or shell configuration is user-owned. Installer-managed shell
integration is limited to the explicit marker block described in
`docs/shell-integration.md`.

## Local Config

Local config is optional.

The default flow works without it.

Config path:

```text
~/.agent-life/config
```

Minimal example:

```sh
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$HOME/workspace/agent-core" > "$HOME/.agent-life/config"
```

Supported current behavior:

- `default-core-path` participates in `agent-core` discovery after `AGENT_CORE_PATH`.

The installer does not create or edit config files.

Local config does not activate profiles, mutate shell state, write `current-profile`, or persist sessions.

See `docs/config.md`.

## Profiles

Profiles are context workspaces, not apps.

A profile is not an executable program.

A profile is a work context.

Examples:

```text
develop   development, code, documentation, tests
stock     investment analysis, watchlists, valuation notes
faith     scripture study, faith notes, expression rules
travel    itinerary planning, places, preferences, constraints
writing   essays, summaries, drafts, documents
family    family knowledge, shared records, preferences
```

`develop` is the first reference profile.

It is not the whole purpose of `agent-life`.

Runtime profiles live in private `agent-core/profiles/<name>/`.

Minimal profile shape:

```text
profiles/<name>/
  AGENTS.md
  prompts/
  memory/
  context/
  profile.env
```

`agent-init list` discovers profile names from `agent-core/profiles/*`.

Public samples live under `profiles/` in this repo only as minimal templates.

They are not a substitute for private profile memory.

## Smoke Tests

Run lightweight smoke tests:

```sh
sh tests/smoke/run.sh
```

The tests use POSIX shell scripts with isolated temporary `HOME` directories.

They cover bootstrap install behavior, `doctor`, core discovery precedence, `list`, and `auto`.

They are semantic regression checks, not a heavy test framework.

## Initial Structure

```text
agent-life/
  README.md
  AGENTS.md
  CONVERSATION.md
  DECISIONS.md
  NEXT.md
  install.sh
  bin/
    agent-init
  lib/
    core-discovery.sh
  docs/
    architecture.md
    bootstrap.md
    cli.md
    command-semantics.md
    config.md
    profile-contract.md
    quickstart.md
    shell-integration.md
    runtime-lifecycle.md
    runtime-state.md
    shell-boundary.md
    what-is-agent-life.md
  completions/
    agent-init.bash
    agent-init.zsh
  profiles/
    develop/
    stock/
  tests/
    smoke/
```

## Local Usage

Run the bootstrap fetcher:

```sh
./install.sh
```

Run the MVP CLI directly:

```sh
./bin/agent-init status
./bin/agent-init list
./bin/agent-init auto
./bin/agent-init doctor
```

## Summary

`agent-life` is not a tool that makes AI do the work automatically.

It is a lightweight operational workspace framework that prepares the context in which AI tools can work more safely, coherently, and repeatably.
