# NEXT.md

This file tracks the next concrete actions. Keep it actionable and current.

## Now

- [x] Create initial runtime markdown documents.
- [x] Document public/private repo split.
- [x] Record the decision not to use `agent-core` as a default submodule.
- [x] Add initial safe `install.sh` bootstrap checker.
- [x] Create `bin/agent-init` CLI skeleton.
- [x] Implement `agent-init status`.
- [x] Implement `agent-init list`.
- [x] Implement `agent-init auto`.
- [x] Implement `agent-init help` and `agent-init version`.
- [x] Define lightweight profile contract.
- [x] Add minimal public sample profiles for `develop` and `stock`.
- [x] Define runtime state model.
- [x] Define command semantics for MVP and future placeholders.
- [x] Define shell boundary and future activation constraints.
- [x] Define conceptual runtime lifecycle vocabulary.
- [x] Implement `agent-init doctor` as diagnostics-only observer.
- [x] Normalize lightweight CLI diagnostic output.
- [x] Support `curl | bash` bootstrap flow for public framework install.
- [x] Define repo-external bootstrap semantics.
- [x] Set default install location to `~/.agent-life/framework`.
- [x] Keep install as fetch/update guidance, not runtime activation.
- [x] Add lightweight first-run quickstart onboarding.
- [x] Document private `agent-core` connection examples.
- [x] Improve install next-step guidance around `doctor`, `list`, and `auto`.
- [x] Document minimal remove/uninstall flow.
- [x] Define optional local config semantics at `~/.agent-life/config`.
- [x] Add `default-core-path` to core discovery as read-only local preference.
- [x] Centralize core discovery in internal `lib/core-discovery.sh` helper.
- [x] Reuse core discovery from `status`, `doctor`, `list`, `auto`, and
      bootstrap guidance.
- [x] Add POSIX shell smoke tests for install, doctor, discovery precedence,
      list, and auto.
- [x] Add shell completion stubs for bash and zsh.
- [x] Implement explicit shell integration install/uninstall flow.
- [x] Clarify built-in command reservation and future profile shortcut
      semantics.
- [x] Refine `agent-init help` output for current vs future behavior.
- [x] Add official concept document for agent-life identity.
- [x] Add lightweight smoke checks for help/status/version wording consistency.
- [x] Implement `agent-init ready` as an output-only preparation command.
- [x] Support `agent-init ready <profile>` as an explicit target form.
- [x] Document the single context naming model as a candidate simplification.
- [x] Define the context naming convention for future shortcut planning.
- [x] Choose `repo-review` as the first public sample context candidate.
- [x] Add `profiles/repo-review/AGENTS.md` as a public-safe sample briefing.
- [x] Add lightweight manual baseline-vs-ready evaluation workflow.
- [x] Fix shell integration prompt and post-install reload guidance.
- [x] Record the first `repo-review` baseline-vs-ready evaluation result.
- [x] Define project-local `AGENTS.md` marker block specification.
- [x] Design project-local marker block status reporting.
- [x] Implement `agent-init select <context>` for Codex `AGENTS.md` marker blocks.
- [x] Implement `agent-init remove all` marker-only rollback.
- [x] Implement `agent-init status` project-local marker block reporting.
- [x] Add smoke coverage for marker block add, update, status, and removal.
- [x] Strengthen select/remove/status smoke coverage for project-local
      `AGENTS.md` marker block safety.
- [x] Add a project-local context switching demo document for
      `select`/`status`/`remove all`.
- [x] Decide and document `agent-init <context>` as the shortcut for
      `agent-init select <context>`.
- [x] Implement `agent-init <context>` as a shortcut for
      `agent-init select <context>`.
- [x] Add dedicated smoke coverage for `agent-init <context>` shortcut safety.
- [x] Implement `agent-init ready <context>` as marker block preview/dry-run
      using shared marker block generation.
- [x] Strengthen context switching demo around shortcut-first usage and
      ready-preview behavior.
- [x] Add privacy-safe field record template for real project context switching
      observations.
- [x] Define `agent-init update` candidate scope as public framework update
      only, with private `agent-core` update deferred.
- [x] Define `agent-init fzf` MVP UX as an experimental thin selector around
      existing commands.
- [x] Implement `agent-init list --tsv` for fzf-friendly context rows.
- [x] Implement `agent-init fzf` MVP as search, ready-preview, and select only.
- [x] Strengthen `agent-init fzf` smoke coverage for fallback, `list --tsv`,
      and `ready <context>`.
- [x] Strengthen fzf context switching demo and README optional UI guidance.
- [x] Document public plus private context discovery as a candidate model.
- [x] Add five public-safe default context AGENTS files.
- [x] Implement public plus private hybrid context discovery.
- [x] Preserve private context override priority over public contexts.
- [x] Add smoke coverage for public fallback and private override behavior.
- [x] Record the hybrid discovery implementation decision.
- [x] Implement optional one-line `Hint:` convention for selected context
      marker blocks.
- [x] Add `Hint:` lines to public task/planning/review/summary contexts.
- [x] Add smoke coverage for hinted and path-only marker block shapes.

## Next

### Right now

- [ ] Fill the first project-local context switching field record after a real
      Codex run, using generalized project details only.
- [ ] Decide whether `repo-review` needs wording changes after the first manual
      evaluation.
- [ ] Decide whether to strengthen `repo-review` context for clearer future
      baseline-vs-ready differentiation.
- [ ] Record raw baseline and ready outputs in future evaluations.
- [ ] Decide whether existing `profiles/<name>` remains the long-term private
      container or whether a future `contexts/<name>` structure is worth a
      separate migration.
- [ ] Decide whether `agent-init list` should display context scope such as
      `private` or `public`.
- [ ] Decide whether `agent-init list --tsv` and `agent-init fzf` should expose
      scope/source without making the UI noisy.
- [ ] Decide whether and how to implement `agent-init update` as a public
      framework update wrapper around the existing bootstrap update flow.
- [ ] Decide whether marker block refresh needs a separate explicit command.
- [ ] Decide whether private `agent-core` update needs a future separate
      command such as `agent-init core update`.
- [ ] Decide whether to replace the experimental `Hint:` marker label with the
      clearer `Intent:` convention.
- [ ] Implement optional one-line `Intent:` extraction for marker blocks, if
      the convention is accepted, without context taxonomy, permission
      enforcement, branching, body copying, or hard-coded context names.
- [ ] Observe whether one-line `Intent` is enough before considering any
      richer marker block convention.
- [ ] Later candidate: decide whether `agent-init show <context>` is needed
      after observing real fzf preview friction.
- [ ] Later candidate: decide whether fzf remove/status keybindings are worth
      adding without destructive surprises or terminal keybinding conflicts.
- [ ] Later candidate: decide whether alias support is needed without renaming
      private `agent-core` context directories.
- [ ] Later candidate: decide whether multi-select or context merge should ever
      be supported after precedence/conflict semantics are designed.
- [ ] Decide later whether context descriptions should remain first-line
      `Description:` only.
- [ ] Decide the canonical public raw `install.sh` URL after repository remote
      is final.
- [ ] Decide whether quickstart should mention a public sample `agent-core`
      template after private core structure exists.
- [ ] Define profile loader behavior after command semantics are stable.

### Later

- [ ] Decide whether public sample profiles should become installable templates.
- [ ] Decide when `current-profile` may be written and by which command.
- [ ] Decide whether any future command should support explicit multi-context
      composition; current candidate direction is no.
- [ ] Decide whether context rename should ever be supported; current candidate
      direction is no because it can mutate private `agent-core` directories
      and break references.
- [ ] Decide whether activation should use source/eval, wrapper functions, or a
      separate controller command.
- [ ] Decide whether lifecycle transitions should ever become a strict runtime
      state machine.
