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

## Next

### Right now

- [ ] Decide whether `agent-init <context>` should be implemented as a
      shortcut to `agent-init ready <context>` or remain documentation-only.
- [ ] Decide whether `repo-review` needs wording changes after the first manual
      evaluation.
- [ ] Decide whether to strengthen `repo-review` context for clearer future
      baseline-vs-ready differentiation.
- [ ] Record raw baseline and ready outputs in future evaluations.
- [ ] Decide whether existing `profiles/<name>` remains the long-term private
      container or whether a future `contexts/<name>` structure is worth a
      separate migration.
- [ ] Decide exact `AGENTS.md` marker block format for project-local context
      selection.
- [ ] Decide `agent-init select <context>` behavior and failure modes.
- [ ] Decide `agent-init remove` rollback behavior for marker-only removal.
- [ ] Decide how `agent-init status` should report selected project context.
- [ ] Decide whether `agent-init update` is needed for marker refresh.
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
- [ ] Decide whether activation should use source/eval, wrapper functions, or a
      separate controller command.
- [ ] Decide whether lifecycle transitions should ever become a strict runtime
      state machine.
