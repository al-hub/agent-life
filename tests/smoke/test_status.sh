#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

output="$("$ROOT/bin/agent-init" status)"

assert_contains "$output" "[OK] Framework detected"
assert_contains "$output" "[WARN] Core path not found"
assert_contains "$output" "[INFO] State path"
assert_contains "$output" "[OK] Discovered profiles:"
assert_contains "$output" "task-brief"
assert_not_contains "$output" "Reasoning:"
