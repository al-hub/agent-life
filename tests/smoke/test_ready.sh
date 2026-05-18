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

workdir="$SMOKE_TMP_BASE/work/develop"
mkdir -p "$workdir"
ready_output="$(cd "$workdir" && "$ROOT/bin/agent-init" ready)"

assert_contains "$ready_output" "agent-init ready"
assert_contains "$ready_output" "[INFO] Framework"
assert_contains "$ready_output" "[OK] Framework detected"
assert_contains "$ready_output" "[INFO] Core"
assert_contains "$ready_output" "[OK] Core path found"
assert_contains "$ready_output" "[INFO] Discovered profiles"
assert_contains "$ready_output" "[OK] Discovered profiles:"
assert_contains "$ready_output" "     - develop"
assert_contains "$ready_output" "[INFO] Profile"
assert_contains "$ready_output" "[OK] Suggested profile: develop"
assert_contains "$ready_output" "[INFO] Read first"
assert_contains "$ready_output" "README.md"
assert_contains "$ready_output" "AGENTS.md"
assert_contains "$ready_output" "NEXT.md"
assert_contains "$ready_output" "DECISIONS.md"
assert_contains "$ready_output" "docs/ready-concept.md"
assert_contains "$ready_output" "$core/profiles/develop/AGENTS.md"
assert_contains "$ready_output" "[INFO] Boundary reminders"
assert_contains "$ready_output" "No shell, env, or state mutation."
assert_contains "$ready_output" "[INFO] Suggested verification"
assert_contains "$ready_output" "[INFO] Task brief"
assert_contains "$ready_output" "Goal"
assert_contains "$ready_output" "Boundary"
assert_contains "$ready_output" "Verification"
assert_contains "$ready_output" "Next action"
assert_contains "$ready_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."

requested_output="$(AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" ready develop)"

assert_contains "$requested_output" '<!-- agent-life:start -->'
assert_contains "$requested_output" 'Selected context:'
assert_contains "$requested_output" '- develop'
assert_contains "$requested_output" 'Read first:'
assert_contains "$requested_output" "- $core/profiles/develop/AGENTS.md"
assert_contains "$requested_output" 'Rules:'
assert_contains "$requested_output" 'This is not activation, orchestration, or shell/runtime mutation.'
assert_contains "$requested_output" '<!-- agent-life:end -->'

preview_project="$SMOKE_TMP_BASE/preview-project"
mkdir -p "$preview_project"
select_output="$(cd "$preview_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select develop)"
assert_contains "$select_output" "[OK] Selected project context: develop"
selected_block="$(cat "$preview_project/AGENTS.md")"
[ "$requested_output" = "$selected_block" ] || fail "expected ready preview to match selected marker block"

set +e
missing_profile_output="$(AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" ready missing-profile 2>&1)"
missing_profile_status="$?"
set -e

[ "$missing_profile_status" -ne 0 ] || fail "expected missing ready context to fail"
assert_contains "$missing_profile_output" "selected context source missing:"
assert_contains "$missing_profile_output" "$core/profiles/missing-profile/AGENTS.md"

empty_core="$SMOKE_TMP_BASE/empty-core"
mkdir -p "$empty_core/profiles"
empty_core_output="$(AGENT_CORE_PATH="$empty_core" "$ROOT/bin/agent-init" ready)"

assert_contains "$empty_core_output" "[OK] Core path found"
assert_contains "$empty_core_output" "[OK] Discovered profiles:"
assert_contains "$empty_core_output" "task-brief"
assert_contains "$empty_core_output" "[WARN] Suggested profile: none"
assert_contains "$empty_core_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."

no_core_home="$SMOKE_TMP_BASE/no-core-home"
mkdir -p "$no_core_home"
no_core_output="$(HOME="$no_core_home" "$ROOT/bin/agent-init" ready)"

assert_contains "$no_core_output" "[WARN] Core path not found"
assert_contains "$no_core_output" "Reason: no agent-core was discovered by any configured path"
assert_contains "$no_core_output" "[OK] Discovered profiles:"
assert_contains "$no_core_output" "task-brief"
assert_contains "$no_core_output" "[WARN] Suggested profile: none"
assert_contains "$no_core_output" "Reason: no unambiguous profile match"
assert_contains "$no_core_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."
