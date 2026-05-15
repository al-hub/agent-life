# Profile Contract

Profiles are context workspaces, not apps.

A profile gives an AI agent a bounded area of life or work to reason within. It
stores guidance, reusable prompts, persistent memory, and temporary working
context in files that both humans and agents can read.

This contract is a lightweight convention, not a strict schema.

## Location

Runtime profiles live in private `agent-core`:

```text
agent-core/
  profiles/
    <name>/
```

Public sample profiles may exist in `agent-life/profiles/` as templates, but
`agent-init` runtime discovery reads `agent-core/profiles/*`.

## Minimal Structure

```text
profiles/<name>/
  AGENTS.md
  prompts/
  memory/
  context/
  profile.env
```

Each non-hidden directory under `profiles/` is a profile name. The directory
name is the profile identifier.

## File Roles

### `AGENTS.md`

Profile-local AI behavior rules.

Use it for:

- Working style
- Domain-specific guidance
- Boundaries for this profile
- Preferred outputs or review habits

Do not use it for secrets, credentials, or large private source material.

### `prompts/`

Reusable prompt snippets for the profile.

Examples:

- Review prompts
- Planning prompts
- Research prompts
- Domain-specific agent instructions

### `memory/`

Persistent knowledge and context.

Use it for durable profile memory that should survive across sessions. Keep it
human-readable and easy to edit.

### `context/`

Temporary working notes and ephemeral task state.

Use it for active work that may be summarized into `memory/` later. Do not treat
it as the source of durable truth.

### `profile.env`

Future runtime variable placeholder.

Current MVP behavior:

- File may exist.
- It is not sourced.
- It is not parsed.
- It must not contain secrets in public samples.

## AGENTS.md Hierarchy

Root `AGENTS.md` defines repository-wide rules for `agent-life`.

Profile `AGENTS.md` defines local rules for a specific profile workspace.

Current MVP behavior:

- No inheritance logic is implemented.
- No merge logic is implemented.
- No semantic parsing is implemented.
- Agents should read the relevant files directly and apply them with human
  judgment.

Future behavior may formalize hierarchy, but the current priority is simple,
inspectable markdown.

## Non-Goals

The profile contract does not implement:

- Shell sourcing
- Environment mutation
- tmux orchestration
- RAG indexing
- LLM integration
- AGENTS.md inheritance or merge behavior
- Semantic validation beyond directory/file existence

## Design Principles

- Profile is a context workspace.
- Markdown is runtime memory.
- Humans must be able to read and edit everything.
- Private content belongs in `agent-core`.
- Public samples must stay minimal and non-sensitive.
- Current simplicity wins over future abstraction.
