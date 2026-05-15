# agent-life

`agent-life` is the public bootstrap layer for a personal AI operating system.

It gives ChatGPT, Codex, Claude, and local LLM sessions a stable repository-based
runtime they can inspect, update, and hand off through. Private memory and
personal workflows live outside this repo in `agent-core`.

## Repository Roles

```text
agent-life   public bootstrap, CLI, shell integration, shared commands
agent-core   private prompts, memory, RAG, personal workflows, profile context
```

Default layout:

```text
~/workspace/
  agent-life/
  agent-core/
```

`agent-core` is discovered by path, config, or environment. It is not a git
submodule by default.

## Runtime Idea

This repo treats markdown files as AI-readable runtime memory:

- `README.md` explains the public framework.
- `AGENTS.md` defines rules for future agent sessions.
- `CONVERSATION.md` preserves executable conversation context.
- `DECISIONS.md` records durable architecture decisions.
- `NEXT.md` lists the next concrete actions.
- `docs/architecture.md` explains the runtime model.
- `docs/bootstrap.md` defines external bootstrap and install semantics.
- `docs/quickstart.md` defines first-run onboarding.
- `docs/config.md` defines optional local preferences.
- `docs/cli.md` defines the `agent-init` command surface.
- `docs/profile-contract.md` defines the lightweight profile convention.
- `docs/runtime-state.md` separates persistent memory from local state.
- `docs/command-semantics.md` defines current command behavior.
- `docs/shell-boundary.md` defines the process and shell ownership boundary.
- `docs/runtime-lifecycle.md` defines conceptual lifecycle vocabulary.

The goal is not to store full transcripts. The goal is to preserve enough
structured context for a future agent session to continue work without guessing.

## Memory And State

Memory is persistent context. It belongs in markdown files in `agent-life` and
private profile workspaces in `agent-core`.

State is ephemeral runtime data. It belongs outside public git history:

```text
~/.local/state/agent-life/
```

Current MVP commands may report the state path, but they do not activate
profiles, restore sessions, mutate shell environment, or write `current-profile`.

## Shell Boundary

`agent-init` currently inspects and recommends. It is not a runtime controller.

A child process cannot directly mutate the parent shell's `cwd`, environment,
aliases, functions, or prompt. Future activation may require explicit
shell-owned `source` or `eval` behavior, but that API is intentionally
unresolved.

The current CLI performs no hidden shell mutation.

## Runtime Lifecycle

Current lifecycle:

```text
discover -> inspect -> recommend
```

Future lifecycle vocabulary includes `activate`, `attach`, `switch`, `sync`,
`restore`, and `shutdown`, but these are conceptual placeholders, not execution
guarantees. The CLI is not yet a runtime controller or orchestrator.

## CLI Direction

The main command will be `agent-init`.

```text
agent-init help
agent-init status
agent-init list
agent-init auto
agent-init doctor
agent-init version
```

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

CLI output is plain text for humans. `[OK]`, `[WARN]`, and `[INFO]` prefixes are
diagnostic labels, not a stable machine-readable protocol.

Deferred:

- tmux orchestration
- shell export/source
- RAG engine
- LLM integration
- session restore
- environment activation

## Core Discovery

`agent-life` finds `agent-core` in this order:

1. `AGENT_CORE_PATH`
2. `~/.agent-life/config` key `default-core-path`
3. `../agent-core`
4. `~/.agent-core`

`install.sh` installs only the public framework checkout. It does not clone
private repositories, write secrets, install private memory, or activate
profiles.

## Bootstrap

`install.sh` is a lightweight bootstrap fetcher for the public framework. It can
be run from an existing checkout or through a `curl | bash` flow.

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
- runs a best-effort `git pull --ff-only` when the target is an existing
  checkout
- performs lightweight validation
- prints manual next-step guidance

The installer does not edit `PATH`, shell rc files, aliases, symlinks, runtime
state, `current-profile`, tmux, daemons, watchers, or profile activation. PATH
or symlink integration is shown only as manual guidance.

See `docs/bootstrap.md` for the full bootstrap contract.

## Quickstart

See `docs/quickstart.md` for the minimal first-run flow.

Copy-paste shape:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
$HOME/.agent-life/framework/bin/agent-init doctor
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

Optional manual PATH guidance:

```sh
export PATH="$HOME/.agent-life/framework/bin:$PATH"
```

The project does not assume global or system-wide install. Any PATH or shell
configuration is user-owned and manual.

## Local Config

Local config is optional. The default flow works without it.

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

- `default-core-path` participates in `agent-core` discovery after
  `AGENT_CORE_PATH`.

The installer does not create or edit config files. Local config does not
activate profiles, mutate shell state, write `current-profile`, or persist
sessions.

See `docs/config.md`.

## Profiles

Profiles are context workspaces, not apps. Runtime profiles live in private
`agent-core/profiles/<name>/`.

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
    runtime-lifecycle.md
    runtime-state.md
    shell-boundary.md
  profiles/
    develop/
    stock/
```

Planned additions:

```text
completions/
  agent-init.bash
  agent-init.zsh
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
