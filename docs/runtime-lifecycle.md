# Runtime Lifecycle

The runtime lifecycle is conceptual vocabulary, not a strict state machine.

It describes how `agent-life` thinks about runtime progression before activation
or orchestration exists. The current CLI is an inspector and recommender, not a
runtime controller or orchestrator.

## Current MVP Lifecycle

```text
discover -> inspect -> recommend
```

Current implemented behavior:

- Discover framework, core, state path, and profile directories.
- Inspect runtime facts.
- Diagnose runtime readiness without repairing it.
- Recommend a profile when the choice is unambiguous.

Current unimplemented behavior:

- activate
- attach
- switch
- sync
- restore
- shutdown
- runtime mutation
- session orchestration

## Future Conceptual Lifecycle

```text
discover -> inspect -> recommend -> activate -> attach -> switch -> sync -> restore -> shutdown
```

This is not an execution guarantee and not a required ordered pipeline. Real
future flows may skip, repeat, or reorder steps.

## Lifecycle Vocabulary

### Discover

Find runtime components.

Examples:

- Find `agent-life` root.
- Find `agent-core`.
- Find local state path.
- Find profile directories.

Current status: implemented in MVP commands.

### Inspect

Read and report runtime facts without changing runtime state.

Examples:

- Show framework path.
- Show core path and source.
- Show state path.
- Show discovered profiles.

Current status: implemented by `help`, `status`, `list`, and `version`.

### Recommend

Suggest a profile or next runtime action without switching or activation.

Examples:

- Recommend `develop` when the current directory clearly matches it.
- Report no recommendation when profile choice is ambiguous.

Current status: implemented by `auto`.

### Activate

Prepare shell or runtime environment for a profile.

Possible future behavior:

- Shell/env mutation
- Profile-specific runtime preparation
- Possible `current-profile` write

Current status: semantic placeholder. Not implemented. Not fully resolved.

### Attach

Connect to an existing runtime or session.

Possible future behavior:

- Join an existing session.
- Attach to a runtime workspace.
- Connect to orchestration such as tmux.

Current status: semantic placeholder. Not implemented. Not fully resolved.

### Switch

Change active context from one profile to another.

Possible future behavior:

- Update active runtime context.
- Possibly update `current-profile`.
- Coordinate with activation semantics.

Current status: semantic placeholder. Not implemented. `current-profile`
transition semantics are not fully defined.

### Sync

Move or summarize safe context between layers.

Possible future behavior:

- Sync public summaries.
- Keep private memory in `agent-core`.
- Avoid copying private context into `agent-life`.

Current status: intentionally vague. Not implemented.

### Restore

Recover a previous runtime/session context.

Possible future behavior:

- Read session metadata.
- Rehydrate a workspace.
- Reconnect to prior runtime state.

Current status: intentionally vague. Not implemented.

### Shutdown

End or clean up a runtime/session.

Possible future behavior:

- Stop runtime resources.
- Clear temporary state.
- Leave durable notes in memory.

Current status: intentionally vague. Not implemented.

## State Transition Policy

Current MVP commands should not perform state transitions.

Allowed now:

- Discover paths.
- Inspect facts.
- Recommend a profile.
- Print human-readable output.

Not allowed now:

- Write `current-profile`.
- Mutate shell state.
- Start or attach to sessions.
- Run tmux orchestration.
- Start daemons or watchers.
- Automatically sync memory or state.
- Parse `AGENTS.md` semantically.

## Relationship To Shell Boundary

Activation and switching may require shell ownership decisions because child
processes cannot mutate parent shell state.

See `docs/shell-boundary.md`.

Until shell ownership is designed, lifecycle stages beyond recommendation remain
conceptual.

## Design Principles

- Lifecycle vocabulary clarifies meaning before implementation.
- Current lifecycle is intentionally incomplete.
- Steps are conceptual relationships, not a strict FSM.
- Runtime mutation ownership remains unresolved.
- Markdown remains persistent memory.
- Local state remains machine-local and ephemeral.
- Semantic clarity wins over automation.
