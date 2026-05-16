#compdef agent-init

_agent_init_completion() {
  local -a commands
  commands=(help doctor status list auto ready select remove version)

  case $CURRENT in
    2)
      _wanted commands expl 'command' compadd -- $commands
      ;;
  esac
}

if whence compdef >/dev/null 2>&1; then
  compdef _agent_init_completion agent-init
fi
