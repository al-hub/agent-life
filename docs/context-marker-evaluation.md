# Context Marker Evaluation

This document records observations about how project-local context marker
blocks affect AI behavior.

The goal is to evaluate the marker convention without turning `agent-init` into
a context classifier, controller, permission system, or runtime orchestrator.

## Current Observation

The path-only marker block was useful as an explicit project-local pointer, but
it was sometimes weak as a behavior signal.

A one-line context hint improved `task-brief` behavior. With the extra line,
Codex treated the selected context as guidance for preparing a copy-ready task
brief instead of immediately implementing the rough request. That is the
successful part of the experiment: a small project-local pointer can make the
selected context more visible to the AI session.

The same approach was only partly successful for `impl-plan`. The selected
context was meant to produce a plan before changes, but the session still moved
toward file edits. That failure matters because it shows that a short marker
line can influence behavior, but it cannot safely encode permissions or enforce
workflow boundaries.

The lesson is not to make the hint stronger by turning it into control logic.
The lesson is to keep the marker small and explicit about the selected context,
while leaving detailed behavior in the selected source `AGENTS.md`.

## Reconsidered Approach

One possible reaction was to introduce explicit fields such as:

```text
Mode
Permission
```

That direction is rejected for now.

Reason: once `agent-init` defines mode or permission categories, it starts to
look like the tool is classifying contexts, deciding what behavior is allowed,
or controlling AI workflow. That conflicts with the repository identity:

```text
explicit > magic
install != activation
observer > controller
reversible > ownership
```

`agent-life` should expose selected context through a project-local instruction
surface. It should not become an activation layer, orchestration layer,
permission model, or context taxonomy engine.

In particular, `agent-init` should not decide:

- whether a context is planning, review, implementation, or execution
- whether file edits are permitted
- whether a selected context may mutate runtime state
- which behavior branch should run for a context type

## Minimal Context Intent Direction

The next candidate convention is a minimal context intent line:

```text
Intent: <one-line statement from the context author>
```

This is different from a mode or permission field.

`Intent` is:

- optional
- one line
- authored by the context maintainer
- displayed as a small label in the marker block
- not interpreted by `agent-init`
- not used for branching, permission checks, or enforcement

`Intent` is not:

- a behavior contract
- a context category
- a permission grant
- a mutation policy
- a workflow state
- a copied context body

This keeps the distinction narrow:

```text
Description  display text for list/fzf surfaces
Intent       optional marker-block text for the current AI session
```

Both lines are authored in the selected context. `agent-init` should only
surface them in the appropriate place.

Detailed guidance remains in the selected context's source `AGENTS.md`.

## Marker Boundary

The marker block should remain a small pointer:

- selected context identity
- optional one-line intent
- source path to read first

The marker block should not contain a full copy of the context, a compact
capsule, merged instructions, private memory, mode taxonomy, or permission
model.

## Implementation Boundary

This record is documentation-only.

No `bin/agent-init` implementation change is made in this step. Current marker
block generation, selection, removal, status, fzf behavior, discovery behavior,
and shell/runtime boundaries remain unchanged.
