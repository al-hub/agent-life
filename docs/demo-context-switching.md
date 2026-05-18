# Context Switching Demo

This demo shows how `agent-init <context>`, `agent-init ready <context>`,
`agent-init status`, and `agent-init remove all` are meant to be used in a real
project.

The flow is project-local. It does not activate a profile or copy context into
the project. The current implementation connects one selected resolved context
to the current project's AI instruction surface by writing an explicit marker
block in `AGENTS.md`.

For the current Codex MVP target, the instruction surface is:

```text
<target-project>/AGENTS.md
```

The decided shortcut semantics are:

```text
agent-init <context> = agent-init select <context>
```

The explicit `agent-init select <context>` form remains available. Use
`agent-init ready <context>` when you want to preview the marker block without
writing it.

Optional selector:

```sh
agent-init fzf
```

The `fzf` flow is only a thin selector for the same commands: search contexts
from `agent-init list --tsv`, preview with `agent-init ready <context>`, press
Enter to run `agent-init select <context>`, or press Esc to quit. It is not
required for the flows below.

Manual fallback checks:

```sh
agent-init list --tsv
agent-init ready repo-review
agent-init fzf
```

If `fzf` is not installed, `agent-init fzf` should print fallback commands
instead of failing. Interactive `fzf` behavior is intentionally verified
manually, not through automated smoke tests.

## Fresh Install Flow

Public-safe contexts in `agent-life/profiles/*` are available as
fallback/default contexts. A fresh install can start with reusable contexts
before a private `agent-core` exists.

First-run shape:

```sh
cd target-project
agent-init list
agent-init ready repo-review
agent-init repo-review
codex
```

Public contexts include:

```text
repo-review
task-brief
impl-plan
codex-review
diff-review
work-summary
```

Examples:

```sh
agent-init ready task-brief
agent-init ready impl-plan
agent-init ready diff-review
```

After private `agent-core` is connected, private contexts take priority.
If both sources contain `repo-review`, the private
`agent-core/profiles/repo-review` context overrides the public
`agent-life/profiles/repo-review` context.

The marker block should point to the resolved source path. It remains a window,
not a copy, and should not copy, merge, or persist public or private context
into the project.

## Fzf Context Selector

Use `agent-init fzf` when you want a single-screen selector for discovered
contexts:

```sh
cd target-project
agent-init fzf
```

In the selector:

- Type to search context names and descriptions.
- Read the preview window, which is powered by `agent-init ready <context>`.
- Press Enter to run `agent-init select <context>`.
- Press Esc to quit without changing project files.

The same work is always available without `fzf`:

```sh
agent-init list
agent-init ready <context>
agent-init select <context>
agent-init <context>
agent-init remove all
```

`fzf` is optional convenience UI. It is a wrapper around marker block
management commands, not a separate runtime. It does not modify `agent-core`,
merge contexts, rename contexts, multi-select contexts, activate profiles,
write `current-profile`, mutate shell state, start sessions, or change the
meaning of `ready`, `select`, `status`, or `remove`.

The MVP does not provide remove/status keybindings, rename, alias management,
multi-select, context merge, or command palette behavior. Those remain explicit
commands or future candidates. In particular, renaming a context could mutate
private `agent-core` directories and break existing references, so it is not
part of the selector.

`remove all` stays an explicit command:

```sh
agent-init remove all
```

The marker block is a window, not a copy. It points the project `AGENTS.md` at
one selected resolved context without copying or merging context content.

## Basic Flow

Move into the project where the AI will work:

```sh
cd target-project
```

Check the current framework, core, project, and selected-context state:

```sh
agent-init status
```

List discovered contexts:

```sh
agent-init list
```

Optionally search and select from one screen:

```sh
agent-init fzf
```

Select a context for this project:

```sh
agent-init repo-review
```

Start Codex from the same project:

```sh
codex
```

After the work is done, remove the project-local selection:

```sh
agent-init remove all
```

## Repo Review Example

Use this when the next AI session should review the current repository with the
`repo-review` context.

```sh
cd target-project
agent-init status
agent-init list
agent-init repo-review
codex
```

Inside Codex, ask the task normally:

```text
현재 repo 상태를 분석하고, 다음 개선 후보와 리스크를 제안해줘.
```

When finished:

```sh
agent-init remove all
```

Equivalent explicit select form:

```sh
agent-init select repo-review
```

## Infographic Format Switching

This example shows the intended switching shape when two private contexts define
different output formats.

With `fzf`:

```sh
cd target-project
agent-init fzf
```

In `fzf`, choose `infographic-format-a`.

```sh
codex
```

Inside Codex:

```text
문서1.doc를 인포그래픽 format A로 만들어줘
```

Switch the same project to another context:

```sh
agent-init fzf
```

In `fzf`, choose `infographic-format-b`.

```sh
codex
```

```text
문서1.doc를 인포그래픽 format B로 만들어줘
```

Clean up the project-local selection:

```sh
agent-init remove all
```

Preview either marker block without writing it:

```sh
agent-init ready infographic-format-a
agent-init ready infographic-format-b
```

Equivalent explicit select forms:

```sh
agent-init infographic-format-a
agent-init infographic-format-b
agent-init select infographic-format-a
agent-init select infographic-format-b
```

## Development Context Switching

This example shows the same project being reviewed through language-specific
and architecture-focused contexts.

With `fzf`, choose `cpp-review`, start Codex, then repeat with `java-review`
and `arch-review`:

```sh
cd target-project
agent-init fzf
```

In `fzf`, choose `cpp-review`.

```sh
codex
```

```text
C++ 코드 구조와 위험을 점검해줘
```

Switch to the Java review context:

```sh
agent-init fzf
```

In `fzf`, choose `java-review`.

```sh
codex
```

```text
Java 쪽 영향과 인터페이스를 점검해줘
```

Switch to the architecture review context:

```sh
agent-init fzf
```

In `fzf`, choose `arch-review`.

```sh
codex
```

```text
전체 구조 관점에서 개선 후보를 제안해줘
```

Clean up when finished:

```sh
agent-init remove all
```

Preview without writing:

```sh
agent-init ready cpp-review
agent-init ready java-review
agent-init ready arch-review
```

Equivalent explicit select forms:

```sh
agent-init cpp-review
agent-init java-review
agent-init arch-review
agent-init select cpp-review
agent-init select java-review
agent-init select arch-review
```

## Preview Versus Select

`agent-init ready <context>` prints the marker block to stdout and does not
modify project files.

`agent-init <context>` is the shortcut for
`agent-init select <context>`.

`agent-init select <context>`:

- requires `agent-core/profiles/<context>/AGENTS.md` to exist
- creates or updates only the `agent-life` marker block in the current
  project's `AGENTS.md`
- stores a read-first reference to the selected context
- replaces the previous `agent-life` marker block when another context is
  selected
- preserves content outside the marker block

`select` is not activation. It does not source environment, write
`current-profile`, start a session, attach tmux, run a daemon, or mutate shell
state.

The marker block is a window, not a copy. It points Codex toward the selected
`agent-core` context without copying or merging private content.

## What Remove All Does

`agent-init remove all` removes only the `agent-life` marker block.

If the project already had `AGENTS.md` content outside the marker block, that
content is preserved.

If `select` created an `AGENTS.md` containing only the marker block and
whitespace, `remove all` may delete that file as rollback.

## What Is Not Copied

The selected `agent-core` context is linked by reference only.

`agent-life` does not copy, merge, parse, or persist private `agent-core`
content into the project. Codex reads the project `AGENTS.md`, then follows the
read-first reference recorded in the marker block.
