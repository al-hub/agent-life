# Quickstart

This is the minimal first-run flow for `agent-life`.

The repo is an AI-readable operational workspace. The CLI is a lightweight
observer and recommender. Install does not mean activation.

## 1. Bootstrap The Framework

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
```

Default install path:

```text
~/.agent-life/framework
```

The installer prints the clone/update target path, performs lightweight
validation, and exits.

It does not edit `PATH`, shell rc files, aliases, symlinks, runtime state, or
profile activation state.

## 2. Confirm The Framework

```sh
$HOME/.agent-life/framework/bin/agent-init doctor
```

`doctor` is diagnostics-first. It reports what it can see and gives warnings
without repairing, activating, switching, or writing runtime state.

## 3. Add Private Core

`agent-core` is private. It contains prompts, memory, profile context, and
personal workflows.

Common development layout:

```text
~/workspace/
  agent-life/
  agent-core/
```

Example clone shape:

```sh
mkdir -p "$HOME/workspace"
git clone <private-agent-core-url> "$HOME/workspace/agent-core"
```

`agent-life` does not clone private repositories for you.

## 4. Optionally Set AGENT_CORE_PATH

If your private core is not discoverable as `../agent-core` or `~/.agent-core`,
run commands with `AGENT_CORE_PATH`:

```sh
AGENT_CORE_PATH="$HOME/workspace/agent-core" \
  "$HOME/.agent-life/framework/bin/agent-init" doctor
```

Manual shell example:

```sh
export AGENT_CORE_PATH="$HOME/workspace/agent-core"
```

This is optional and user-owned. The installer does not write it to shell rc
files.

Optional local config example:

```sh
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$HOME/workspace/agent-core" > "$HOME/.agent-life/config"
```

This is also manual and local. The default flow works without config.

## 5. List Profiles

```sh
$HOME/.agent-life/framework/bin/agent-init list
```

Profiles are discovered from:

```text
agent-core/profiles/*
```

The current CLI treats profiles as directories. It does not parse `AGENTS.md`,
source `profile.env`, activate environments, or read private memory.

## 6. Ask For A Recommendation

```sh
$HOME/.agent-life/framework/bin/agent-init auto
```

`auto` recommends only when the local context is unambiguous. It does not switch
profiles, write `current-profile`, restore sessions, or start orchestration.

## Optional PATH Guidance

To run `agent-init` without the full path, you may choose to manage PATH in your
own shell configuration:

```sh
export PATH="$HOME/.agent-life/framework/bin:$PATH"
```

This is manual. The bootstrap script does not modify PATH automatically.

## Update

Run the bootstrap script again:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
```

Existing installs are updated with a best-effort `git pull --ff-only`. If the
pull fails, the checkout is left in place for manual inspection.

## Remove

Remove the public framework checkout:

```sh
rm -rf "$HOME/.agent-life/framework"
```

This does not remove private `agent-core` data or shell configuration you may
have created manually.

## Troubleshooting

Check framework and core discovery first:

```sh
$HOME/.agent-life/framework/bin/agent-init doctor --verbose
```

If profiles are missing, confirm your private core path:

```sh
AGENT_CORE_PATH="$HOME/workspace/agent-core" \
  "$HOME/.agent-life/framework/bin/agent-init" list
```

Or inspect local config discovery:

```sh
$HOME/.agent-life/framework/bin/agent-init doctor --verbose
```

If `agent-init` is not found, run it by absolute path or add PATH manually.
