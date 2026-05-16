#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

repo_fixture="$SMOKE_TMP_BASE/repo"
snapshot_repo "$ROOT" "$repo_fixture"
install_dir="$SMOKE_TMP_BASE/install/framework"

printf '%s\n' '# user bashrc' > "$HOME/.bashrc"

bash_install_output="$(
  SHELL=/bin/bash \
  AGENT_LIFE_REPO_URL="$repo_fixture" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  AGENT_LIFE_SHELL_INTEGRATION=yes \
  "$ROOT/install.sh"
)"

assert_contains "$bash_install_output" "[INFO] Shell integration"
assert_contains "$bash_install_output" "[OK] Shell integration marker block added"
assert_contains "$bash_install_output" "Target file: $HOME/.bashrc"
assert_contains "$bash_install_output" "source \"$HOME/.bashrc\""
assert_contains "$bash_install_output" "command -v agent-init"
assert_contains "$bash_install_output" "agent-init help"

bashrc_contents="$(cat "$HOME/.bashrc")"
assert_contains "$bashrc_contents" '# user bashrc'
assert_contains "$bashrc_contents" '# agent-life shell integration start'
assert_contains "$bashrc_contents" "export PATH=\"$install_dir/bin:\$PATH\""
assert_contains "$bashrc_contents" "source \"$install_dir/completions/agent-init.bash\""
assert_contains "$bashrc_contents" '# agent-life shell integration end'
count="$(grep -c '^# agent-life shell integration start$' "$HOME/.bashrc")"
[ "$count" -eq 1 ] || fail "expected one bash marker block, found $count"

bash_completion_output="$(
  HOME="$HOME" bash --noprofile --norc -c '. "$HOME/.bashrc"; complete -p agent-init'
)"
assert_contains "$bash_completion_output" '_agent_init_completion'

bash_refresh_output="$(
  SHELL=/bin/bash \
  AGENT_LIFE_REPO_URL="$repo_fixture" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  AGENT_LIFE_SHELL_INTEGRATION=yes \
  "$ROOT/install.sh"
)"

assert_contains "$bash_refresh_output" "[OK] Shell integration marker block refreshed"
count="$(grep -c '^# agent-life shell integration start$' "$HOME/.bashrc")"
[ "$count" -eq 1 ] || fail "expected one refreshed bash marker block, found $count"

printf '%s\n' '# user bashrc tail' >> "$HOME/.bashrc"
bash_remove_output="$(
  SHELL=/bin/bash \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  "$ROOT/install.sh" --remove-shell-integration
)"

assert_contains "$bash_remove_output" "[OK] Shell integration marker block removed"
bashrc_contents="$(cat "$HOME/.bashrc")"
assert_contains "$bashrc_contents" '# user bashrc'
assert_contains "$bashrc_contents" '# user bashrc tail'
assert_not_contains "$bashrc_contents" '# agent-life shell integration start'
assert_not_contains "$bashrc_contents" "$install_dir/completions/agent-init.bash"

printf '%s\n' '# user zshrc' > "$HOME/.zshrc"

zsh_install_output="$(
  SHELL=/bin/zsh \
  AGENT_LIFE_REPO_URL="$repo_fixture" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  AGENT_LIFE_SHELL_INTEGRATION=yes \
  "$ROOT/install.sh"
)"

assert_contains "$zsh_install_output" "[OK] Shell integration marker block added"
assert_contains "$zsh_install_output" "Target file: $HOME/.zshrc"
assert_contains "$zsh_install_output" "source \"$HOME/.zshrc\""
assert_contains "$zsh_install_output" "command -v agent-init"
assert_contains "$zsh_install_output" "agent-init help"

zshrc_contents="$(cat "$HOME/.zshrc")"
assert_contains "$zshrc_contents" '# user zshrc'
assert_contains "$zshrc_contents" '# agent-life shell integration start'
assert_contains "$zshrc_contents" "export PATH=\"$install_dir/bin:\$PATH\""
assert_contains "$zshrc_contents" "source \"$install_dir/completions/agent-init.zsh\""
assert_contains "$zshrc_contents" '# agent-life shell integration end'
count="$(grep -c '^# agent-life shell integration start$' "$HOME/.zshrc")"
[ "$count" -eq 1 ] || fail "expected one zsh marker block, found $count"

zsh_completion_output="$(
  HOME="$HOME" zsh -ic 'source ~/.zshrc; whence -w _agent_init_completion'
)"
assert_contains "$zsh_completion_output" '_agent_init_completion: function'

zsh_refresh_output="$(
  SHELL=/bin/zsh \
  AGENT_LIFE_REPO_URL="$repo_fixture" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  AGENT_LIFE_SHELL_INTEGRATION=yes \
  "$ROOT/install.sh"
)"

assert_contains "$zsh_refresh_output" "[OK] Shell integration marker block refreshed"
count="$(grep -c '^# agent-life shell integration start$' "$HOME/.zshrc")"
[ "$count" -eq 1 ] || fail "expected one refreshed zsh marker block, found $count"

printf '%s\n' '# user zshrc tail' >> "$HOME/.zshrc"
zsh_remove_output="$(
  SHELL=/bin/zsh \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  "$ROOT/install.sh" --remove-shell-integration
)"

assert_contains "$zsh_remove_output" "[OK] Shell integration marker block removed"
zshrc_contents="$(cat "$HOME/.zshrc")"
assert_contains "$zshrc_contents" '# user zshrc'
assert_contains "$zshrc_contents" '# user zshrc tail'
assert_not_contains "$zshrc_contents" '# agent-life shell integration start'
assert_not_contains "$zshrc_contents" "$install_dir/completions/agent-init.zsh"
