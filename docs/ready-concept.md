# Ready Concept

`ready` is a future preparation flow for AI work contexts.

It describes what `agent-init` should prepare before work begins:

- detected framework
- detected core
- selected or suggested profile
- relevant files to read first
- boundary reminders
- suggested verification commands
- a task brief skeleton

`ready` does not run the task.
It does not activate a profile.
It does not mutate shell state, environment variables, or runtime state.
It does not manage tmux sessions, daemons, or orchestration.

## Relationship To The CLI Shortcut

The user-facing future shortcut shape is:

```text
agent-init [profile] [topic]
```

Its intended internal meaning is:

```text
agent-init ready [profile] [topic]
```

That relationship is documented here only.
It is not implemented in the current MVP.

## Example Shape

```text
Framework: detected
Core: detected
Profile: develop

Read first:
- README.md
- docs/cli.md
- agent-core/profiles/develop/AGENTS.md

Boundary reminders:
- do not activate profiles
- do not write current-profile
- do not mutate shell state
- do not start orchestration

Suggested verification:
- ./bin/agent-init doctor
- ./bin/agent-init status
- sh tests/smoke/run.sh

Task brief:
Summarize the current goal, constraints, and next action.
```

This document is for meaning and boundary definition only.
*** Update File: /home/al-hub/workspace/agent-life/docs/cli.md
@@
 Built-in commands are reserved words. Everything else is treated as future
 profile shortcut space, not a current activation path.
 
+For the future preparation flow concept, see `docs/ready-concept.md`.
+
 ## Design Rules
@@
 ### `agent-init help`
 
 Show the command surface and design rules.
 
 Current behavior:
 
 - Prints reserved built-in commands and the future convenience shortcut concept.
 - Keeps syntax simple and action-centered.
+- Points to the future `ready` concept as documentation only.
@@
 ### `agent-init [profile] [topic]`
 
 Semantic: placeholder.
 
 Future direction:
 
- May act as a user-friendly shortcut to a future preparation-only `ready` flow.
+- May act as a user-friendly shortcut to a future preparation-only `ready` flow.
 - May prepare a work context for a profile and optional topic.
 - May be used without arguments as a future auto-ready concept.
 - Planned shortcut for `agent-init ready [profile] [topic]`.
 - Does not define `current-profile` write behavior yet.
+
+See `docs/ready-concept.md` for the intended preparation boundary.
*** Update File: /home/al-hub/workspace/agent-life/docs/command-semantics.md
@@
 `agent-init` commands are intentionally simple. The current MVP is centered on
 inspection and discovery, not activation.
 
 Built-in commands are reserved words. Profile names must not reuse them.
+
+The future `ready` concept is documented in `docs/ready-concept.md`.
@@
 ### `agent-init help`
@@
 Current behavior:
 
 - Prints current commands.
 - Explains the current observer/recommender role.
 - Shows the future convenience shortcut concept.
+- Does not implement `ready`.
 - Does not inspect private memory.
 - Does not write state.
@@
 ### `agent-init [profile] [topic]`
@@
 Future direction:
 
 - May act as a user-friendly shortcut to a future preparation-only `ready` flow.
 - May prepare a work context for a profile and optional topic.
 - May be used without arguments as a future auto-ready concept.
 - Planned shortcut for `agent-init ready [profile] [topic]`.
 
 Current stage:
 
 - Not implemented.
 - Not a profile activation command.
 - Not a shell activation command.
 - Not a session restore command.
 - Not a `current-profile` write command.
 - Does not define `current-profile` write behavior yet.
+
+The shortcut remains a documentation-only concept until a future implementation
+decision is made.
