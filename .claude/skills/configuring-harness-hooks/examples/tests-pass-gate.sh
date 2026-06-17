#!/usr/bin/env bash
# Stop completion gate — don't let the turn finish while tests fail.
# Wire under the "Stop" event (no matcher). Reads the event JSON on stdin.
#
# CAUTION: this runs the test suite every time Claude tries to finish. Keep the
# command fast (affected tests / a smoke subset) or this becomes painful.
set -euo pipefail

# Avoid an infinite loop: if a previous Stop hook already blocked, don't re-block.
if [ "$(jq -r '.stop_hook_active // false')" = "true" ]; then
  exit 0
fi

# --- Replace with the repo's real, fast test command. ---
test_cmd=(echo "configure: run tests")

if ! output=$("${test_cmd[@]}" 2>&1); then
  jq -n --arg r "Tests are failing — fix them before finishing:\n$output" \
    '{decision: "block", reason: $r}'
  exit 0
fi

exit 0
