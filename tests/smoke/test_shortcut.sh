#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
make_core "$core" "repo-review"

project="$SMOKE_TMP_BASE/project"
mkdir -p "$project"
printf '%s\n' '# Existing project guidance' '' 'Keep this line.' > "$project/AGENTS.md"

marker_count() {
  grep -c '^<!-- agent-life:start -->$' "$1" 2>/dev/null || true
}

assert_one_marker() {
  count="$(marker_count "$1")"
  [ "$count" -eq 1 ] || fail "expected one marker block in $1, found $count"
}

# 1. Bare context routes to select and writes the project-local marker block.
shortcut_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" repo-review)"

assert_contains "$shortcut_output" "[OK] Selected project context: repo-review"
assert_file "$project/AGENTS.md"
agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Existing project guidance'
assert_contains "$agents_contents" 'Keep this line.'
assert_contains "$agents_contents" '<!-- agent-life:start -->'
assert_contains "$agents_contents" 'Selected context:'
assert_contains "$agents_contents" '- repo-review'
assert_contains "$agents_contents" "Read first:"
assert_contains "$agents_contents" "- $core/profiles/repo-review/AGENTS.md"
assert_contains "$agents_contents" '<!-- agent-life:end -->'
assert_one_marker "$project/AGENTS.md"

# 2. remove all removes only the marker block and preserves existing guidance.
remove_output="$(cd "$project" && "$ROOT/bin/agent-init" remove all)"

assert_contains "$remove_output" "[OK] Removed agent-life marker block"
agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Existing project guidance'
assert_contains "$agents_contents" 'Keep this line.'
assert_not_contains "$agents_contents" '<!-- agent-life:start -->'
assert_not_contains "$agents_contents" '<!-- agent-life:end -->'

# 3. Reserved commands keep their command meaning and are not shortcuts.
help_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" help)"
assert_contains "$help_output" "Usage:"
assert_contains "$help_output" "Shortcut for: agent-init select <context>"

status_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" status)"
assert_contains "$status_output" "[INFO] Agent-life marker block: missing"
assert_contains "$status_output" "Selected context: none"

list_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" list)"
assert_contains "$list_output" "[OK] Discovered profiles: repo-review"

ready_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" ready repo-review)"
assert_contains "$ready_output" '<!-- agent-life:start -->'
assert_contains "$ready_output" '- repo-review'
assert_contains "$ready_output" "- $core/profiles/repo-review/AGENTS.md"
assert_contains "$ready_output" '<!-- agent-life:end -->'

agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Existing project guidance'
assert_not_contains "$agents_contents" '<!-- agent-life:start -->'
assert_not_contains "$agents_contents" '- repo-review'

# 4. Missing context follows select failure behavior.
set +e
missing_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" missing-context 2>&1)"
missing_status="$?"
set -e

[ "$missing_status" -ne 0 ] || fail "expected missing context shortcut to fail"
assert_contains "$missing_output" "selected context source missing:"
assert_contains "$missing_output" "$core/profiles/missing-context/AGENTS.md"

# 5. Too many arguments are rejected instead of treated as context composition.
set +e
too_many_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" repo-review extra 2>&1)"
too_many_status="$?"
set -e

[ "$too_many_status" -ne 0 ] || fail "expected multi-argument shortcut to fail"
assert_contains "$too_many_output" "context shortcut accepts exactly one context argument"

agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Existing project guidance'
assert_not_contains "$agents_contents" '<!-- agent-life:start -->'
