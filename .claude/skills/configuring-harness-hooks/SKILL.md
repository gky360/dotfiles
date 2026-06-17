---
name: configuring-harness-hooks
description: Use when setting up, configuring, reviewing, or auditing Claude Code hooks (PreToolUse / PostToolUse / Stop / SessionStart) — applies Harness Engineering best practices so quality is enforced by machinery, not prose. Covers safety gates, deterministic quality-feedback loops, completion gates, and observability, plus the settings.json wiring and hook-script I/O contract. Triggers on "set up a hook", "add a lint/test hook", "block dangerous commands", "make the agent self-correct".
---

# Configuring Harness Hooks

> The terms **MUST** **SHOULD** **MAY** comply with RFC 2119.

Guidelines for wiring Claude Code hooks the way Harness Engineering prescribes:
the harness — not the prompt — enforces quality. The same model produces
dramatically better output when the environment makes mistakes hard and
self-correction automatic. Hooks are the primary machinery for that.

This skill is the *how* behind [[authoring-agent-instructions]]'s rule
"don't write 'run the linter' — enforce it with a Hook." Write the rule once as
an executable artifact; let it run without exception.

## Core principle

- **MUST** enforce quality with deterministic tools (linter, formatter,
  type-checker, tests), not with instructions. They are faster and more reliable
  than the model, and they fail the same way every time.
- **MUST** feed a failing tool's output back to the agent so it fixes its own
  work. A feedback loop is what turns "passes almost every time" into "passes
  every time without exception."
- Hooks are executable artifacts → **MUST** commit them with the repo (repository
  hygiene). They resist rot far better than written rules.

## The four patterns

| Pattern | Event | Job | Output mechanism |
|---|---|---|---|
| **Safety gate** | PreToolUse | Block destructive commands & edits to guardrail configs | `permissionDecision: "deny"` (or `exit 2` + stderr) |
| **Quality loop** | PostToolUse | Run linter/formatter/type-check after edits; return errors for self-fix | `hookSpecificOutput.additionalContext` |
| **Completion gate** | Stop | Don't let the turn finish while tests fail | `decision: "block"` + `reason` |
| **Observability** | any | Append intent + result to a log | side effect only, `exit 0` |

Detailed stdin fields, exit-code rules, and JSON output shapes live in
[references/hook-io-contract.md](references/hook-io-contract.md) — read it before
writing a hook script.

## The central pattern: PostToolUse feedback loop

The highest-value hook. On `Edit|Write`, run the project's deterministic check,
and **only when it fails** return the output as `additionalContext` so the agent
sees the error and corrects it in the same turn:

```bash
# fails → feed stderr back; passes → stay silent
if ! out=$(your-linter "$file" 2>&1); then
  jq -n --arg ctx "$out" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$ctx}}'
fi
```

- **SHOULD** keep the check fast (lint/format/type-check the *changed file*), not
  a full build — it runs on every edit.
- **SHOULD** stay silent on success; only inject context on failure to avoid noise.
- The actual command is project-specific. Use each language's fast
  linter/formatter/type-checker; **MUST NOT** hard-code a tool the repo doesn't use.
  Read [examples/lint-feedback.sh](examples/lint-feedback.sh) as the template.

## Placement & sharing

- **Team-shared** hooks → `.claude/settings.json`, **committed**. This is how the
  harness travels with the repo.
- **Personal / machine-local** hooks → `~/.claude/settings.json` (all projects) or
  `.claude/settings.local.json` (this project, gitignored).
- Scripts go in `.claude/hooks/` and **MUST** reference `${CLAUDE_PROJECT_DIR}` for
  portable paths, never absolute home paths.

## Authoring rules

- Each script **MUST** read the event JSON from **stdin** (parse with `jq`), start
  with `set -euo pipefail`, and be executable (`chmod +x`).
- A blocking hook **MUST** explain *why* — put the reason in
  `permissionDecisionReason` / `reason` / stderr so the agent can adapt instead of
  retrying verbatim.
- **SHOULD** scope every hook with a `matcher` (`Bash`, `Edit|Write`, `mcp__.*`) so
  it only fires when relevant; an unscoped hook runs on everything.
- **SHOULD** set a `timeout` on anything that can hang.
- Start from the ready-made templates in [examples/](examples/) and adapt:
  - [block-dangerous-bash.sh](examples/block-dangerous-bash.sh) — deny destructive shell.
  - [protect-guardrails.sh](examples/protect-guardrails.sh) — deny edits to linter/CI config.
  - [lint-feedback.sh](examples/lint-feedback.sh) — the self-correction loop.
  - [tests-pass-gate.sh](examples/tests-pass-gate.sh) — block Stop until tests pass.
  - [settings.json](examples/settings.json) — wires all four with matchers.

## Quick checklist

1. Is the rule enforced by a hook, not just written in CLAUDE.md?
2. Are deterministic checks (lint/format/type) wired to **PostToolUse** on `Edit|Write`?
3. Does the quality loop return failures via `additionalContext` and stay silent on success?
4. Do safety gates protect destructive commands **and** guardrail config files?
5. Does every block carry a *reason* the agent can act on?
6. Is there a completion gate (Stop) so tests must pass before "done"?
7. Is each hook scoped with a `matcher` and given a `timeout` where needed?
8. Are scripts `${CLAUDE_PROJECT_DIR}`-relative, executable, and **committed**?
