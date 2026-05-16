#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
make_core "$core" "develop"
make_core "$core" "repo-review"

project="$SMOKE_TMP_BASE/project"
mkdir -p "$project"
printf '%s\n' '# Project instructions' '' 'Keep this line.' > "$project/AGENTS.md"

select_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select develop)"

assert_contains "$select_output" "[OK] Selected project context: develop"
assert_contains "$select_output" "Context source: $core/profiles/develop/AGENTS.md"

agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Project instructions'
assert_contains "$agents_contents" 'Keep this line.'
assert_contains "$agents_contents" '<!-- agent-life:start -->'
assert_contains "$agents_contents" 'Selected context:'
assert_contains "$agents_contents" '- develop'
assert_contains "$agents_contents" "Read first:"
assert_contains "$agents_contents" "- $core/profiles/develop/AGENTS.md"
assert_contains "$agents_contents" '<!-- agent-life:end -->'

count="$(grep -c '^<!-- agent-life:start -->$' "$project/AGENTS.md")"
[ "$count" -eq 1 ] || fail "expected one marker block, found $count"

update_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select repo-review)"

assert_contains "$update_output" "[OK] Selected project context: repo-review"
agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Project instructions'
assert_contains "$agents_contents" 'Keep this line.'
assert_contains "$agents_contents" '- repo-review'
assert_contains "$agents_contents" "- $core/profiles/repo-review/AGENTS.md"
assert_not_contains "$agents_contents" '- develop'

count="$(grep -c '^<!-- agent-life:start -->$' "$project/AGENTS.md")"
[ "$count" -eq 1 ] || fail "expected one marker block after update, found $count"

status_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" status)"

assert_contains "$status_output" "[OK] Project AGENTS.md: found"
assert_contains "$status_output" "[OK] Agent-life marker block: found"
assert_contains "$status_output" "Selected context: repo-review"
assert_contains "$status_output" "Context source: $core/profiles/repo-review/AGENTS.md"

rm "$core/profiles/repo-review/AGENTS.md"
missing_status_output="$(cd "$project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" status)"

assert_contains "$missing_status_output" "[WARN] Selected context source missing"
assert_contains "$missing_status_output" "Path: $core/profiles/repo-review/AGENTS.md"

remove_output="$(cd "$project" && "$ROOT/bin/agent-init" remove all)"

assert_contains "$remove_output" "[OK] Removed agent-life marker block"
agents_contents="$(cat "$project/AGENTS.md")"
assert_contains "$agents_contents" '# Project instructions'
assert_contains "$agents_contents" 'Keep this line.'
assert_not_contains "$agents_contents" '<!-- agent-life:start -->'
assert_not_contains "$agents_contents" '<!-- agent-life:end -->'

marker_only_project="$SMOKE_TMP_BASE/marker-only"
mkdir -p "$marker_only_project"
marker_only_select="$(cd "$marker_only_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select develop)"

assert_contains "$marker_only_select" "[OK] Selected project context: develop"
assert_file "$marker_only_project/AGENTS.md"

marker_only_remove="$(cd "$marker_only_project" && "$ROOT/bin/agent-init" remove all)"

assert_contains "$marker_only_remove" "[OK] Removed project AGENTS.md"
assert_not_exists "$marker_only_project/AGENTS.md"

malformed_project="$SMOKE_TMP_BASE/malformed"
mkdir -p "$malformed_project"
printf '%s\n' '<!-- agent-life:end -->' 'user content' '<!-- agent-life:start -->' > "$malformed_project/AGENTS.md"

set +e
malformed_output="$(cd "$malformed_project" && AGENT_CORE_PATH="$core" "$ROOT/bin/agent-init" select develop 2>&1)"
malformed_status="$?"
set -e

[ "$malformed_status" -ne 0 ] || fail "expected malformed marker select to fail"
assert_contains "$malformed_output" "malformed agent-life marker block"
malformed_contents="$(cat "$malformed_project/AGENTS.md")"
assert_contains "$malformed_contents" 'user content'
assert_contains "$malformed_contents" '<!-- agent-life:end -->'
assert_contains "$malformed_contents" '<!-- agent-life:start -->'
