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

Ready explicit-profile step completed:

- Added support for `agent-init ready <profile>` as an explicit target form.
- Kept the command output-only and non-activating.

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

MVP stabilization checkpoint noted:

- Documented the current usable public surface as stable: bootstrap install,
  discovery, built-in observer commands, `ready`, `ready <profile>`, smoke
  tests, and the public/private boundary.
- Kept the deferred areas explicit so future decisions stay separate from the
  current MVP.

Explicit shell integration step completed:

- Added marker-block-based shell integration for bash and zsh rc files.
- Kept rc edits consent-based, reversible, and limited to PATH plus completion
  source lines.
- Added completion stubs for the built-in `agent-init` command surface.

Single context naming model review documented:

- Documented a candidate simplification from `agent-init [profile] [topic]` to
  `agent-init [context]` and `agent-init ready [context]`.
- Defined `agent-init` as the default ready briefing concept, with
  `agent-init <context>` as a future context-specific shortcut concept and
  `agent-init ready <context>` as the explicit form.
- Clarified that context is an AI-ready briefing context, not an app,
  activation target, shell/env mutation, runtime state transition, session
  attach, orchestration trigger, or `current-profile` write.
- Documented the preferred composition style as one human-named kebab-case
  context such as `python-arch`, `money-dividend`, or `faith-nehemiah`, instead
  of multiple CLI arguments like `agent-init python arch`.
- Preserved the existing `profiles/<name>` structure as the current private
  container for named briefing context, without adding `contexts/` or changing
  runtime behavior.

Context naming convention documented:

- Defined context names as readable kebab-case names with one briefing intent.
- Documented good examples: `work`, `repo-review`, `python`, `python-arch`,
  `cli`, `shell-cli`, `infographic`, `money-dividend`, `faith-nehemiah`, and
  `travel-yeosu`.
- Documented discouraged names and shapes: multiple CLI arguments like
  `python arch` or `work arch python`, overly broad names like `all`, `misc`,
  and `general`, temporary names like `temp` and `test-only`, and vague names
  like `dev-stuff`.
- Reserved `help`, `doctor`, `status`, `list`, `auto`, `version`, and `ready`
  so they must not be used as context names.
- Kept the change documentation-only: no `agent-init <context>` implementation,
  no multi-context parsing, no `contexts/` directory creation, no profile
  structure change, no ready behavior change, no shell mutation, no
  `current-profile` write, no activation/orchestration, and no automatic
  parsing or merging.

Public sample context step completed:

- Selected `repo-review` as the first practical public sample context
  candidate.
- Reason: it is useful for evaluating `agent-life` itself, supports
  baseline-vs-ready comparison, and focuses on repo state analysis,
  improvement candidates, risks, and verification instead of broad development
  work.
- Added `profiles/repo-review/AGENTS.md` as a public-safe sample briefing with
  minimal role, review focus, non-goals, verification habit, and MVP boundary.
- Documented `repo-review` in the profile contract and ready concept docs as a
  briefing context, not automatic analysis.
- Preserved runtime boundaries: no `agent-init <context>` shortcut, no ready
  behavior change, no profile activation, no `current-profile` write, no shell
  mutation, no orchestration, and no automatic parsing or merging.

Manual evaluation workflow documented:

- Added `docs/evaluation.md` for lightweight manual comparison between normal
  AI CLI use and AI CLI use after `agent-init ready`.
- Chose the first scenario as `agent-life` repo self-evaluation using the
  `repo-review` briefing context.
- Preserved fairness by requiring the final task prompt to be exactly the same
  in baseline and ready flows: `현재 agent-life repo 상태를 분석하고, 다음 개선 후보와 리스크를 제안해줘.`
- Documented that `profiles/repo-review` is public-safe sample/template only;
  actual ready evaluation needs a test or private `agent-core` with
  `profiles/repo-review` and `AGENT_CORE_PATH` set.
- Added an evaluation table with score and evidence columns for goal alignment,
  boundary adherence, overengineering risk, actionability, verification
  quality, context awareness, and handoff quality.
- Added result-record and feedback templates so baseline and ready answers can
  be pasted into one comparable note.
- Linked `docs/evaluation.md` from the README.
- Kept the workflow manual: no AI CLI automation, benchmark framework, scoring
  automation, LLM/RAG integration, runtime behavior change, ready behavior
  change, shell integration, shortcut implementation, or automatic use of
  public samples as runtime context.

Shell integration install issue diagnosed and fixed:

- Diagnosed that `curl | bash` can leave installer stdin connected to the
  script stream, so an interactive shell integration prompt may not read user
  input from stdin.
- Updated `install.sh` so the shell integration prompt reads from `/dev/tty`
  when available, preserving Enter as the default yes response.
- Kept non-interactive registration explicit through
  `AGENT_LIFE_SHELL_INTEGRATION=yes` or `--shell-integration`.
- Improved zsh/bash shell detection fallback and retained rc targets as
  `~/.zshrc` for zsh and `~/.bashrc` for bash.
- Improved next-step output to explicitly tell users to run `source ~/.zshrc`
  or `source ~/.bashrc`, or open a new terminal, then verify with
  `command -v agent-init` and `agent-init help`.
- Strengthened smoke tests for marker block content, completion source lines,
  duplicate prevention, and marker-only removal while preserving user rc lines.
- Updated README, quickstart, and shell integration docs with immediate apply
  steps.
- Preserved constraints: no shell rc edits without consent, no edits outside
  the marker block, no aliases, no symlinks, no activation, no `current-profile`
  writes, no orchestration, and no shortcut/runtime behavior changes.

Status consistency cleanup completed:

- Reviewed `NEXT.md`, `CONVERSATION.md`, `DECISIONS.md`, `README.md`, and
  `docs/shell-integration.md` for shell integration and completion status.
- Confirmed bash/zsh shell integration install/uninstall flow and completion
  stubs are completed behavior in the current MVP.
- Moved completed ready/context/evaluation/shell-integration tracking items in
  `NEXT.md` into the completed `Now` list.
- Removed the duplicate incomplete `Add shell completion stubs for bash and zsh`
  item from `NEXT.md`.
- Left the remaining near-term work focused on decisions and manual evaluation:
  `agent-init <context>` shortcut, `repo-review` baseline-vs-ready evaluation,
  `repo-review` wording follow-up, and the long-term `profiles/` versus
  `contexts/` storage question.
- Made no code, runtime behavior, or `install.sh` changes.

First baseline-vs-ready result recorded:

- Added an actual evaluation record to `docs/evaluation.md` using the provided
  Baseline and Ready result summaries.
- Did not run a new AI CLI evaluation, benchmark, or scoring automation.
- Recorded that the final prompt was exactly the same in both sessions:
  `현재 이 repo의 상태를 보고, 가장 먼저 해야 할 개선 작업 1개와 그 이유를 제안해줘.`
- Recorded that the only intended difference was whether ready context was
  provided before the prompt.
- Captured the evaluation table:
  goal alignment 4/5, boundary adherence 4/5, overengineering risk 4/5,
  actionability 4/4, verification quality 4/5, context awareness 3/4, and
  handoff quality 4/5 for Baseline/Ready respectively.
- Conclusion: both sessions chose the same next action, but Ready better tied
  the recommendation to the core question of whether `agent-init ready` improves
  AI context and boundary quality. The improvement was positive but modest
  because repo docs were already strong enough for Baseline to infer the right
  step.
- Updated `NEXT.md` to mark the first evaluation record complete and keep
  follow-up candidates for strengthening `repo-review` and saving raw outputs
  next time.
- Made no code, runtime behavior, `ready`, shell integration, or
  `agent-init <context>` shortcut changes.

Project-local context switcher semantics documented:

- Reframed `agent-life` in README and `docs/what-is-agent-life.md` as a
  lightweight public bootstrap framework and future project-local AI context
  switcher.
- Defined the emerging model: `agent-life` connects a selected `agent-core`
  context to the current project's AI instruction surface.
- For the Codex MVP target, documented the proposed surface as the current
  project's `AGENTS.md` file with an explicit `agent-life` marker block.
- Documented that future `select` means linking read-first references to a
  selected context, not activating a profile.
- Documented that future `remove` removes only the `agent-life` marker block,
  and future `status` reports the current project's selected context state.
- Added placeholder semantics for `select`, `remove`, and `update` in
  `docs/command-semantics.md`; no commands were implemented.
- Added `ready` versus `select` distinction in `docs/ready-concept.md`.
- Added the project-local AGENTS marker block connection model to
  `docs/profile-contract.md`.
- Recorded the direction as a decision candidate in `DECISIONS.md`.
- Added NEXT candidates for marker format, `select`, `remove`, `status`, and
  optional `update` behavior.
- Preserved constraints: no implementation, no AGENTS.md mutation logic, no
  runtime behavior change, no `current-profile` write, no profile activation,
  no shell/env mutation, no tmux/session orchestration, no daemon/watcher, no
  `agent-core` file copy/merge, and no marker-outside edits.

AGENTS marker block specification documented:

- Added `docs/marker-block.md` as the specification for future project-local
  `AGENTS.md` marker block selection.
- Defined marker tokens as `<!-- agent-life:start -->` and
  `<!-- agent-life:end -->`.
- Defined the selected-context block shape with selected context, read-first
  profile `AGENTS.md`, and session rules.
- Defined insert behavior: append to existing `AGENTS.md` while preserving all
  existing content.
- Defined create behavior: future `select` may create `AGENTS.md` containing
  only the marker block when the project has no `AGENTS.md`.
- Defined update behavior: replace only the inclusive marker block range.
- Defined remove behavior: remove only the marker block.
- Defined remove-all rollback: delete `AGENTS.md` only if it contains only the
  marker block plus whitespace; otherwise keep the file.
- Linked the marker spec from `docs/command-semantics.md` and
  `docs/profile-contract.md`.
- Recorded the marker format decision in `DECISIONS.md` and marked the marker
  specification complete in `NEXT.md`.
- Made no implementation, runtime behavior, AGENTS mutation logic,
  `current-profile` write, profile activation, shell/env mutation, automatic
  parsing/merging, or `agent-core` copy/merge changes.

Project-local status reporting designed:

- Updated `docs/command-semantics.md` with future `agent-init status`
  project-local output candidates.
- Candidate status output includes framework path, core path, project path,
  project `AGENTS.md` existence, marker block state, selected context, context
  source path, and a warning when the selected context source is missing.
- Updated `docs/marker-block.md` to define the read-only status scope:
  current project path, `AGENTS.md` existence, marker tokens, inclusive marker
  block content, first `Selected context:` item, first `Read first:` path, and
  source path existence.
- Defined that missing complete marker block should report selected context as
  `none`.
- Marked the status reporting design complete in `NEXT.md` and left
  `agent-init status` project-local marker reporting as an implementation
  candidate.
- Made no implementation, AGENTS.md modification, marker block expansion,
  runtime behavior, or parsing/merging changes.

Project-local select/remove MVP implemented:

- Decided the marker block specification is sufficient to implement the Codex
  `AGENTS.md` target safely.
- Implemented `agent-init select <context>` for one context only.
- `select` requires `agent-core/profiles/<context>/AGENTS.md` to exist and
  writes only the `agent-life` marker block in the current project's
  `AGENTS.md`.
- `select` appends the marker block when no marker exists, replaces only the
  existing marker block when one exists, and refuses malformed or duplicate
  marker tokens.
- Implemented `agent-init remove all` as marker-only rollback.
- `remove all` deletes `AGENTS.md` only when the file contains only the marker
  block plus whitespace; otherwise it removes only the marker block and keeps
  user-authored content.
- Extended `agent-init status` to report project path, project `AGENTS.md`
  presence, marker block state, selected context, context source path, and a
  warning when the selected source is missing.
- Added smoke coverage for marker block add, update without duplication,
  status detection, missing source warning, marker-only removal, and preserving
  existing project AGENTS content.
- Preserved exclusions: no multiple contexts, context merge, priority rules,
  `current-profile`, Claude/Copilot targets, non-AGENTS targets, AI CLI
  handoff, RAG/LLM integration, profile activation, shell/env mutation,
  tmux/session orchestration, daemon, or watcher behavior.

## 2026-05-17

Select/remove/status smoke coverage strengthened:

- Added a dedicated `tests/smoke/test_select_remove.sh` smoke test.
- The test uses isolated temporary `HOME`, project directories, and
  `agent-core` profiles only.
- Covered select creating `AGENTS.md`, select preserving existing project
  guidance, repeat select avoiding duplicate marker blocks, switching from
  context A to context B, `remove all` preserving marker-outside content, and
  status reporting selected versus none.
- Kept checks grep/assert based instead of full output snapshots.
- Made no implementation or marker semantics changes because
  `docs/marker-block.md` and `docs/command-semantics.md` already matched the
  current behavior.

Context switching demo documented:

- Added `docs/demo-context-switching.md` to show the practical
  `cd target-project`, `agent-init status`, `agent-init list`,
  `agent-init select <context>`, `codex`, and `agent-init remove all` flow.
- Included examples for `repo-review`, infographic format switching, and
  C++/Java review context switching.
- Emphasized that `select` writes only a project-local `AGENTS.md` marker block,
  is not activation, preserves marker-outside content, and links
  `agent-core` by reference rather than copying or merging private files.
- Linked the demo from `README.md`.
- Made documentation-only changes; no implementation files changed.

Bare context shortcut semantics decided and documented:

- Decided that the marker block is the canonical representation of an
  `agent-life` context connection.
- Defined `agent-init ready <context>` as a marker block preview/dry-run that
  prints the same block `select` would write, with no file mutation.
- Defined `agent-init select <context>` as writing or updating that marker
  block in the current project's `AGENTS.md`.
- Defined `agent-init <context>` as the shortcut for
  `agent-init select <context>`, not for `ready <context>`.
- Recorded that reserved commands keep command meaning and must not be treated
  as shortcut contexts: `help`, `doctor`, `status`, `list`, `auto`, `version`,
  `ready`, `select`, `remove`, and `update`.
- Added the principle: marker block is a window, not a copy.
- Updated command semantics, ready concept, marker block spec, context switching
  demo, README, CLI/profile/concept docs, decisions, and next actions.
- Made documentation-only changes; no implementation files changed and existing
  select/remove marker logic stayed untouched.
