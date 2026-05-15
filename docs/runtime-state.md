# Runtime State

Runtime state is local, ephemeral machine state for `agent-life`.

It is not memory.

## Memory vs State

### Memory

Memory is persistent knowledge and context.

Use memory for:

- Long-term information
- Durable profile context
- Human-readable markdown
- AI handoff material that should survive sessions

Memory belongs in repositories:

```text
agent-life/              public framework memory
agent-core/profiles/*/   private profile memory
```

### State

State is current runtime/session information.

Use state for:

- Current or last selected profile
- Last context inspected by the runtime
- Session metadata
- Local cache
- Machine-specific runtime data

State belongs outside public git history:

```text
~/.local/state/agent-life/
```

State may be useful, but it is not durable truth. Anything important enough for
future agents to rely on should be summarized into markdown memory.

## Proposed State Directory

```text
~/.local/state/agent-life/
  current-profile
  last-context
  sessions/
  cache/
```

### `current-profile`

Future placeholder for the currently selected profile.

Current MVP behavior:

- Not written by `agent-init`.
- Not required for `status`, `list`, or `auto`.
- No strict file format is defined.

### `last-context`

Future placeholder for the last inspected context.

Current MVP behavior:

- Not written by `agent-init`.
- No strict file format is defined.

### `sessions/`

Future placeholder for local session metadata.

Current MVP behavior:

- No session restore.
- No session attach.
- No daemon.

### `cache/`

Future placeholder for derived local cache.

Current MVP behavior:

- No cache is required.
- Cache must remain reproducible or disposable.

## Current Runtime Behavior

Current `agent-init` commands may report the state path but should minimize
state persistence.

The MVP does not:

- Activate profiles
- Write `current-profile`
- Restore sessions
- Synchronize state
- Start a runtime daemon
- Source shell files
- Mutate environment variables

Shell ownership and future activation constraints are documented in
`docs/shell-boundary.md`.

Lifecycle state transition boundaries are documented in
`docs/runtime-lifecycle.md`.

## Design Principles

- Repo markdown is persistent memory/context.
- Local state is ephemeral runtime data.
- `AGENTS.md` is AI behavioral guidance.
- State files should remain human-inspectable.
- No strict state schema until runtime behavior needs it.
- Current semantic clarity wins over early activation.
