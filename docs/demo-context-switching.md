# Context Switching Demo

This demo shows how `agent-init <context>`, `agent-init ready <context>`,
`agent-init status`, and `agent-init remove all` are meant to be used in a real
project.

The flow is project-local. It does not activate a profile or copy private
context into the project. It connects one selected `agent-core` context to the
current project's AI instruction surface by writing an explicit marker block in
`AGENTS.md`.

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

## Basic Flow

Move into the project where the AI will work:

```sh
cd target-project
```

Check the current framework, core, project, and selected-context state:

```sh
agent-init status
```

List contexts discovered from `agent-core`:

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

```sh
cd target-project
agent-init infographic-format-a
codex
```

Inside Codex:

```text
문서1.doc를 인포그래픽 format A로 만들어줘
```

Switch the same project to another context:

```sh
agent-init infographic-format-b
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
agent-init select infographic-format-a
agent-init select infographic-format-b
```

## Development Context Switching

This example shows the same project being reviewed through language-specific
and architecture-focused contexts.

```sh
cd target-project
agent-init cpp-review
codex
```

```text
C++ 코드 구조와 위험을 점검해줘
```

Switch to the Java review context:

```sh
agent-init java-review
codex
```

```text
Java 쪽 영향과 인터페이스를 점검해줘
```

Switch to the architecture review context:

```sh
agent-init arch-review
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
