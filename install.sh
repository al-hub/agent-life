#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="https://github.com/al-hub/agent-life.git"
DEFAULT_INSTALL_DIR="$HOME/.agent-life/framework"
MARKER_START="# agent-life shell integration start"
MARKER_END="# agent-life shell integration end"

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
  ./install.sh --shell-integration
  ./install.sh --no-shell-integration
  ./install.sh --remove-shell-integration
  curl -fsSL <install.sh-url> | bash

Environment:
  AGENT_LIFE_REPO_URL      Repository URL to clone when no install exists.
                            Default: $DEFAULT_REPO_URL
  AGENT_LIFE_INSTALL_DIR   Install target path.
                            Default: $DEFAULT_INSTALL_DIR
  AGENT_LIFE_SHELL_INTEGRATION
                            yes, no, or unset to control shell rc registration
                            when bash or zsh can be detected.
                            Default: prompt with [Y/n] in interactive shells

Behavior:
  - checks for git
  - clones agent-life when the target path is missing
  - pulls best-effort updates when the target path is an existing git checkout
  - validates the lightweight framework files
  - reports current core discovery
  - can register or remove a reversible marker block in bash or zsh rc files
  - prints diagnostics-first manual next steps

It does not silently edit PATH, shell rc files, aliases, symlinks, runtime
state, or profile activation state.
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

detect_shell_name() {
  case "${SHELL:-}" in
    *bash) printf '%s\n' bash ;;
    *zsh) printf '%s\n' zsh ;;
    *) return 1 ;;
  esac
}

shell_rc_path() {
  case "$1" in
    bash) printf '%s/.bashrc\n' "$HOME" ;;
    zsh) printf '%s/.zshrc\n' "$HOME" ;;
    *) return 1 ;;
  esac
}

shell_completion_path() {
  local install_dir shell_name
  install_dir="$1"
  shell_name="$2"
  printf '%s/completions/agent-init.%s\n' "$install_dir" "$shell_name"
}

shell_integration_block() {
  local install_dir shell_name completion_path
  install_dir="$1"
  shell_name="$2"
  completion_path="$(shell_completion_path "$install_dir" "$shell_name")"
  cat <<EOF_BLOCK
$MARKER_START
export PATH="$install_dir/bin:\$PATH"
source "$completion_path"
$MARKER_END
EOF_BLOCK
}

remove_shell_integration_block() {
  local file tmp had_block
  file="$1"

  if [[ ! -f "$file" ]]; then
    printf '%s\n' missing
    return 0
  fi

  had_block=0
  if grep -Fq "$MARKER_START" "$file"; then
    had_block=1
  fi

  tmp="$(mktemp)"
  awk -v start="$MARKER_START" -v end="$MARKER_END" '
    $0 == start { in_block = 1; next }
    in_block && $0 == end { in_block = 0; next }
    in_block { next }
    { print }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"

  if [[ "$had_block" -eq 1 ]]; then
    printf '%s\n' removed
  else
    printf '%s\n' absent
  fi
}

apply_shell_integration_block() {
  local file block tmp had_block
  file="$1"
  block="$2"

  had_block=0
  if [[ -f "$file" ]] && grep -Fq "$MARKER_START" "$file"; then
    had_block=1
  fi

  if [[ -f "$file" ]]; then
    tmp="$(mktemp)"
    awk -v start="$MARKER_START" -v end="$MARKER_END" '
      $0 == start { in_block = 1; next }
      in_block && $0 == end { in_block = 0; next }
      in_block { next }
      { print }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
  else
    : > "$file"
  fi

  if [[ -s "$file" ]]; then
    printf '\n' >> "$file"
  fi
  printf '%s\n' "$block" >> "$file"

  if [[ "$had_block" -eq 1 ]]; then
    printf '%s\n' refreshed
  else
    printf '%s\n' added
  fi
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

  if [[ -r "$install_dir/lib/core-discovery.sh" ]]; then
    log "[OK] core discovery helper found"
  else
    log "[WARN] core discovery helper missing"
    missing=1
  fi

  if [[ -d "$install_dir/completions" ]]; then
    log "[OK] completions directory found"
  else
    log "[WARN] completions directory missing"
    missing=1
  fi

  if [[ -r "$install_dir/completions/agent-init.bash" ]]; then
    log "[OK] bash completion found"
    log "     Path: $install_dir/completions/agent-init.bash"
  else
    log "[WARN] bash completion missing"
    missing=1
  fi

  if [[ -r "$install_dir/completions/agent-init.zsh" ]]; then
    log "[OK] zsh completion found"
    log "     Path: $install_dir/completions/agent-init.zsh"
  else
    log "[WARN] zsh completion missing"
    missing=1
  fi

  return "$missing"
}

print_core_discovery_preview() {
  local install_dir helper core_result core core_source
  install_dir="$1"
  helper="$install_dir/lib/core-discovery.sh"

  [[ -r "$helper" ]] || return 0

  # shellcheck source=/dev/null
  . "$helper"

  core_result="$(agent_life_discover_core "$install_dir")"
  core="$(agent_life_core_path_from_result "$core_result")"
  core_source="$(agent_life_core_source_from_result "$core_result")"

  log "Current core discovery:"
  if [[ -n "$core" ]]; then
    log "  Source: $core_source"
    log "  Path: $core"
  else
    log "  Source: $core_source"
    log "  Path: not found"
  fi
  log
}

print_next_steps() {
  local install_dir shell_state shell_rc_file
  install_dir="$1"
  shell_state="${2:-skipped}"
  shell_rc_file="${3:-}"

  log
  log "agent-life bootstrap complete"
  log
  log "Framework path: $install_dir"
  log
  print_core_discovery_preview "$install_dir"
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
  log "  Optional shell integration:"
  log "    ./install.sh --shell-integration"
  log "    AGENT_LIFE_SHELL_INTEGRATION=yes ./install.sh"
  log "    AGENT_LIFE_SHELL_INTEGRATION=no ./install.sh"
  log "    ./install.sh --remove-shell-integration"
  log "    See: $install_dir/docs/shell-integration.md"
  log
  if [[ "$shell_state" == registered ]]; then
    log "  Shell integration: registered in $shell_rc_file"
    log "  Reload your shell or run:"
    log "    source \"$shell_rc_file\""
    log "  That makes agent-init and completion available in the current shell."
    log "  The marker block above is the only shell rc change."
    log "  No aliases, symlinks, runtime state, or profile activation changes were made."
  else
    log "  Fallback manual PATH guidance:"
    log "    export PATH=\"$install_dir/bin:\$PATH\""
    log "  No aliases, symlinks, shell rc files, runtime state, or profile activation changes were made."
  fi
  log
  log "Quickstart: $install_dir/docs/quickstart.md"
  log
}

detect_shell_integration_request() {
  case "${AGENT_LIFE_SHELL_INTEGRATION:-}" in
    yes|YES|Yes) printf '%s\n' yes ;;
    no|NO|No) printf '%s\n' no ;;
    "") printf '%s\n' prompt ;;
    *) printf '%s\n' prompt ;;
  esac
}

show_shell_integration_preview() {
  local rc_file block
  rc_file="$1"
  block="$2"

  log "[INFO] Shell integration"
  log "       Target file: $rc_file"
  log "       Block:"
  while IFS= read -r line; do
    log "         $line"
  done <<EOF_BLOCK
$block
EOF_BLOCK
}

prompt_for_shell_integration() {
  local rc_file block answer
  rc_file="$1"
  block="$2"

  show_shell_integration_preview "$rc_file" "$block"

  if [[ ! -t 0 && ! -t 1 ]]; then
    return 1
  fi

  printf '%s' "Register shell integration? [Y/n] "
  if ! IFS= read -r answer; then
    return 1
  fi

  case "$answer" in
    ""|y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

handle_shell_integration() {
  local mode install_dir shell_name rc_file block action
  mode="$1"
  install_dir="$2"
  shell_name="$(detect_shell_name || true)"
  shell_integration_result="skipped"

  if [[ -z "$shell_name" ]]; then
    log "[WARN] Shell integration unavailable"
    log "       Reason: unable to detect bash or zsh from SHELL"
    log "       Manual guidance only:"
    log "         Add the PATH and completion source block from docs/shell-integration.md"
    shell_integration_result="unavailable"
    return 0
  fi

  rc_file="$(shell_rc_path "$shell_name")"
  block="$(shell_integration_block "$install_dir" "$shell_name")"

  case "$mode" in
    remove)
      log "[INFO] Shell integration removal"
      log "       Target file: $rc_file"
      action="$(remove_shell_integration_block "$rc_file")"
      case "$action" in
        removed)
          log "[OK] Shell integration marker block removed"
          shell_integration_result="removed"
          ;;
        absent)
          log "[WARN] Shell integration marker block not found"
          shell_integration_result="absent"
          ;;
        missing)
          log "[WARN] Shell integration target file missing"
          shell_integration_result="absent"
          ;;
      esac
      if [[ "$shell_integration_result" == removed ]]; then
        log "Only the agent-life marker block was removed."
      else
        log "No agent-life marker block was present, so no rc changes were made."
      fi
      return 0
      ;;
    yes)
      show_shell_integration_preview "$rc_file" "$block"
      action="$(apply_shell_integration_block "$rc_file" "$block")"
      case "$action" in
        added)
          log "[OK] Shell integration marker block added"
          ;;
        refreshed)
          log "[OK] Shell integration marker block refreshed"
          ;;
      esac
      shell_integration_result="registered"
      return 0
      ;;
    no)
      log "[INFO] Shell integration"
      log "       Target file: $rc_file"
      log "[INFO] Shell integration skipped by request"
      shell_integration_result="skipped"
      return 0
      ;;
    prompt)
      if prompt_for_shell_integration "$rc_file" "$block"; then
        action="$(apply_shell_integration_block "$rc_file" "$block")"
        case "$action" in
          added)
            log "[OK] Shell integration marker block added"
            ;;
          refreshed)
            log "[OK] Shell integration marker block refreshed"
            ;;
        esac
        shell_integration_result="registered"
      else
        log "[INFO] Shell integration skipped"
        shell_integration_result="skipped"
      fi
      return 0
      ;;
  esac
}

main() {
  local repo_url install_dir shell_integration_option shell_integration_state shell_integration_target shell_name

  shell_integration_option="prompt"
  shell_integration_state="skipped"
  shell_integration_target=""
  shell_name=""

  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --shell-integration)
        if [[ "$shell_integration_option" != prompt ]]; then
          fail "shell integration options are mutually exclusive"
        fi
        shell_integration_option="yes"
        ;;
      --no-shell-integration)
        if [[ "$shell_integration_option" != prompt ]]; then
          fail "shell integration options are mutually exclusive"
        fi
        shell_integration_option="no"
        ;;
      --remove-shell-integration)
        if [[ "$shell_integration_option" != prompt ]]; then
          fail "shell integration options are mutually exclusive"
        fi
        shell_integration_option="remove"
        ;;
      *)
        fail "unknown option: $1"
        ;;
    esac
    shift
  done

  if [[ "$shell_integration_option" == remove ]]; then
    handle_shell_integration remove ""
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

  case "$shell_integration_option" in
    yes)
      handle_shell_integration yes "$install_dir"
      ;;
    no)
      handle_shell_integration no "$install_dir"
      ;;
    prompt)
      case "$(detect_shell_integration_request)" in
        yes)
          handle_shell_integration yes "$install_dir"
          ;;
        no)
          handle_shell_integration no "$install_dir"
          ;;
        prompt)
          handle_shell_integration prompt "$install_dir"
          ;;
      esac
      ;;
  esac

  shell_name="$(detect_shell_name || true)"
  if [[ "${shell_integration_result:-skipped}" == registered ]]; then
    shell_integration_state="registered"
    shell_integration_target="$(shell_rc_path "$shell_name")"
  fi

  print_next_steps "$install_dir" "$shell_integration_state" "$shell_integration_target"
}

main "$@"
