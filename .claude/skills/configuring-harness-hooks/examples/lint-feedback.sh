#!/usr/bin/env bash
# PostToolUse quality loop — the central harness pattern.
# After an Edit/Write, run the project's fast deterministic check on the changed
# file. On failure, return the output as additionalContext so the agent fixes its
# own work this turn. On success, stay silent. Wire with matcher "Edit|Write".
set -euo pipefail

file=$(jq -r '.tool_input.file_path // ""')
[ -n "$file" ] && [ -f "$file" ] || exit 0

# --- Replace this with the repo's real, fast check for the changed file. ---
# Lint/format/type-check the SINGLE file, not the whole build — this runs on
# every edit. Examples (pick what the repo actually uses):
#   *.ts|*.tsx) check="oxlint $file" ;;        # or: biome check "$file"
#   *.py)       check="ruff check $file" ;;
#   *.go)       check="golangci-lint run $(dirname "$file")" ;;
case "$file" in
  *.ts|*.tsx|*.js|*.jsx) check=(echo "configure: lint $file") ;;
  *.py)                  check=(echo "configure: lint $file") ;;
  *)                     exit 0 ;;  # no check for this file type
esac

if ! output=$("${check[@]}" 2>&1); then
  jq -n --arg ctx "$output" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: ("Lint/check failed on the file you just edited. Fix it before continuing:\n" + $ctx)
    }
  }'
fi

exit 0
