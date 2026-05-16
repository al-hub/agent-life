#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

output="$("$ROOT/bin/agent-init" help)"

assert_contains "$output" "Usage:"
assert_contains "$output" "agent-init <command>"
assert_contains "$output" "Current commands:"
assert_contains "$output" "doctor     Run environment diagnostics"
assert_contains "$output" "help       Show this help"
assert_contains "$output" "Current role:"
assert_contains "$output" "Future convenience:"
assert_contains "$output" "agent-init [profile] [topic]"
assert_contains "$output" "Planned shortcut for: agent-init ready [profile] [topic]"
assert_contains "$output" "Reserved commands:"
assert_contains "$output" "help, doctor, status, list, auto, version"
assert_contains "$output" "Profile shortcut is preparation-only."
assert_contains "$output" "write current-profile"
