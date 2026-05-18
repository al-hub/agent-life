#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
make_core "$core" "develop"
printf 'Description: development context\n# develop\n' > "$core/profiles/develop/AGENTS.md"
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$core" > "$HOME/.agent-life/config"

list_output="$("$ROOT/bin/agent-init" list --verbose)"
assert_contains "$list_output" "[OK] Discovered profiles:"
assert_contains "$list_output" "     - develop"
assert_contains "$list_output" "Discovered profiles"
assert_contains "$list_output" "Public profiles directory"
assert_contains "$list_output" "Discovery priority: private overrides public by context name"

tsv_output="$("$ROOT/bin/agent-init" list --tsv)"
assert_contains "$tsv_output" "develop	development context"

auto_output="$("$ROOT/bin/agent-init" auto --verbose)"
assert_contains "$auto_output" "[WARN] Recommended profile: none"
assert_contains "$auto_output" "Reason: no unambiguous profile match"
assert_contains "$auto_output" "Discovered profiles"
assert_contains "$auto_output" "develop"
assert_not_exists "$HOME/.local/state/agent-life"
