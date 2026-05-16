#!/usr/bin/env bash

_agent_init_completion() {
  local cur cword
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  cword="$COMP_CWORD"

  case "$cword" in
    1)
      COMPREPLY=($(compgen -W 'help doctor status list auto ready version' -- "$cur"))
      ;;
  esac
}

complete -F _agent_init_completion agent-init
