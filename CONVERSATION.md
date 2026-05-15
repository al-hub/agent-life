# CONVERSATION.md

This file stores executable conversation context for future AI sessions. It is a
summary of state and intent, not a full transcript.

## 2026-05-16

We are designing `agent-life` as a personal AI operating system bootstrap repo.

Core goal:

- Build persistent repo-based context that ChatGPT, Codex, Claude, and local
  LLMs can inspect and continue from.
- Separate public bootstrap/framework from private brain/context.
- Use markdown files as AI-readable memory and runtime handoff material.

Repository split:

```text
agent-life   public repo for bootstrap, CLI, commands, shell integration
agent-core   private repo for prompts, memory, RAG, workflows, profiles
```

`agent-core` should not be a submodule by default. The preferred layout is
sibling repositories:

```text
~/workspace/
  agent-life/
  agent-core/
```

The `agent-init` CLI will become the main entry point. Target commands:

```text
agent-init develop
agent-init stock
agent-init auto
agent-init status
agent-init sync
agent-init doctor
```

Design principles:

- Command is action.
- Argument is target.
- Minimize `--option` usage.
- Hide complex setup in config files.
- Keep private content out of public repo.
- Let future agent sessions continue from repo state.

Current implementation step:

- Create the initial markdown runtime documents.
- Add an initial safe `install.sh` bootstrap checker.
- Document architecture and CLI behavior before building the full CLI.

Next implementation step completed:

- Added `bin/agent-init` MVP as a bash script.
- Implemented `help`, `status`, `list`, `auto`, and `version`.
- Kept profile discovery dynamic through `agent-core/profiles/*`.
- Kept `install.sh` as a non-destructive bootstrap checker.
- Deferred tmux orchestration, shell activation, RAG, LLM integration,
  AGENTS.md parsing, session restore, and environment activation.

Profile contract step completed:

- Defined profiles as context workspaces, not apps.
- Added `docs/profile-contract.md`.
- Added minimal public sample profiles: `profiles/develop` and `profiles/stock`.
- Documented root `AGENTS.md` vs profile `AGENTS.md` roles.
- Kept current runtime simple: profile discovery is based on directory
  existence only; no parsing, sourcing, activation, inheritance, merge logic,
  RAG, or LLM integration.

Runtime semantics step completed:

- Added `docs/runtime-state.md` to separate memory from local state.
- Added `docs/command-semantics.md` to define inspect/recommend/placeholder
  command behavior.
- Defined proposed state path as `~/.local/state/agent-life/`.
- Kept `current-profile`, `last-context`, `sessions/`, and `cache/` as future
  placeholders only.
- Confirmed current commands remain inspection/discovery focused; `auto`
  recommends but does not activate, switch, attach, or write state.

Shell boundary step completed:

- Added `docs/shell-boundary.md`.
- Documented the child process limitation: plain `agent-init` commands cannot
  mutate parent shell `cwd`, environment, aliases, functions, or prompt.
- Clarified activate, attach, and switch as future unimplemented semantics.
- Kept source/eval activation as a future possibility, not a committed API.
- Confirmed the current CLI is an inspector/recommender, not a runtime
  controller.

Runtime lifecycle step completed:

- Added `docs/runtime-lifecycle.md`.
- Defined current lifecycle as `discover -> inspect -> recommend`.
- Documented future vocabulary: activate, attach, switch, sync, restore, and
  shutdown.
- Kept lifecycle as conceptual vocabulary, not a strict FSM or ordered execution
  guarantee.
- Confirmed lifecycle stages beyond recommendation remain unimplemented and
  intentionally unresolved.

Doctor MVP step completed:

- Implemented `agent-init doctor` as a best-effort diagnostics command.
- Checks framework detection, git availability, `AGENT_CORE_PATH`, core
  discovery, profile discovery, state path accessibility, and shell type.
- Kept doctor as observer/reporting only: no repair, activation, shell mutation,
  state writes, sync, tmux, daemon, or lifecycle state machine.
- Warnings are informational and do not define a strict exit-code contract.
