#!/bin/sh
set -eu

. "$(dirname -- "$0")/_lib.sh"

ROOT="$(smoke_root)"
setup_temp_home
trap 'rm -rf "$SMOKE_TMP_BASE"' EXIT HUP INT TERM

core="$SMOKE_TMP_BASE/agent-core"
project="$SMOKE_TMP_BASE/project"
mkdir -p "$core/profiles/repo-review" "$project" "$HOME/.agent-life"
printf 'default-core-path=%s\n' "$core" > "$HOME/.agent-life/config"
cat > "$core/profiles/repo-review/AGENTS.md" <<'EOF'
Description: review repository state
# repo-review
EOF

tsv_output="$(cd "$project" && "$ROOT/bin/agent-init" list --tsv)"
assert_contains "$tsv_output" "repo-review	review repository state"

ready_output="$(cd "$project" && "$ROOT/bin/agent-init" ready repo-review)"
assert_contains "$ready_output" "<!-- agent-life:start -->"
assert_contains "$ready_output" "Selected context:"
assert_contains "$ready_output" "- repo-review"
assert_contains "$ready_output" "Read first:"
assert_contains "$ready_output" "$core/profiles/repo-review/AGENTS.md"
assert_contains "$ready_output" "<!-- agent-life:end -->"
assert_not_exists "$project/AGENTS.md"

bin_dir="$SMOKE_TMP_BASE/bin"
mkdir -p "$bin_dir"
ln -s "$(command -v bash)" "$bin_dir/bash"
ln -s "$(command -v dirname)" "$bin_dir/dirname"
ln -s "$(command -v basename)" "$bin_dir/basename"

output="$(cd "$project" && PATH="$bin_dir" "$ROOT/bin/agent-init" fzf)"

assert_contains "$output" "[WARN] fzf command not found"
assert_contains "$output" "Fallback commands:"
assert_contains "$output" "agent-init list"
assert_contains "$output" "agent-init ready <context>"
assert_contains "$output" "agent-init select <context>"
assert_contains "$output" "agent-init remove all"
assert_not_exists "$project/AGENTS.md"
assert_not_exists "$HOME/.local/state/agent-life"

no_core_home="$SMOKE_TMP_BASE/no-core-home"
no_core_project="$SMOKE_TMP_BASE/no-core-project"
fake_bin="$SMOKE_TMP_BASE/fake-bin"
fzf_input="$SMOKE_TMP_BASE/fzf-input.tsv"
mkdir -p "$no_core_home" "$no_core_project" "$fake_bin"

cat > "$fake_bin/fzf" <<EOF
#!/bin/sh
awk '{ print > "$fzf_input"; if (!selected && \$1 == "task-brief") { selected = \$0 } } END { if (selected) print selected }'
EOF
chmod +x "$fake_bin/fzf"

fake_output="$(cd "$no_core_project" && HOME="$no_core_home" PATH="$fake_bin:$PATH" "$ROOT/bin/agent-init" fzf)"
fake_input="$(cat "$fzf_input")"
fake_agents="$(cat "$no_core_project/AGENTS.md")"

assert_contains "$fake_input" "task-brief	Turn a rough user request into a clear, copy-ready Codex task brief."
assert_contains "$fake_output" "[OK] Selected project context: task-brief"
assert_contains "$fake_agents" "- task-brief"
assert_contains "$fake_agents" "- $ROOT/profiles/task-brief/AGENTS.md"
assert_not_exists "$no_core_home/.local/state/agent-life"
