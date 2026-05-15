# Internal core discovery helpers for agent-life.
# This file is sourced by shell scripts and intentionally stays small.

agent_life_config_path() {
  printf '%s\n' "$HOME/.agent-life/config"
}

agent_life_expand_user_path() {
  agent_life_expand_user_path_value="$1"

  case "$agent_life_expand_user_path_value" in
    "~") printf '%s\n' "$HOME" ;;
    "~/"*) printf '%s/%s\n' "$HOME" "${agent_life_expand_user_path_value#\~/}" ;;
    *) printf '%s\n' "$agent_life_expand_user_path_value" ;;
  esac
}

agent_life_config_value() {
  agent_life_config_value_key="$1"
  agent_life_config_value_file="$(agent_life_config_path)"

  [ -r "$agent_life_config_value_file" ] || return 0

  while IFS= read -r agent_life_config_value_line || [ -n "$agent_life_config_value_line" ]; do
    case "$agent_life_config_value_line" in
      ''|\#*) continue ;;
      *=*) ;;
      *) continue ;;
    esac

    agent_life_config_value_raw_key="${agent_life_config_value_line%%=*}"
    agent_life_config_value_raw_value="${agent_life_config_value_line#*=}"
    agent_life_config_value_raw_key="$(printf '%s' "$agent_life_config_value_raw_key" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    agent_life_config_value_raw_value="$(printf '%s' "$agent_life_config_value_raw_value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

    [ "$agent_life_config_value_raw_key" = "$agent_life_config_value_key" ] || continue
    [ -n "$agent_life_config_value_raw_value" ] || continue

    printf '%s\n' "$agent_life_config_value_raw_value"
    return 0
  done < "$agent_life_config_value_file"
}

agent_life_discover_core() {
  agent_life_discover_core_root="$1"
  agent_life_discover_core_configured="$(agent_life_config_value "default-core-path")"

  if [ -n "${AGENT_CORE_PATH:-}" ]; then
    printf '%s|%s\n' "$AGENT_CORE_PATH" "AGENT_CORE_PATH"
  elif [ -n "$agent_life_discover_core_configured" ]; then
    printf '%s|%s\n' "$(agent_life_expand_user_path "$agent_life_discover_core_configured")" "config"
  elif [ -d "$agent_life_discover_core_root/../agent-core" ]; then
    printf '%s|%s\n' "$(cd -- "$agent_life_discover_core_root/../agent-core" && pwd)" "sibling"
  elif [ -d "$HOME/.agent-core" ]; then
    printf '%s|%s\n' "$HOME/.agent-core" "home"
  else
    printf '%s|%s\n' "" "missing"
  fi
}

agent_life_core_path_from_result() {
  printf '%s\n' "${1%%|*}"
}

agent_life_core_source_from_result() {
  printf '%s\n' "${1#*|}"
}

agent_life_core_discovery_reasoning() {
  agent_life_core_discovery_reasoning_root="$1"
  agent_life_core_discovery_reasoning_configured="$(agent_life_config_value "default-core-path")"
  agent_life_core_discovery_reasoning_config_path="$(agent_life_config_path)"

  printf '%s|%s|%s\n' "AGENT_CORE_PATH" "" "${AGENT_CORE_PATH:-}"
  if [ -n "$agent_life_core_discovery_reasoning_configured" ]; then
    printf '%s|%s|%s\n' "config default-core-path" "$agent_life_core_discovery_reasoning_config_path" "$(agent_life_expand_user_path "$agent_life_core_discovery_reasoning_configured")"
  else
    printf '%s|%s|%s\n' "config default-core-path" "$agent_life_core_discovery_reasoning_config_path" ""
  fi
  printf '%s|%s|%s\n' "sibling ../agent-core" "$agent_life_core_discovery_reasoning_root/../agent-core" ""
  printf '%s|%s|%s\n' "home ~/.agent-core" "$HOME/.agent-core" ""
}
