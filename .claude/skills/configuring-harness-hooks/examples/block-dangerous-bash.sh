#!/usr/bin/env bash
# PreToolUse safety gate — deny destructive shell commands.
# Wire with matcher "Bash". Reads the event JSON on stdin.
set -euo pipefail

command=$(jq -r '.tool_input.command // ""')

# Patterns that are almost never intended and are hard to undo.
# Extend this list per project; keep it conservative to avoid false denies.
dangerous='rm[[:space:]]+-[a-zA-Z]*[rf]|git[[:space:]]+push[[:space:]].*--force|:\(\)\{|mkfs|dd[[:space:]]+if=|>[[:space:]]*/dev/sd'

if printf '%s' "$command" | grep -Eq "$dangerous"; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Blocked by safety gate: destructive command. If this is intentional, run it manually or narrow the scope."
    }
  }'
  exit 0
fi

# Not dangerous: defer to the normal permission flow.
exit 0
