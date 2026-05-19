# Context Marker Evaluation

This document records observations about how project-local context marker
blocks affect AI behavior.

The goal is to evaluate the marker convention without turning `agent-init` into
a context classifier, controller, permission system, or runtime orchestrator.

## Current Observation

The path-only marker block was useful as an explicit project-local pointer, but
it was sometimes weak as a behavior signal.

A one-line context hint improved `task-brief` behavior. With the extra line,
Codex treated the selected context as guidance for producing a copy-ready task
brief instead of immediately implementing the rough request.

The same approach was only partly successful for `impl-plan`. The selected
context was meant to produce a plan before changes, but the session still moved
toward file edits. That failure matters because it shows that a short marker
line can influence behavior, but it cannot safely encode permissions or enforce
workflow boundaries.

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
