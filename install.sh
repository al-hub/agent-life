#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="https://github.com/al-hub/agent-life.git"
DEFAULT_INSTALL_DIR="$HOME/.agent-life/framework"

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'agent-life: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF_USAGE
agent-life bootstrap

Usage:
  ./install.sh
  curl -fsSL <install.sh-url> | bash

Environment:
  AGENT_LIFE_REPO_URL      Repository URL to clone when no install exists.
                            Default: $DEFAULT_REPO_URL
  AGENT_LIFE_INSTALL_DIR   Install target path.
                            Default: $DEFAULT_INSTALL_DIR

Behavior:
  - checks for git
  - clones agent-life when the target path is missing
  - pulls best-effort updates when the target path is an existing git checkout
  - validates the lightweight framework files
  - prints diagnostics-first manual next steps

It does not edit PATH, shell rc files, aliases, symlinks, runtime state, or
profile activation state.
EOF_USAGE
}

abs_parent() {
  local path parent
  path="$1"
  parent="$(dirname -- "$path")"
  mkdir -p -- "$parent"
  (cd -- "$parent" && pwd)
}

resolve_install_dir() {
  local requested parent base
  requested="${AGENT_LIFE_INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"

  case "$requested" in
    ~) requested="$HOME" ;;
    ~/*) requested="$HOME/${requested#~/}" ;;
  esac

  parent="$(abs_parent "$requested")"
  base="$(basename -- "$requested")"
  printf '%s/%s\n' "$parent" "$base"
}

clone_or_update() {
  local repo_url install_dir
  repo_url="$1"
  install_dir="$2"

  if [[ -d "$install_dir/.git" ]]; then
    log "[INFO] Existing install found"
    log "       Path: $install_dir"
    log "[INFO] Updating existing checkout"
    if git -C "$install_dir" pull --ff-only; then
      log "[OK] Update complete"
    else
      log "[WARN] Update skipped or failed"
      log "       Existing checkout was left in place. Inspect manually: $install_dir"
    fi
    return 0
  fi

  if [[ -e "$install_dir" ]]; then
    fail "target exists but is not a git checkout: $install_dir"
  fi

  log "[INFO] Cloning framework"
  log "       Repo: $repo_url"
  log "       Path: $install_dir"
  git clone "$repo_url" "$install_dir"
  log "[OK] Clone complete"
}

validate_install() {
  local install_dir missing
  install_dir="$1"
  missing=0

  log "[INFO] Validating framework"

  if [[ -f "$install_dir/install.sh" ]]; then
    log "[OK] install.sh found"
  else
    log "[WARN] install.sh missing"
    missing=1
  fi

  if [[ -x "$install_dir/bin/agent-init" ]]; then
    log "[OK] agent-init found"
    log "     Path: $install_dir/bin/agent-init"
  elif [[ -f "$install_dir/bin/agent-init" ]]; then
    log "[WARN] agent-init exists but is not executable"
    log "       Path: $install_dir/bin/agent-init"
    missing=1
  else
    log "[WARN] agent-init missing"
    missing=1
  fi

  if [[ -f "$install_dir/README.md" ]]; then
    log "[OK] README.md found"
  else
    log "[WARN] README.md missing"
    missing=1
  fi

  return "$missing"
}

print_next_steps() {
  local install_dir
  install_dir="$1"

  log
  log "agent-life bootstrap complete"
  log
  log "Framework path: $install_dir"
  log
  log "Manual next steps:"
  log "  1. Run diagnostics first:"
  log "     $install_dir/bin/agent-init doctor"
  log
  log "  2. Connect private agent-core when needed:"
  log "     AGENT_CORE_PATH=\"\$HOME/workspace/agent-core\" $install_dir/bin/agent-init doctor"
  log "     Optional local config: $HOME/.agent-life/config"
  log
  log "  3. Inspect profiles:"
  log "     $install_dir/bin/agent-init list"
  log
  log "  4. Ask for a recommendation:"
  log "     $install_dir/bin/agent-init auto"
  log
  log "  Optional PATH integration, if you choose to own it in your shell config:"
  log "    export PATH=\"$install_dir/bin:\$PATH\""
  log
  log "  Optional symlink, if you choose to manage it yourself:"
  log "    mkdir -p ~/.local/bin"
  log "    ln -sfn $install_dir/bin/agent-init ~/.local/bin/agent-init"
  log
  log "Quickstart: $install_dir/docs/quickstart.md"
  log
  log "No PATH, shell rc, alias, symlink, runtime state, or profile activation changes were made."
}

main() {
  local repo_url install_dir

  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
  fi

  repo_url="${AGENT_LIFE_REPO_URL:-$DEFAULT_REPO_URL}"
  install_dir="$(resolve_install_dir)"

  log "agent-life bootstrap"
  log
  log "[INFO] Install target"
  log "       Path: $install_dir"
  log "[INFO] Repository"
  log "       URL: $repo_url"

  if ! command -v git >/dev/null 2>&1; then
    fail "git is required for clone/update bootstrap"
  fi
  log "[OK] git found"

  clone_or_update "$repo_url" "$install_dir"

  if ! validate_install "$install_dir"; then
    log "[WARN] Lightweight validation reported issues"
    log "       The checkout remains available for manual inspection."
  fi

  print_next_steps "$install_dir"
}

main "$@"
