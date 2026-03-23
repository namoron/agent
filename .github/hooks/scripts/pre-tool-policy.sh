#!/usr/bin/env bash
set -euo pipefail

input="$(cat || true)"
normalized="$(printf '%s' "$input" | tr '[:upper:]' '[:lower:]')"

patterns=(
  'git reset --hard'
  'git clean -fd'
  'git clean -fdx'
  'git push[^"]*--force'
  'rm -rf /'
  'rm -rf \*'
  'remove-item[^"]*-recurse[^"]*-force'
  'del /f /s /q'
  'format c:'
  'mkfs'
  'drop table'
  'drop database'
  'terraform destroy'
  'kubectl delete namespace'
)

for pattern in "${patterns[@]}"; do
  if printf '%s' "$normalized" | grep -Eiq "$pattern"; then
    printf '%s' '{"permissionDecision":"deny","permissionDecisionReason":"Blocked by repository policy: destructive or forceful command requires explicit human approval."}'
    exit 0
  fi
done

exit 0
