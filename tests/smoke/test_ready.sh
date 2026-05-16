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
assert_contains "$ready_output" "[OK] Discovered profiles: develop"
assert_contains "$ready_output" "     - develop"
assert_contains "$ready_output" "[INFO] Profile"
assert_contains "$ready_output" "[OK] Suggested profile: develop"
assert_contains "$ready_output" "[INFO] Read first"
assert_contains "$ready_output" "README.md"
assert_contains "$ready_output" "AGENTS.md"
assert_contains "$ready_output" "NEXT.md"
assert_contains "$ready_output" "DECISIONS.md"
assert_contains "$ready_output" "docs/ready-concept.md"
assert_contains "$ready_output" "agent-core/profiles/develop/AGENTS.md"
assert_contains "$ready_output" "[INFO] Boundary reminders"
assert_contains "$ready_output" "No shell, env, or state mutation."
assert_contains "$ready_output" "[INFO] Suggested verification"
assert_contains "$ready_output" "[INFO] Task brief"
assert_contains "$ready_output" "Goal"
assert_contains "$ready_output" "Boundary"
assert_contains "$ready_output" "Verification"
assert_contains "$ready_output" "Next action"
assert_contains "$ready_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."

empty_core="$SMOKE_TMP_BASE/empty-core"
mkdir -p "$empty_core/profiles"
empty_core_output="$(AGENT_CORE_PATH="$empty_core" "$ROOT/bin/agent-init" ready)"

assert_contains "$empty_core_output" "[OK] Core path found"
assert_contains "$empty_core_output" "[WARN] Discovered profiles: none"
assert_contains "$empty_core_output" "[WARN] Suggested profile: none"
assert_contains "$empty_core_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."

no_core_home="$SMOKE_TMP_BASE/no-core-home"
mkdir -p "$no_core_home"
no_core_output="$(HOME="$no_core_home" "$ROOT/bin/agent-init" ready)"

assert_contains "$no_core_output" "[WARN] Core path not found"
assert_contains "$no_core_output" "Reason: no agent-core was discovered by any configured path"
assert_contains "$no_core_output" "[WARN] Discovered profiles: none"
assert_contains "$no_core_output" "[WARN] Suggested profile: none"
assert_contains "$no_core_output" "Reason: agent-core was not found"
assert_contains "$no_core_output" "Read-first files are recommendations only; no automatic parsing or merging occurs."
