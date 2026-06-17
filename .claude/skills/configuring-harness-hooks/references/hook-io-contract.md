# Hook I/O contract (cheat-sheet)

Condensed from the Claude Code hooks docs (https://code.claude.com/docs/en/hooks).
Read this before writing a hook script.

## Events (the ones that matter for harnessing)

| Event | Fires | Can block? | Typical use |
|---|---|---|---|
| `PreToolUse` | before a tool runs | yes | safety gate (deny destructive ops) |
| `PostToolUse` | after a tool succeeds | feedback only | quality loop (lint/format/type) |
| `Stop` | when Claude finishes responding | yes | completion gate (tests must pass) |
| `UserPromptSubmit` | when the user submits a prompt | yes | inject context / guard input |
| `SessionStart` | session start or resume | no | load branch / open issues into context |

## stdin (the hook reads event JSON on standard input)

Common fields on every event:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/working/dir",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse"
}
```

Event-specific additions:

- `PreToolUse` / `PostToolUse`: `tool_name`, `tool_input` (e.g.
  `tool_input.command` for Bash, `tool_input.file_path` for Edit/Write).
- `UserPromptSubmit`: `prompt`.

Parse with `jq`, e.g. `CMD=$(jq -r '.tool_input.command')`.

## Exit codes

| Code | Meaning | Effect |
|---|---|---|
| `0` | success | stdout JSON (if any) is processed; continue |
| `2` | blocking error | **stderr is shown to the agent**, the action is stopped |
| other | non-blocking error | stderr surfaced as a warning; continue |

`exit 2` is the quick way to block. JSON output (below) is the expressive way.

## JSON output (printed to stdout, exit 0)

### PreToolUse — permission decision

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Destructive command blocked"
  }
}
```

`permissionDecision`: `"allow"` | `"deny"` | `"ask"` | `"defer"` (follow normal flow).
Always include a reason on `deny`/`ask`.

### PostToolUse — inject context / replace output

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "lint failed: src/x.ts:3 no-unused-vars"
  }
}
```

`additionalContext` is appended to the agent's context (the self-correction loop).
`updatedToolOutput` replaces the tool's result instead.

### Stop / UserPromptSubmit — block

```json
{ "decision": "block", "reason": "Test suite is failing; fix before finishing." }
```

### Common top-level fields (any event)

`continue` (false stops further processing), `suppressOutput`, `systemMessage`
(warning shown to the user), `additionalContext`.

## settings.json wiring

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/lint-feedback.sh", "timeout": 60 }
        ]
      }
    ]
  }
}
```

### matcher syntax

| Pattern | Matches |
|---|---|
| `*` or omitted | every tool / event |
| `Bash` | exact tool name |
| `Edit\|Write` | a list (alternation) |
| `^Notebook`, `mcp__.*`, `mcp__.*__write.*` | regex (any non-`[A-Za-z0-9_|]` char triggers regex mode) |

### command forms

- **Shell form** (no `args`): `"command": "npm test && npm run lint"` — runs in a shell.
- **Exec form** (`args` present): `"command": "node", "args": ["${CLAUDE_PLUGIN_ROOT}/x.js"]`.

### config hierarchy (later = more local)

```
~/.claude/settings.json        # all projects (personal)
.claude/settings.json          # this project (commit → team-shared)
.claude/settings.local.json    # this project, local only (gitignored)
```

Debug with the `/hooks` menu or `claude --debug`.
