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

## Next

- [ ] Add reusable core discovery helper using `AGENT_CORE_PATH`, config,
      `../agent-core`, and `~/.agent-core`.
- [ ] Decide config filename and schema for public bootstrap settings.
- [ ] Decide the canonical public raw `install.sh` URL after repository remote
      is final.
- [ ] Add shell completion stubs for bash and zsh.
- [ ] Define profile loader behavior after command semantics are stable.
- [ ] Add tests for `agent-init` command output.
- [ ] Add tests for `agent-init doctor` diagnostics output.
- [ ] Add tests for output consistency across `status`, `list`, and `doctor`.
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
