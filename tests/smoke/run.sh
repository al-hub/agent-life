#!/bin/sh
set -eu

ROOT="$(cd -- "$(dirname -- "$0")/../.." && pwd)"
export AGENT_LIFE_TEST_ROOT="$ROOT"

passed=0
failed=0

for test_script in "$ROOT"/tests/smoke/test_*.sh; do
  [ -f "$test_script" ] || continue

  name="$(basename -- "$test_script")"
  printf 'smoke: %s ... ' "$name"

  if sh "$test_script"; then
    passed=$((passed + 1))
    printf 'ok\n'
  else
    failed=$((failed + 1))
    printf 'failed\n'
  fi
done

printf 'smoke: %s passed, %s failed\n' "$passed" "$failed"

[ "$failed" -eq 0 ] || exit 1
