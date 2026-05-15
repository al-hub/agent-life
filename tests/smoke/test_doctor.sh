#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

output="$("$ROOT/bin/agent-init" doctor --verbose)"

assert_contains "$output" "agent-init doctor"
assert_contains "$output" "[OK] Framework detected"
assert_contains "$output" "[WARN] AGENT_CORE_PATH not set"
assert_contains "$output" "[INFO] Local config not found"
assert_contains "$output" "Reasoning:"
assert_contains "$output" "[INFO] Checking AGENT_CORE_PATH"
assert_contains "$output" "[INFO] Checking config default-core-path"
assert_contains "$output" "[INFO] Checking sibling ../agent-core"
assert_contains "$output" "[INFO] Checking home ~/.agent-core"
assert_contains "$output" "doctor does not repair, activate, switch, sync, or write runtime state."
assert_not_exists "$HOME/.agent-life/config"
assert_not_exists "$HOME/.local/state/agent-life"
