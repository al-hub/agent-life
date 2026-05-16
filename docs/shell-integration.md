# Shell Integration

`install.sh` can register a small marker block in your shell rc file so the
public framework bin directory is on `PATH` and `agent-init` completion can be
loaded explicitly.

This is optional, consent-based, and reversible.

Supported targets:

- Bash: `~/.bashrc`
- Zsh: `~/.zshrc`

Marker block shape:

```text
# agent-life shell integration start
export PATH="$HOME/.agent-life/framework/bin:$PATH"
source "$HOME/.agent-life/framework/completions/agent-init.bash"
# agent-life shell integration end
```

The actual source line uses the detected shell and the installed framework path.
The block is owned by `agent-life` only.

## Register

Interactive installs prompt before editing shell rc files:

```sh
curl -fsSL https://raw.githubusercontent.com/al-hub/agent-life/main/install.sh | bash
```

Pressing Enter accepts the default `[Y/n]` prompt when an interactive terminal is
available. In non-interactive environments, use an explicit flag or environment
variable:

```sh
AGENT_LIFE_SHELL_INTEGRATION=yes ./install.sh
./install.sh --shell-integration
```

## Apply To The Current Shell

After the block is registered, new terminals pick it up automatically. To make
`agent-init` and completion available immediately in the current terminal,
source the rc file for your shell:

```sh
# zsh
source ~/.zshrc

# bash
source ~/.bashrc
```

Then confirm:

```sh
command -v agent-init
agent-init help
```

Non-interactive control:

```sh
AGENT_LIFE_SHELL_INTEGRATION=yes ./install.sh
AGENT_LIFE_SHELL_INTEGRATION=no ./install.sh
./install.sh --shell-integration
./install.sh --no-shell-integration
./install.sh --remove-shell-integration
```

Rules:

- No profile activation.
- No `current-profile` write.
- No tmux or daemon behavior.
- No hidden shell ownership outside the marker block.
- No edits to user shell config outside the marker block.

If shell detection fails, the installer prints manual guidance instead of
editing rc files.

If `agent-init` still reports `command not found` after install, either open a
new terminal or run `source ~/.zshrc` for zsh and `source ~/.bashrc` for bash.
