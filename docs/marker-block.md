# AGENTS.md Marker Block

This document defines the project-local marker block that `agent-init select`
and `agent-init remove all` use, plus the candidate direction for adding an
optional one-line context intent.

The current MVP supports the Codex target through the current project's
`AGENTS.md` file only.

## Purpose

The marker block connects one selected context to the current project's AI
instruction surface. The selected source may be a private `agent-core` context
or a public `agent-life` context.

The marker block is the canonical representation of an `agent-life` context
connection.

Marker block is a window, not a copy.

For the Codex MVP target, the instruction surface is:

```text
<current-project>/AGENTS.md
```

Selection is reference-only. It does not copy, merge, classify, or parse
selected context content. The block should stay small and contain only enough
information to point the AI toward the selected source.

A selected context may eventually expose an optional one-line `Intent:` in its
source `AGENTS.md`. When present, the marker block may include that one line as
a small intent label. The intent is not a copied context body, semantic
contract, mode, permission grant, or value that `agent-init` interprets.

If no intent exists, the marker block keeps the path-only shape.

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

Future `agent-init fzf` is only an optional selector wrapper around the same
marker block commands. It should preview this block with
`agent-init ready <context>` and select by invoking
`agent-init select <context>`. It must not create a second marker format or
copy `agent-core` contents.

Candidate `Intent:` shape:

```markdown
<!-- agent-life:start -->
## Agent-life selected context

Selected context:
- <context>

Intent:
- <optional one-line intent from the selected source AGENTS.md>

Read first:
- <resolved-source>/profiles/<context>/AGENTS.md

Rules:
- Treat this context as guidance for the current AI session.
- Follow project AGENTS.md and selected context together.
- This is not activation, orchestration, or shell/runtime mutation.
<!-- agent-life:end -->
```

`<context>` is the selected context name.

`<resolved-source>` is the selected actual source root, either the discovered
private `agent-core` path or the public `agent-life` framework path.

The `Intent:` section is optional. It appears only when the selected source
`AGENTS.md` has a non-empty first `Intent:` line. If no intent exists, the block
keeps the path-only shape and omits the section entirely. Commands must use
only one intent line and must not copy any other source content into the marker
block.

`agent-init` must not interpret the intent value, branch on it, classify the
context from it, or use it to decide file modification permission. It only
surfaces the author-provided one-line text in the marker block.

Current implementation note: this step does not change marker block generation.
Replacing the earlier experimental `Hint:` surface with `Intent:` is a separate
future implementation candidate.

Example:

```markdown
<!-- agent-life:start -->
## Agent-life selected context

Selected context:
- task-brief

Intent:
- Prepare a copy-ready task brief from the user request.

Read first:
- /home/al-hub/.agent-life/framework/profiles/task-brief/AGENTS.md

Rules:
- Treat this context as guidance for the current AI session.
- Follow project AGENTS.md and selected context together.
- This is not activation, orchestration, or shell/runtime mutation.
<!-- agent-life:end -->
```

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
- Copy full context bodies into the project.
- Parse or merge private memory automatically.
- Implement multi-line mode contracts or compact capsules.
- Implement a context taxonomy, mode model, or permission model.
- Enforce file modification permission from marker block fields.
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
