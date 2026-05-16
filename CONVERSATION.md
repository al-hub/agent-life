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

CLI output refinement step completed:

- Normalized observer command output around `[OK]`, `[WARN]`, and `[INFO]`.
- Added verbose discovery reasoning without changing runtime behavior.
- Clarified that output remains human-oriented diagnostics, not a stable
  machine-readable protocol.
- Kept commands mutation-free: no activation, repair, shell mutation, state
  writes, sync, tmux, daemon, or lifecycle state machine.

Bootstrap ergonomics step completed:

- Reworked `install.sh` into a lightweight public framework bootstrap fetcher.
- Added support for repo-external execution and `curl | bash` style usage.
- Set default install location to `~/.agent-life/framework`.
- Installer checks for `git`, prints the clone/update target path, clones when
  missing, and performs best-effort `git pull --ff-only` for existing git
  checkouts.
- Added lightweight validation for `install.sh`, `bin/agent-init`, and
  `README.md`.
- Installer prints manual next-step guidance only.
- Explicitly preserved boundaries: no PATH mutation, shell rc modification,
  alias injection, automatic symlink creation, `current-profile` writes, daemon
  or watcher, auto activation, tmux integration, AGENTS semantic parsing, or
  hidden shell/runtime ownership.
- Added `docs/bootstrap.md` and updated README/architecture/shell-boundary
  docs plus durable decision and next-action files.

Quickstart onboarding step completed:

- Added `docs/quickstart.md` for minimal first-run onboarding.
- Documented the recommended flow: curl bootstrap, confirm framework with
  `agent-init doctor`, clone private `agent-core`, optionally set
  `AGENT_CORE_PATH`, then run `agent-init doctor`, `list`, and `auto`.
- Added copy-paste examples for optional PATH guidance and explicit
  `AGENT_CORE_PATH` usage.
- Documented minimal update and remove flows without assuming global or
  system-wide install.
- Improved install output to recommend diagnostics first and point at the local
  quickstart document.
- Preserved boundaries: no PATH mutation, shell rc modification, auto
  activation, `current-profile` writes, tmux/session orchestration,
  daemon/watcher, AGENTS semantic parsing, or runtime mutation.

Local config semantics step completed:

- Added `docs/config.md`.
- Chose `~/.agent-life/config` as the only local config location.
- Defined config as optional local preference, not runtime state or activation.
- Added read-only `default-core-path` support to `agent-init` core discovery.
- Updated discovery order to `AGENT_CORE_PATH`, config `default-core-path`,
  `../agent-core`, then `~/.agent-core`.
- Kept config format as simple `key=value` text with comments and graceful
  ignore for malformed or unknown lines.
- Documented reserved examples `verbose-default` and `install-root` without
  making current runtime behavior depend on them.
- Preserved constraints: no config auto-generation, hidden config mutation,
  `current-profile` writes, daemon/watcher, runtime activation, shell hooks,
  AGENTS semantic parsing, tmux/session config, or runtime/session persistence
  semantics.

Core discovery helper step completed:

- Added internal `lib/core-discovery.sh`.
- Moved core discovery, local config lookup, `~` expansion, result parsing, and
  discovery reasoning rows into the helper.
- Updated `agent-init status`, `doctor`, `list`, and `auto` to use the helper.
- Updated `install.sh` to validate the helper and print current core discovery
  after clone/update using the same implementation.
- Preserved discovery order exactly: `AGENT_CORE_PATH`, config
  `default-core-path`, `../agent-core`, then `~/.agent-core`.
- Kept the helper private and small: no provider/plugin system, generic
  framework layer, hidden cache/state, activation, shell mutation,
  `current-profile` writes, daemon/watcher, or AGENTS semantic parsing.

Smoke tests step completed:

- Added `tests/smoke/run.sh` as a lightweight POSIX shell runner.
- Added smoke tests for install/bootstrap, `agent-init doctor`, discovery
  precedence, and `list`/`auto`.
- Tests use isolated temporary `HOME` directories and clean them with traps.
- Covered current discovery order: `AGENT_CORE_PATH`, config
  `default-core-path`, `../agent-core`, then `~/.agent-core`.
- Kept the tests framework-free: no pytest, bats, TAP, hidden mutation,
  `current-profile` writes, activation, orchestration, daemon, or watcher.
- Current smoke run result: 4 passed, 0 failed.

CLI help semantics step completed:

- Reworked `agent-init help` output around reserved built-ins and a future
  profile/topic shortcut concept.
- Clarified that `help`, `doctor`, `status`, `list`, `auto`, and `version` are
  reserved words, not profile names.
- Documented `agent-init [profile] [topic]` as a preparation-only future
  shortcut concept without implementing it.
- Added a smoke test for help output to keep the wording stable.
- Kept current behavior unchanged: no profile shortcut execution, no ready
  command, no activation, no shell mutation, no orchestration, and no
  `current-profile` write.

Help wording refinement step completed:

- Changed the top line to `agent-init - prepare AI-ready work context`.
- Kept `Usage:` limited to `agent-init <command>`.
- Moved `agent-init [profile] [topic]` under `Future convenience`.
- Added `Planned shortcut for: agent-init ready [profile] [topic]`.
- Added `write current-profile` to the help warning so the shortcut cannot be
  mistaken for runtime ownership.
- Kept the change wording-only; no runtime shortcut behavior was added.

Smoke test regression step completed:

- Added minimal POSIX smoke checks for `status` and `version` alongside the
  existing help/doctor/list/auto coverage.
- Kept the checks focused on core wording and role semantics instead of full
  output snapshots.

Ready concept documentation step completed:

- Added `docs/ready-concept.md` as the boundary document for the future
  preparation flow.
- Linked the concept from CLI and command-semantics docs so the shortcut stays
  documentation-only for now.

Ready MVP acceptance step completed:

- Added minimal MVP acceptance criteria to the ready concept doc.
- Kept the criteria focused on boundary, diagnostics, verification, and a task
  brief skeleton rather than execution or orchestration.

Ready implementation step completed:

- Implemented `agent-init ready` as an output-only preparation command.
- Kept the shortcut `agent-init [profile] [topic]` unresolved for a later
  decision.

Ready profile-discovery refinement step completed:

- Added discovered-profile output to the `ready` briefing so core-present and
  empty-profile cases stay readable.
- Kept read-first files as recommendations only and avoided any automatic
  parsing or merging.

Concept document step completed:

- Added a short identity line to `docs/what-is-agent-life.md` so it reads as
  the official concept document.
- Kept the README link in place and preserved the current public framing of
  `agent-life` as a lightweight bootstrap framework for AI-ready work
  contexts.
- Replaced the stale `shell integration` wording in durable decisions with
  `runtime semantics`.
- Added a durable decision noting that the `agent-life` name is retained while
  the scope is reframed more precisely for new readers.

Documentation consistency step completed:

- Reduced `docs/architecture.md` to the current AI-ready work-context framing.
- Replaced the stale `personal AI operating system` / `shell integration`
  wording there with runtime-semantics language.
- Kept the existing README/AGENTS/DECISIONS/what-is-agent-life structure intact
  while aligning the scope wording across the public docs.
