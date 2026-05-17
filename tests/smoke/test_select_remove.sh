#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
make_core "$core" "context-a"
make_core "$core" "context-b"

marker_count() {
  grep -c '^<!-- agent-life:start -->$' "$1" 2>/dev/null || true
}

assert_one_marker() {
  count="$(marker_count "$1")"
  [ "$count" -eq 1 ] || fail "expected one marker block in $1, found $count"
}

# 1. select creates AGENTS.md in a project that does not have one.
new_project="$SMOKE_TMP_BASE/new-project"
mkdir -p "$new_project"

new_select_output="$(cd "$new_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select context-a)"

assert_contains "$new_select_output" "[OK] Selected project context: context-a"
assert_file "$new_project/AGENTS.md"
new_agents="$(cat "$new_project/AGENTS.md")"
assert_contains "$new_agents" '<!-- agent-life:start -->'
assert_contains "$new_agents" '<!-- agent-life:end -->'
assert_contains "$new_agents" 'Selected context:'
assert_contains "$new_agents" '- context-a'
assert_contains "$new_agents" "Read first:"
assert_contains "$new_agents" "- $core/profiles/context-a/AGENTS.md"
assert_one_marker "$new_project/AGENTS.md"

# 2. select appends a marker block while preserving existing AGENTS.md content.
existing_project="$SMOKE_TMP_BASE/existing-project"
mkdir -p "$existing_project"
printf '%s\n' '# Existing project guidance' '' 'Keep this instruction.' > "$existing_project/AGENTS.md"

existing_select_output="$(cd "$existing_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select context-a)"

assert_contains "$existing_select_output" "[OK] Selected project context: context-a"
existing_agents="$(cat "$existing_project/AGENTS.md")"
assert_contains "$existing_agents" '# Existing project guidance'
assert_contains "$existing_agents" 'Keep this instruction.'
assert_contains "$existing_agents" '<!-- agent-life:start -->'
assert_contains "$existing_agents" '- context-a'
assert_one_marker "$existing_project/AGENTS.md"

# 3. selecting the same context twice updates in place and does not duplicate.
repeat_select_output="$(cd "$existing_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select context-a)"

assert_contains "$repeat_select_output" "[OK] Selected project context: context-a"
repeat_agents="$(cat "$existing_project/AGENTS.md")"
assert_contains "$repeat_agents" '# Existing project guidance'
assert_contains "$repeat_agents" 'Keep this instruction.'
assert_one_marker "$existing_project/AGENTS.md"

# 4. selecting a different context replaces the old marker block contents.
switch_select_output="$(cd "$existing_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select context-b)"

assert_contains "$switch_select_output" "[OK] Selected project context: context-b"
switched_agents="$(cat "$existing_project/AGENTS.md")"
assert_contains "$switched_agents" '# Existing project guidance'
assert_contains "$switched_agents" 'Keep this instruction.'
assert_contains "$switched_agents" '- context-b'
assert_contains "$switched_agents" "- $core/profiles/context-b/AGENTS.md"
assert_not_contains "$switched_agents" '- context-a'
assert_not_contains "$switched_agents" "$core/profiles/context-a/AGENTS.md"
assert_one_marker "$existing_project/AGENTS.md"

# 5. remove all removes only the agent-life marker block from existing AGENTS.md.
remove_output="$(cd "$existing_project" && "$ROOT/bin/agent-init" remove all)"

assert_contains "$remove_output" "[OK] Removed agent-life marker block"
removed_agents="$(cat "$existing_project/AGENTS.md")"
assert_contains "$removed_agents" '# Existing project guidance'
assert_contains "$removed_agents" 'Keep this instruction.'
assert_not_contains "$removed_agents" '<!-- agent-life:start -->'
assert_not_contains "$removed_agents" '<!-- agent-life:end -->'

# 6. status reports selected context when present and none when absent.
status_project="$SMOKE_TMP_BASE/status-project"
mkdir -p "$status_project"
status_before="$(cd "$status_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" status)"

assert_contains "$status_before" "[INFO] Project AGENTS.md: missing"
assert_contains "$status_before" "[INFO] Agent-life marker block: missing"
assert_contains "$status_before" "Selected context: none"
assert_contains "$status_before" "Context source: none"

status_select_output="$(cd "$status_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select context-b)"
assert_contains "$status_select_output" "[OK] Selected project context: context-b"

status_after="$(cd "$status_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" status)"

assert_contains "$status_after" "[OK] Project AGENTS.md: found"
assert_contains "$status_after" "[OK] Agent-life marker block: found"
assert_contains "$status_after" "Selected context: context-b"
assert_contains "$status_after" "Context source: $core/profiles/context-b/AGENTS.md"

# Shortcut form delegates to select for one non-reserved context argument.
shortcut_project="$SMOKE_TMP_BASE/shortcut-project"
mkdir -p "$shortcut_project"
printf '%s\n' '# Shortcut project guidance' > "$shortcut_project/AGENTS.md"

shortcut_output="$(cd "$shortcut_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" context-a)"

assert_contains "$shortcut_output" "[OK] Selected project context: context-a"
shortcut_agents="$(cat "$shortcut_project/AGENTS.md")"
assert_contains "$shortcut_agents" '# Shortcut project guidance'
assert_contains "$shortcut_agents" '- context-a'
assert_contains "$shortcut_agents" "- $core/profiles/context-a/AGENTS.md"
assert_one_marker "$shortcut_project/AGENTS.md"

set +e
multi_arg_output="$(cd "$shortcut_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" context-a extra 2>&1)"
multi_arg_status="$?"
set -e

[ "$multi_arg_status" -ne 0 ] || fail "expected multi-argument shortcut to fail"
assert_contains "$multi_arg_output" "context shortcut accepts exactly one context argument"

set +e
reserved_output="$(cd "$shortcut_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" update 2>&1)"
reserved_status="$?"
set -e

[ "$reserved_status" -ne 0 ] || fail "expected reserved update command to fail"
assert_contains "$reserved_output" "update is reserved but not implemented"
