# Local Config

`agent-life` supports one optional local config file:

```text
~/.agent-life/config
```

The config file is a local preference file. It is not runtime state and does not
mean activation, session persistence, shell ownership, or orchestration.

The default flow works without this file.

## Format

The format is simple `key=value` text:

```text
# agent-life local preferences
default-core-path=~/workspace/agent-core
verbose-default=false
install-root=~/.agent-life
```

Blank lines and lines beginning with `#` are ignored.

Malformed lines may be ignored. There is no strict schema system, and this repo
does not use JSON, YAML, or TOML for local preferences.

## Current Supported Key

### `default-core-path`

Optional path to private `agent-core`.

Example:

```text
default-core-path=~/workspace/agent-core
```

This is used only for core discovery when `AGENT_CORE_PATH` is not set.

## Reserved Preference Examples

These keys describe intended local preference semantics, but they should stay
lightweight and non-owning:

```text
verbose-default=false
install-root=~/.agent-life
```

Current runtime behavior does not depend on these keys.

## Core Discovery Order

`agent-init` discovers `agent-core` in this order:

1. `AGENT_CORE_PATH`
2. `~/.agent-life/config` key `default-core-path`
3. `../agent-core`
4. `~/.agent-core`

`AGENT_CORE_PATH` remains the most explicit per-command override.

This order is implemented by an internal shell helper shared by `agent-init` and
the bootstrap script. The helper is a private implementation detail, not a
dynamic provider or plugin system.

## Create Manually

The bootstrap script does not create config files.

Create one only if you want a local preference:

```sh
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$HOME/workspace/agent-core" > "$HOME/.agent-life/config"
```

Inspect discovery:

```sh
$HOME/.agent-life/framework/bin/agent-init doctor --verbose
```

## Non-Goals

Local config must not introduce:

- profile activation
- `current-profile` writes
- session persistence semantics
- shell rc modification
- PATH mutation
- alias injection
- shell hook integration
- tmux/session orchestration
- daemons or watchers
- AGENTS semantic parsing

Configuration is explicit local preference, not hidden automation.

## Remove

Remove local preferences:

```sh
rm -f "$HOME/.agent-life/config"
```

This does not remove the framework checkout or private `agent-core`.
