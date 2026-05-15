#!/bin/sh

smoke_root() {
  if [ -n "${AGENT_LIFE_TEST_ROOT:-}" ]; then
    printf '%s\n' "$AGENT_LIFE_TEST_ROOT"
    return 0
  fi

  cd -- "$(dirname -- "$0")/../.." && pwd
}

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file: $1"
}

assert_dir() {
  [ -d "$1" ] || fail "expected directory: $1"
}

assert_not_exists() {
  [ ! -e "$1" ] || fail "expected path not to exist: $1"
}

assert_contains() {
  case "$1" in
    *"$2"*) return 0 ;;
    *) fail "expected output to contain: $2" ;;
  esac
}

assert_not_contains() {
  case "$1" in
    *"$2"*) fail "expected output not to contain: $2" ;;
    *) return 0 ;;
  esac
}

setup_temp_home() {
  SMOKE_TMP_BASE="$(mktemp -d)"
  export SMOKE_TMP_BASE
  HOME="$SMOKE_TMP_BASE/home"
  export HOME
  mkdir -p "$HOME"
}

make_core() {
  core="$1"
  profile="$2"
  mkdir -p "$core/profiles/$profile"
  printf '# %s\n' "$profile" > "$core/profiles/$profile/AGENTS.md"
}
