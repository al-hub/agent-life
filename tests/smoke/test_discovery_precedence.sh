#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

env_core="$SMOKE_TMP_BASE/env-core"
config_core="$SMOKE_TMP_BASE/config-core"
home_core="$HOME/.agent-core"

make_core "$env_core" "env"
make_core "$config_core" "config"
make_core "$home_core" "home"
mkdir -p "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$config_core" > "$HOME/.agent-life/config"

config_output="$("$ROOT/bin/agent-init" status --verbose)"
assert_contains "$config_output" "Path: $config_core"
assert_contains "$config_output" "Source: config"
assert_contains "$config_output" "Discovered profiles: config"
assert_not_contains "$config_output" "Discovered profiles: home"

env_output="$(AGENT_CORE_PATH="$env_core" "$ROOT/bin/agent-init" status --verbose)"
assert_contains "$env_output" "Path: $env_core"
assert_contains "$env_output" "Source: AGENT_CORE_PATH"
assert_contains "$env_output" "Discovered profiles: env"
assert_not_contains "$env_output" "Discovered profiles: config"

rm -f "$HOME/.agent-life/config"

home_output="$("$ROOT/bin/agent-init" status --verbose)"
assert_contains "$home_output" "Path: $home_core"
assert_contains "$home_output" "Source: home"
assert_contains "$home_output" "Discovered profiles: home"
assert_not_exists "$HOME/.local/state/agent-life"
