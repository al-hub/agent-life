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
- `docs/cli.md` defines the `agent-init` command surface.

The goal is not to store full transcripts. The goal is to preserve enough
structured context for a future agent session to continue work without guessing.

## CLI Direction

The main command will be `agent-init`.

```text
agent-init help
agent-init status
agent-init list
agent-init auto
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
- `version` prints the CLI version.

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
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

The initial `install.sh` only checks and reports this connection. It does not
clone private repositories, write secrets, or install private memory.

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
  docs/
    architecture.md
    cli.md
```

Planned additions:

```text
completions/
  agent-init.bash
  agent-init.zsh
profiles/
  README.md
```

## Bootstrap

Run the current bootstrap check:

```sh
./install.sh
```

It verifies the repo root, checks likely `agent-core` paths, and prints next
steps for installing `agent-init` when the CLI exists.

Run the MVP CLI directly:

```sh
./bin/agent-init status
./bin/agent-init list
./bin/agent-init auto
```
