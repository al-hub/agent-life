#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

install_dir="$SMOKE_TMP_BASE/install/framework"

output="$(
  AGENT_LIFE_REPO_URL="$ROOT" \
  AGENT_LIFE_INSTALL_DIR="$install_dir" \
  "$ROOT/install.sh"
)"

assert_dir "$install_dir/.git"
assert_file "$install_dir/install.sh"
assert_file "$install_dir/bin/agent-init"
assert_file "$install_dir/lib/core-discovery.sh"
assert_contains "$output" "[OK] core discovery helper found"
assert_contains "$output" "Current core discovery:"
assert_contains "$output" "Manual next steps:"
assert_contains "$output" "No PATH, shell rc, alias, symlink, runtime state, or profile activation changes were made."
assert_not_exists "$HOME/.agent-life/config"
assert_not_exists "$HOME/.local/state/agent-life"
