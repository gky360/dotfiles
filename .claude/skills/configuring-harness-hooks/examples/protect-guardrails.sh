#!/usr/bin/env bash
# PreToolUse safety gate — deny edits to guardrail config files.
# The agent must not weaken the very tools that keep it honest (linter, formatter,
# type-checker, CI). Wire with matcher "Edit|Write". Reads the event JSON on stdin.
set -euo pipefail

file=$(jq -r '.tool_input.file_path // ""')

# Basenames / paths that define the guardrails. Adjust per project.
protected='(^|/)(\.eslintrc|\.oxlintrc|biome\.json|ruff\.toml|\.golangci\.ya?ml|\.editorconfig|tsconfig\.json)|(^|/)\.github/workflows/'

if printf '%s' "$file" | grep -Eq "$protected"; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "This file defines a guardrail (linter/type/CI). Changing it weakens the harness — confirm before editing."
    }
  }'
  exit 0
fi

exit 0
