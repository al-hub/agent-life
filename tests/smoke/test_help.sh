#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

output="$("$ROOT/bin/agent-init" help)"

assert_contains "$output" "Usage:"
assert_contains "$output" "agent-init <command>"
assert_contains "$output" "agent-init <context>"
assert_contains "$output" "Current commands:"
assert_contains "$output" "doctor     Run environment diagnostics"
assert_contains "$output" "help       Show this help"
assert_contains "$output" "ready      Prepare an AI work briefing"
assert_contains "$output" "select     Select one project-local AI context"
assert_contains "$output" "remove     Remove project-local agent-life selection"
assert_contains "$output" "fzf        Search, preview, and select a context with fzf"
assert_contains "$output" "Shortcut:"
assert_contains "$output" "Shortcut for: agent-init select <context>"
assert_contains "$output" "Current role:"
assert_contains "$output" "Reserved commands:"
assert_contains "$output" "help, doctor, status, list, auto, version, ready, select, remove, fzf, update"
assert_contains "$output" "Context selection writes only a reversible project-local AGENTS.md marker block."
assert_contains "$output" "write current-profile"
