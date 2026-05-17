#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

bin_dir="$SMOKE_TMP_BASE/bin"
mkdir -p "$bin_dir"
ln -s "$(command -v bash)" "$bin_dir/bash"
ln -s "$(command -v dirname)" "$bin_dir/dirname"
ln -s "$(command -v basename)" "$bin_dir/basename"

output="$(PATH="$bin_dir" "$ROOT/bin/agent-init" fzf)"

assert_contains "$output" "[WARN] fzf command not found"
assert_contains "$output" "Fallback commands:"
assert_contains "$output" "agent-init list"
assert_contains "$output" "agent-init ready <context>"
assert_contains "$output" "agent-init select <context>"
assert_contains "$output" "agent-init remove all"
assert_not_exists "$HOME/.local/state/agent-life"
