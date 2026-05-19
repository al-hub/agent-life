#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

project="$SMOKE_TMP_BASE/project"
mkdir -p "$project"

# Public contexts are usable without a private agent-core.
list_output="$(cd "$project" && "$ROOT/bin/agent-init" list)"
assert_contains "$list_output" "[WARN] Core path not found"
assert_contains "$list_output" "[OK] Discovered profiles:"
assert_contains "$list_output" "task-brief"

tsv_output="$(cd "$project" && "$ROOT/bin/agent-init" list --tsv)"
assert_contains "$tsv_output" "task-brief	Turn a rough user request into a clear, copy-ready Codex task brief."

ready_output="$(cd "$project" && "$ROOT/bin/agent-init" ready task-brief)"
assert_contains "$ready_output" "<!-- agent-life:start -->"
assert_contains "$ready_output" "- task-brief"
assert_contains "$ready_output" "Intent:"
assert_contains "$ready_output" "- Prepare a copy-ready task brief from the user request."
assert_contains "$ready_output" "$ROOT/profiles/task-brief/AGENTS.md"
assert_not_exists "$project/AGENTS.md"

select_output="$(cd "$project" && "$ROOT/bin/agent-init" task-brief)"
assert_contains "$select_output" "[OK] Selected project context: task-brief"
agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" "- task-brief"
assert_contains "$agents_contents" "Intent:"
assert_contains "$agents_contents" "- Prepare a copy-ready task brief from the user request."
assert_contains "$agents_contents" "- $ROOT/profiles/task-brief/AGENTS.md"

remove_output="$(cd "$project" && "$ROOT/bin/agent-init" remove all)"
assert_contains "$remove_output" "[OK] Removed project AGENTS.md"
assert_not_exists "$project/AGENTS.md"

# A private context with the same name overrides the public fallback.
core="$SMOKE_TMP_BASE/agent-core"
mkdir -p "$core/profiles/task-brief"
cat > "$core/profiles/task-brief/AGENTS.md" <<'EOF'
Description: private task brief override
# private task-brief
EOF

override_tsv="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" list --tsv)"
assert_contains "$override_tsv" "task-brief	private task brief override"

override_ready="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" ready task-brief)"
assert_contains "$override_ready" "$core/profiles/task-brief/AGENTS.md"
assert_not_contains "$override_ready" "$ROOT/profiles/task-brief/AGENTS.md"
assert_not_contains "$override_ready" "Intent:"

override_select="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select task-brief)"
assert_contains "$override_select" "[OK] Selected project context: task-brief"
override_agents="$(cat "$project/AGENTS.md")"
assert_contains "$override_agents" "- $core/profiles/task-brief/AGENTS.md"
assert_not_contains "$override_agents" "- $ROOT/profiles/task-brief/AGENTS.md"
assert_not_contains "$override_agents" "Intent:"
