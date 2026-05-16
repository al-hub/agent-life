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
- [x] Clarify built-in command reservation and future profile shortcut
      semantics.
- [x] Refine `agent-init help` output for current vs future behavior.
- [x] Add official concept document for agent-life identity.
- [x] Add lightweight smoke checks for help/status/version wording consistency.

## Next

- [ ] Decide the canonical public raw `install.sh` URL after repository remote
      is final.
- [ ] Decide whether quickstart should mention a public sample `agent-core`
      template after private core structure exists.
- [ ] Add shell completion stubs for bash and zsh.
- [ ] Define profile loader behavior after command semantics are stable.
- [ ] Expand smoke tests only when new observer behavior is added.
- [ ] Decide whether `agent-init [profile] [topic]` should ever become a real
      `ready` command or remain a documented shortcut concept.
- [ ] Decide whether the documentation-only `ready` concept should become an
      executable preparation flow, and if so, what command owns it.
- [ ] Decide whether public sample profiles should become installable templates.
- [ ] Decide when `current-profile` may be written and by which command.
- [ ] Decide whether activation should use source/eval, wrapper functions, or a
      separate controller command.
- [ ] Decide whether lifecycle transitions should ever become a strict runtime
      state machine.

## Later

- [ ] Add `agent-init develop` profile loading.
- [ ] Add `agent-init stock` profile loading.
- [ ] Add `agent-init auto` context detection.
- [ ] Add `agent-init sync` for safe public/private context synchronization.
- [ ] Add tests for shell scripts and CLI behavior.
- [ ] Create private `agent-core` template structure.
