# Bootstrap

`install.sh` is the external bootstrap fetcher for `agent-life`.

It supports both local repo execution and `curl | bash` style execution. Its job
is to make the public framework checkout available at a predictable path, then
print manual next steps.

It is not runtime activation.

## Default Install Location

Default path:

```text
~/.agent-life/framework
```

This path is intentionally user-local. The bootstrap flow does not assume sudo
or system-wide installation.

The target can be overridden explicitly:

```sh
AGENT_LIFE_INSTALL_DIR=/path/to/agent-life ./install.sh
```

The repository URL can be overridden explicitly:

```sh
AGENT_LIFE_REPO_URL=https://github.com/al-hub/agent-life.git ./install.sh
```

## Recommended Flow

The bootstrap flow is intentionally small:

1. Check that `git` exists.
2. Resolve and print the install target path.
3. Clone the framework when the target path is missing.
4. Pull best-effort updates when the target path is an existing git checkout.
5. Run lightweight validation.
6. Report current core discovery using the same internal helper as `agent-init`.
7. Print diagnostics-first manual next-step guidance.
8. Exit.

Existing installs are updated with `git pull --ff-only`. If the pull fails, the
installer leaves the checkout in place and asks the user to inspect it manually.
This keeps reinstall/update behavior simple and reversible.

## Curl Bootstrap

Example shape:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
```

The script still prints the clone/update target path before it changes anything
under that path.

## Local Bootstrap

From an existing checkout:

```sh
./install.sh
```

This uses the same install target policy as external execution. Running from a
repo checkout does not turn the script into an activation command.

## Non-Goals

The installer must not:

- edit `PATH`
- edit shell rc files
- inject aliases
- create symlinks automatically
- write `current-profile`
- activate profiles
- parse profile `AGENTS.md` semantics
- start daemons or watchers
- integrate tmux
- perform background or self-update behavior
- take ownership of the user's shell or runtime

PATH or symlink integration may be printed as manual guidance only.

## First Run

After bootstrap, start with diagnostics:

```sh
$HOME/.agent-life/framework/bin/agent-init doctor
```

Then inspect private profiles:

```sh
$HOME/.agent-life/framework/bin/agent-init list
$HOME/.agent-life/framework/bin/agent-init auto
```

If private core is not in a discoverable path, pass it explicitly:

```sh
AGENT_CORE_PATH="$HOME/workspace/agent-core" \
  "$HOME/.agent-life/framework/bin/agent-init" doctor
```

Or create an optional local preference:

```sh
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$HOME/workspace/agent-core" > "$HOME/.agent-life/config"
```

See `docs/quickstart.md` for first-run onboarding.

## Remove

Remove the public framework checkout:

```sh
rm -rf "$HOME/.agent-life/framework"
```

This does not remove private `agent-core` data or manual shell configuration.

## Semantics

Install means fetch or update the public framework checkout.

Install does not mean:

- activate a profile
- switch runtime context
- attach to a session
- mutate shell state
- write runtime state
- orchestrate tools

The installer should stay transparent, deterministic, idempotent, and easy to
undo by removing the install directory.
