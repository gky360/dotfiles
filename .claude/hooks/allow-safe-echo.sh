#!/usr/bin/env bash
# PreToolUse hook — auto-approve inert `echo` commands so that the common
# `echo "EXIT: $?"` exit-code check does not prompt on every run.
#
# Since CVE-2025-66032 (fixed in v1.0.93) Claude Code treats any command
# containing `$` expansion as fail-closed and routes it to a permission prompt
# instead of the read-only fast path. A blunt `^echo` auto-approve would reopen
# that hole (e.g. `echo ${x@P}` / `echo $(cmd)` command-execution tricks), so we
# approve only echo commands proven inert: no shell metacharacters that could
# substitute, redirect, or chain, and `$?` as the only permitted expansion.
#
# Wire with matcher "Bash". Reads the event JSON on stdin.
set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

# Defer to the normal permission flow (prompt as before): emit nothing, exit 0.
defer() { exit 0; }

# Must be an `echo` command.
[[ "$cmd" =~ ^[[:space:]]*echo([[:space:]]|$) ]] || defer

# Reject any metacharacter that enables command substitution, brace transforms,
# redirection, or command chaining. Their absence makes echo side-effect free.
case "$cmd" in
  *'`'*|*'('*|*')'*|*'{'*|*'}'*|*'<'*|*'>'*|*'|'*|*';'*|*'&'*) defer ;;
esac

# Reject embedded newlines (could smuggle a second command line).
if [[ "$cmd" == *$'\n'* ]]; then defer; fi

# Only `$?` is permitted as an expansion; reject any other `$` use ($$, $VAR, ${...}).
rest="${cmd//\$\?/}"
case "$rest" in *'$'*) defer ;; esac

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "allow",
    permissionDecisionReason: "Auto-approved: inert echo (only $? expansion, no substitution/redirection/chaining)."
  }
}'
