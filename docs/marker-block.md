# AGENTS.md Marker Block

This document defines the project-local marker block that `agent-init select`
and `agent-init remove all` use.

The current MVP supports the Codex target through the current project's
`AGENTS.md` file only.

## Purpose

The marker block connects one selected `agent-core` context to the current
project's AI instruction surface.

The marker block is the canonical representation of an `agent-life` context
connection.

Marker block is a window, not a copy.

For the Codex MVP target, the instruction surface is:

```text
<current-project>/AGENTS.md
```

Selection is reference-only. It does not copy, merge, or parse private
`agent-core` content. The block should stay small and contain only enough
information to point the AI toward the selected `agent-core` context.

## Tokens

Start token:

```text
<!-- agent-life:start -->
```

End token:

```text
<!-- agent-life:end -->
```

The complete selected-context region is the inclusive range from the start
token through the end token.

There must be at most one `agent-life` marker block in a project `AGENTS.md`.

## Block Shape

`agent-init ready <context>` previews this shape on stdout.

`agent-init select <context>` writes this shape to the current project's
`AGENTS.md`.

`agent-init <context>` is the decided shortcut for
`agent-init select <context>`.

```markdown
<!-- agent-life:start -->
## Agent-life selected context

Selected context:
- <context>

Read first:
- <agent-core>/profiles/<context>/AGENTS.md

Rules:
- Treat this context as guidance for the current AI session.
- Do not modify agent-core files unless explicitly asked.
- Follow project AGENTS.md and selected context together.
- This is not activation, orchestration, or shell/runtime mutation.
<!-- agent-life:end -->
```

`<context>` is the selected context name.

`<agent-core>` is the discovered private core path.

## Insert Rule

If the current project already has `AGENTS.md` and no `agent-life` marker block,
`select` appends the marker block to the end of the file.

The append should preserve all existing content exactly, except for adding a
separating blank line before the marker block when needed.

`select` must not reorder, rewrite, normalize, or format existing
`AGENTS.md` content.

`ready <context>` must not insert anything. It is a dry-run marker block
preview.

## Create Rule

If the current project has no `AGENTS.md`, `select` may create one containing
only the marker block.

That file is considered fully owned by the marker block only while it contains
no content outside the start/end tokens.

## Update Rule

If `AGENTS.md` already contains one complete `agent-life` marker block,
`select <context>` replaces only the inclusive marker block range.

It must preserve all content before the start token and after the end token
exactly.

If multiple marker blocks exist, if only one token exists, or if the end token
appears before the start token, commands refuse to modify the file and print
manual repair guidance.

## Remove Rule

`agent-init remove all` removes only the inclusive marker block range.

It must preserve all content before the start token and after the end token
exactly.

It must not delete user-authored project guidance outside the marker block.

## Remove All Policy

If `AGENTS.md` was created by `select` and contains only the marker block plus
whitespace, `remove all` may delete the whole `AGENTS.md` file.

If `AGENTS.md` contains any content outside the marker block, `remove all` must
keep the file and remove only the marker block.

This is the rollback rule for a selection that created a new project
`AGENTS.md`.

## Forbidden Behavior

Marker block commands must not:

- Rewrite the whole `AGENTS.md`.
- Modify content outside the marker block.
- Copy or merge `agent-core` file contents into the project.
- Parse or merge private memory automatically.
- Activate profiles.
- Source `profile.env`.
- Write `current-profile`.
- Mutate shell or environment state.
- Start tmux sessions, daemons, watchers, or orchestration.

`ready <context>` must also not write project files. `select <context>` may
write or update only the inclusive marker block range in the current project's
`AGENTS.md`.

## Status Semantics

`agent-init status` may report:

- no project `AGENTS.md`
- project `AGENTS.md` exists with no selected context
- selected context found in the `agent-life` marker block
- malformed marker block requiring manual repair
- selected context source path
- warning when the selected context source path is missing

Status must be read-only.

Status may read only:

- the current project path
- whether `<current-project>/AGENTS.md` exists
- whether the start and end marker tokens exist
- the inclusive marker block content between the tokens
- the first `Selected context:` list item inside the marker block
- the first `Read first:` path inside the marker block
- whether the referenced context source path exists

Status must not:

- rewrite `AGENTS.md`
- repair malformed marker blocks
- add missing fields
- expand the marker block
- parse or merge referenced `agent-core` content
- infer context from text outside the marker block
- modify runtime state

If no complete marker block exists, status should report selected context as
`none`.
