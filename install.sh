#!/usr/bin/env bash
set -euo pipefail

main() {
  local script_dir repo_root core_path core_source

  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$script_dir"

  if ! git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "agent-life: not inside a git repository: $repo_root" >&2
    exit 1
  fi

  repo_root="$(git -C "$repo_root" rev-parse --show-toplevel)"

  echo "agent-life bootstrap"
  echo
  echo "agent-life: $repo_root"

  if [[ -n "${AGENT_CORE_PATH:-}" ]]; then
    core_path="$AGENT_CORE_PATH"
    core_source="AGENT_CORE_PATH"
  elif [[ -d "$repo_root/../agent-core" ]]; then
    core_path="$(cd "$repo_root/../agent-core" && pwd)"
    core_source="sibling"
  elif [[ -d "$HOME/.agent-core" ]]; then
    core_path="$HOME/.agent-core"
    core_source="home"
  else
    core_path=""
    core_source="missing"
  fi

  if [[ -n "$core_path" ]]; then
    echo "agent-core: $core_path"
    echo "core source: $core_source"

    if git -C "$core_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "core git repo: yes"
    else
      echo "core git repo: no"
    fi
  else
    echo "agent-core: not found"
    echo "core source: $core_source"
    echo
    echo "Create or clone private agent-core as a sibling repo:"
    echo "  $(dirname "$repo_root")/agent-core"
    echo
    echo "Or set AGENT_CORE_PATH to an existing private core path."
  fi

  echo

  if [[ -x "$repo_root/bin/agent-init" ]]; then
    echo "agent-init: found at $repo_root/bin/agent-init"
    echo "next: add $repo_root/bin to PATH or symlink agent-init into ~/.local/bin"
  else
    echo "agent-init: not installed yet"
    echo "next: create bin/agent-init, then rerun this bootstrap check"
  fi
}

main "$@"
