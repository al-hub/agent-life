#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

output="$("$ROOT/bin/agent-init" version)"

assert_contains "$output" "agent-init 0.1.0"
assert_not_contains "$output" "[OK]"
assert_not_contains "$output" "[WARN]"
assert_not_contains "$output" "[INFO]"
