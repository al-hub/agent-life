#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

repo_fixture="$SMOKE_TMP_BASE/repo"
snapshot_repo "$ROOT" "$repo_fixture"
install_dir="$SMOKE_TMP_BASE/install/framework"

output="$(
  AGENT_LIFE_REPO_URL="$repo_fixture" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  AGENT_LIFE_SHELL_INTEGRATION=no \
  SHELL=/bin/bash \
  "$ROOT/install.sh"
)"

assert_dir "$install_dir/.git"
assert_file "$install_dir/install.sh"
assert_file "$install_dir/bin/agent-init"
assert_file "$install_dir/lib/core-discovery.sh"
assert_contains "$output" "[OK] core discovery helper found"
assert_contains "$output" "[OK] completions directory found"
assert_contains "$output" "[OK] bash completion found"
assert_contains "$output" "[OK] zsh completion found"
assert_contains "$output" "Current core discovery:"
assert_contains "$output" "Manual next steps:"
assert_contains "$output" "[INFO] Shell integration skipped by request"
assert_contains "$output" "No aliases, symlinks, shell rc files, runtime state, or profile activation changes were made."
assert_not_exists "$HOME/.agent-life/config"
assert_not_exists "$HOME/.local/state/agent-life"
assert_not_exists "$HOME/.bashrc"
assert_not_exists "$HOME/.zshrc"
