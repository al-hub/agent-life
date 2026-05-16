#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
make_core "$core" "develop"
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$core" > "$HOME/.agent-life/config"

list_output="$("$ROOT/bin/agent-init" list --verbose)"
assert_contains "$list_output" "[OK] Discovered profiles: develop"
assert_contains "$list_output" "     - develop"
assert_contains "$list_output" "Discovered profiles"
assert_contains "$list_output" "Public sample profiles are ignored for runtime discovery"

auto_output="$("$ROOT/bin/agent-init" auto --verbose)"
assert_contains "$auto_output" "[OK] Recommended profile: develop"
assert_contains "$auto_output" "Reason: only one profile is available"
assert_contains "$auto_output" "Discovered profiles"
assert_contains "$auto_output" "Profiles: develop"
assert_not_exists "$HOME/.local/state/agent-life"
