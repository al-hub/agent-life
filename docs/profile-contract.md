# Profile Contract

Profiles are context workspaces, not apps.

A profile gives an AI agent a bounded area of life or work to reason within. It
stores guidance, reusable prompts, persistent memory, and temporary working
context in files that both humans and agents can read.

This contract is a lightweight convention, not a strict schema.

## Relationship To Context Names

The current runtime still uses `profiles/<name>` as the discovered directory
structure. In the emerging command-language model, that directory can be
understood as the container for a named AI-ready briefing context.

That means `profile` is the current storage and discovery term, while `context`
is the user-facing preparation meaning being considered for commands such as
`agent-init <context>` and `agent-init ready <context>`.

This does not rename directories or change runtime behavior. A future move from
`profiles/<name>` to `contexts/<name>` is unresolved.

Examples of possible context names:

```text
repo-review
python
python-arch
infographic
money-dividend
faith-nehemiah
```

Combined meanings should be represented as one context name, not as multiple
CLI arguments. The profile contract does not define automatic parsing, merging,
activation, shell mutation, or `current-profile` writes.

## Project-Local Connection Model

Future context selection may connect a profile/context from `agent-core` to the
current project by writing an explicit marker block in the project's AI
instruction surface.

For the Codex MVP target, that surface is:

```text
<current-project>/AGENTS.md
```

The marker block should contain read-first references to the selected
`agent-core/profiles/<name>` files, especially the profile-local `AGENTS.md`.
It should not copy or merge private memory into the project.

The exact marker block tokens, shape, insertion rule, update rule, remove rule,
and remove-all rollback policy are defined in
[`docs/marker-block.md`](marker-block.md).

Selection means:

- Link the current project to one named context by reference.
- Replace only the existing `agent-life` marker block when changing context.
- Keep user-authored `AGENTS.md` content outside the marker block untouched.

Selection does not mean:

- Activating a profile.
- Writing `current-profile`.
- Sourcing `profile.env`.
- Mutating shell or environment state.
- Starting tmux, sessions, daemons, or watchers.
- Copying, merging, or vendoring `agent-core` content.
- Editing anything outside the marker block.

Removal means deleting only the `agent-life` marker block from the current
project's `AGENTS.md`.

## Context Naming Convention

Context names should be stable, readable, and specific enough to imply one
briefing intent.

Rules:

- Use kebab-case.
- Use one context name for one briefing intent.
- Combine related meanings into one name when the combination is meaningful,
  such as `python-arch` or `money-dividend`.
- Prefer names a human can read and roughly understand without opening the
  profile directory.
- Avoid names that are too abbreviated to guess.
- Avoid overly broad names such as `all`, `misc`, or `general`.
- Avoid temporary names such as `temp` or `test-only`.
- Do not use reserved command names: `help`, `doctor`, `status`, `list`,
  `auto`, `version`, `ready`, `select`, `remove`, or `update`.

Good examples:

```text
work
repo-review
python
python-arch
cli
shell-cli
infographic
money-dividend
faith-nehemiah
travel-yeosu
```

Discouraged examples:

```text
python arch
work arch python
all
misc
temp
dev-stuff
```

The discouraged multi-word examples are separate CLI arguments, not one context
name. If that meaning is useful, give it one explicit context name.

## Location

Runtime profiles live in private `agent-core`:

```text
agent-core/
  profiles/
    <name>/
```

Public sample profiles may exist in `agent-life/profiles/` as templates, but
`agent-init` runtime discovery reads `agent-core/profiles/*`.

Current public sample contexts include:

```text
develop       software development context
stock         market-analysis context
repo-review   repository review briefing context
```

`repo-review` is the first sample context chosen for evaluating `agent-life`
itself. It is a public-safe briefing context for repo state analysis,
improvement candidates, risks, and verification habits. It is not an automatic
analysis feature and does not change runtime behavior.

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
