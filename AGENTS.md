# AGENTS.md

This file is the operating guide for future AI sessions working in `agent-life`.

## Mission

Maintain `agent-life` as the public runtime/bootstrap repository for a personal
AI operating system. Keep private memory, prompts, RAG content, account details,
and personal workflows in `agent-core`.

## Public / Private Boundary

Allowed in `agent-life`:

- Bootstrap scripts
- Public CLI framework
- Shell integration
- Documentation
- Shared command conventions
- Non-sensitive profile names and interfaces
- Minimal non-sensitive sample profile templates

Not allowed in `agent-life`:

- Secrets, tokens, API keys, credentials
- Private prompts or personal memory
- RAG source material
- Financial account details
- Faith, travel, development, or personal workflow content
- Private repo contents copied from `agent-core`

## AGENTS.md Hierarchy

Root `AGENTS.md` defines repository-wide rules for `agent-life`: public/private
boundaries, CLI principles, and maintenance expectations.

Profile `AGENTS.md` files define local behavior for one profile workspace, such
as `develop` or `stock`.

Current MVP behavior:

- No inheritance logic is implemented.
- No merge logic is implemented.
- No semantic parsing is implemented.
- Agents should read root and relevant profile guidance directly.

## Working Rules

- Preserve user changes. Do not revert unrelated edits.
- Prefer small, inspectable changes.
- Keep markdown executable: decisions, state, and next actions should help the
  next agent continue work.
- When changing architecture, update `DECISIONS.md`.
- When changing current context, update `CONVERSATION.md`.
- When leaving follow-up work, update `NEXT.md`.
- Keep public/private boundaries explicit in docs and code.

## CLI Rules

`agent-init` follows a human-friendly command model:

- Command means action.
- Argument means target.
- Options are rare.
- Complex behavior moves to config files.
- Defaults should be discoverable by `agent-init status` and `agent-init doctor`.

Good command shapes:

```text
agent-init develop
agent-init stock
agent-init auto
agent-init status
agent-init sync
agent-init doctor
```

Avoid option-heavy commands unless there is a strong reason.

## Implementation Defaults

- Default `agent-core` layout is a sibling private repo: `../agent-core`.
- `agent-core` is not a submodule by default.
- Discovery order is `AGENT_CORE_PATH`, `~/.agent-life/config`
  `default-core-path`, `../agent-core`, `~/.agent-core`.
- Core discovery implementation lives in internal `lib/core-discovery.sh`.
- `install.sh` should be safe to run repeatedly.
- Bootstrap code must not print or persist secrets.

## Session Handoff

Before ending substantial work, leave the repo in a state where another agent can
answer these questions quickly:

- What is this repo for?
- What has already been decided?
- What is the next concrete action?
- Where is private context expected to live?
- What commands should exist and what should they do?
