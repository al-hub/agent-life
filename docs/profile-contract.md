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

Current context selection connects a resolved profile/context to the current
project by writing an explicit marker block in the project's AI instruction
surface. The marker block may reference either a private `agent-core` context or
a public `agent-life` context after discovery resolves the selected source.

For the Codex MVP target, that surface is:

```text
<current-project>/AGENTS.md
```

The marker block should contain read-first references to the selected resolved
source files, especially the profile-local `AGENTS.md`. It should not copy or
merge private memory or public sample content into the project.

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

## Context Sources

Current implementation uses a hybrid source model:

- `agent-life` provides public-safe default contexts in
  `agent-life/profiles/*`.
- `agent-core` may provide private personal, work, company, or domain contexts
  in `agent-core/profiles/*`.
- Private contexts have highest priority.
- Public contexts are fallback/default reusable contexts.
- If the same context name exists in both places, the private
  `agent-core/profiles/<name>` context overrides the public
  `agent-life/profiles/<name>` context.
- Commands that write marker blocks should point at the selected resolved
  source path.

The discovery order for a selected context is:

```text
1. private agent-core/profiles/<context>
2. public agent-life/profiles/<context>
```

This allows a fresh install to offer reusable public contexts before a private
`agent-core` exists, while preserving the rule that private context is
user-owned and wins by name.

The marker block remains a window, not a copy. It should reference the selected
actual source path and should not copy or merge public or private context into
the current project.

Private context location:

```text
agent-core/
  profiles/
    <name>/
```

Public context location:

```text
agent-life/
  profiles/
    <name>/
```

Current public sample contexts include:

```text
develop        software development context
stock          market-analysis context
repo-review    repository review briefing context
task-brief     rough request to copy-ready Codex task brief
impl-plan      small implementation plan before editing
codex-review   review Codex output against request, scope, and safety
diff-review    pre-commit git diff risk review
work-summary   concise handoff summary for the next session
```

Future public-safe reusable contexts may include examples such as
`python-arch` or `infographic-basic`, as long as they contain no private
memory, account details, company content, or personal workflow material.

`repo-review` is the first sample context chosen for evaluating `agent-life`
itself. It is a public-safe briefing context for repo state analysis,
improvement candidates, risks, and verification habits. It is not an automatic
analysis feature.

Public default contexts should stay short and operational:

- Use one context for one work mode.
- Include one `Description:` line for future list and fzf display.
- Optionally include one `Hint:` line for marker block display.
- Prefer role, focus, avoid, output shape, and verification habit sections.
- Keep guidance public-safe and reusable across projects.
- Avoid private examples, credentials, account details, company specifics, and
  personal workflow material.
- Avoid long rule sets that over-constrain the AI.
- Remember that the marker block is a window, not a copy; public context bodies
  are referenced by source path rather than copied into project `AGENTS.md`.

`Description:` and `Hint:` serve different surfaces:

```text
Description: short human-readable summary for list/fzf display
Hint: optional one-line direction label for the selected marker block
```

`Hint:` should be brief enough to fit in one marker block bullet. It may guide
the selected context's use, but detailed behavior remains in the rest of the
source `AGENTS.md`. If `Hint:` is absent, selection keeps the existing
path-only marker block shape.

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
