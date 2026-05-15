# Architecture

`agent-life` is the public bootstrap layer for a personal AI operating system.
It provides a repo-based runtime that AI agents can inspect, update, and hand
off through.

The runtime has three layers:

```text
framework   public bootstrap/runtime in agent-life
core        private memory/context in agent-core
state       local runtime/cache outside public git history
```

## Two-Repo Model

```text
agent-life   public framework
agent-core   private brain
```

### agent-life

Responsibilities:

- Install and bootstrap runtime tools
- Provide the `agent-init` CLI
- Define shared commands
- Load shell integrations
- Discover `agent-core`
- Document public architecture and handoff state

Contents are safe to publish.

### agent-core

Responsibilities:

- Prompts
- Memory
- RAG indexes and source context
- Personal workflows
- Domain profiles
- Private config

Contents are private and should not be copied into `agent-life`.

Expected profile areas:

```text
develop
finance
faith
travel
stock
```

### local state

Responsibilities:

- Runtime cache
- Local-only status files
- Future session metadata
- Non-portable machine state

Default path:

```text
~/.local/state/agent-life
```

The state layer is not a substitute for durable AI memory. Durable public memory
belongs in markdown files in `agent-life`; durable private memory belongs in
`agent-core`.

## Default Layout

Use sibling repositories:

```text
~/workspace/
  agent-life/
  agent-core/
```

`agent-core` is not a submodule by default. Submodule support may exist later as
an advanced mode, but the default runtime should work through path discovery.

## Core Discovery

Discovery order:

1. `AGENT_CORE_PATH`
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

`agent-init status` should show which source was used.
`agent-init doctor` should validate that the discovered path is usable.

## Runtime Flow

```text
shell
  -> agent-init <target>
  -> discover agent-life root
  -> discover agent-core path
  -> resolve local state path
  -> load public command framework
  -> load private profile context
  -> print or export handoff instructions for the agent session
```

The runtime should prefer explicit, inspectable files over hidden state.

## Persistent Context Files

`README.md` describes the public framework.

`AGENTS.md` gives rules to future AI agents.

`CONVERSATION.md` summarizes current conversation state and active context.

`DECISIONS.md` records durable decisions.

`NEXT.md` lists the next concrete actions.

`docs/cli.md` defines the CLI contract.

## Boundary Rules

- Public repo code may know how to find `agent-core`.
- Public repo code must not contain private memory.
- Public docs may name profile categories.
- Public docs must not include personal profile content.
- Bootstrap commands should be safe to run repeatedly.
- Private repo access failures should produce clear recovery instructions.

## MVP Boundary

Current `agent-init` MVP implements only:

- `help`
- `status`
- `list`
- `auto`
- `version`

It does not implement tmux orchestration, shell activation, RAG, LLM
integration, AGENTS.md parsing, session restore, or environment activation.
