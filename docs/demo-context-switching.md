# Context Switching Demo

This demo shows how `agent-init select`, `agent-init status`, and
`agent-init remove all` are meant to be used in a real project.

The flow is project-local. It does not activate a profile or copy private
context into the project. It connects one selected `agent-core` context to the
current project's AI instruction surface by writing an explicit marker block in
`AGENTS.md`.

For the current Codex MVP target, the instruction surface is:

```text
<target-project>/AGENTS.md
```

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

Select a context for this project:

```sh
agent-init select repo-review
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
agent-init select repo-review
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

## Infographic Format Switching

This example shows the intended switching shape when two private contexts define
different output formats.

```sh
cd target-project
agent-init select infographic-format-a
codex
```

Inside Codex:

```text
문서1.doc를 인포그래픽 format A로 만들어줘
```

Switch the same project to another context:

```sh
agent-init select infographic-format-b
codex
```

Inside Codex:

```text
문서1.doc를 인포그래픽 format B로 만들어줘
```

Clean up the project-local selection:

```sh
agent-init remove all
```

## Development Context Switching

This example shows the same project being reviewed through two different
language-focused contexts.

```sh
cd target-project
agent-init select cpp-review
codex
```

Inside Codex:

```text
C++ 코드 구조와 위험을 점검해줘
```

Switch to the Java review context:

```sh
agent-init select java-review
codex
```

Inside Codex:

```text
Java 쪽 영향과 인터페이스를 점검해줘
```

Clean up when finished:

```sh
agent-init remove all
```

## What Select Does

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
