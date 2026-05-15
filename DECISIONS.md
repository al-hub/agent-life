# DECISIONS.md

This file records durable decisions. Keep it short and update it when direction
changes.

## Decisions

### 2026-05-16: Split public bootstrap and private brain

`agent-life` is the public repo. It contains bootstrap scripts, CLI framework,
shell integration, public docs, and shared command conventions.

`agent-core` is the private repo. It contains prompts, memory, RAG, personal
workflows, and domain profiles.

Reason: future AI sessions need stable public runtime structure without exposing
private context.

### 2026-05-16: Use markdown as runtime memory

Markdown files in this repo act as AI-readable persistent context. They should
capture state, decisions, and next actions in a form another agent can execute.

Reason: markdown is portable across ChatGPT, Codex, Claude, local LLMs, GitHub,
and terminal workflows.

### 2026-05-16: CLI name is `agent-init`

The primary CLI entry point is `agent-init`.

Reason: the command expresses session/runtime initialization and leaves room for
profile targets like `develop`, `stock`, and `auto`.

### 2026-05-16: CLI is command-centered

Command means action. Argument means target. Options stay minimal. Complex
configuration belongs in config files.

Reason: the CLI should be human-friendly and easy for agents to invoke without
remembering option-heavy syntax.

### 2026-05-16: `agent-core` is not a submodule by default

`agent-core` is connected as a sibling private repo or through explicit path
configuration. It is not vendored or embedded into `agent-life` by default.

Discovery order:

1. `AGENT_CORE_PATH`
2. future `agent-life` config
3. `../agent-core`
4. `~/.agent-core`

Reason: sibling repos preserve the public/private boundary, avoid submodule
friction, and reduce the chance that private memory is treated as public repo
content.

### 2026-05-16: `agent-init` MVP stays bash-only

The first `agent-init` implementation is a simple bash script. It avoids Python
orchestration, tmux control, shell activation, RAG, LLM integration, and session
restore.

Reason: the current goal is to validate the command-centered CLI shape and
runtime boundaries before adding heavier orchestration.

### 2026-05-16: Profiles are discovered, not hardcoded

Profiles are recognized by scanning `agent-core/profiles/*` directories. Public
framework code should not hardcode profile names as behavior.

Reason: private core owns profile inventory and personal context.
