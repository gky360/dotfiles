---
name: authoring-agent-instructions
description: Use when creating or editing an AGENTS.md, CLAUDE.md, GEMINI.md, or similar agent-instruction file — covers what to include vs omit, size limits, pointer-over-prose design, and how to split details into skills/rules. Triggers on writing, reviewing, trimming, or auditing these files.
---

# Authoring AGENTS.md / CLAUDE.md

> The terms **MUST** **SHOULD** **MAY** comply with RFC 2119.

Guidelines for writing agent-instruction files (AGENTS.md, CLAUDE.md, GEMINI.md).
These files are loaded into the system prompt **every session**, so every line
competes with the actual task for the model's attention.

## Core principle

- **MUST** keep the root file lean. Prefer **pointers** (references to real paths
  in the repo) over **prose** (descriptive explanations of how the system works).
- A pointer that breaks fails **loudly** (the path 404s). Descriptive docs rot
  **silently** — the agent cannot tell stale prose from current code and treats
  whatever it finds as equally authoritative.

## Size targets

- **SHOULD** target **≤50 lines**. Hard limit **150 lines** — performance
  degradation is observed beyond this point.
- The agent's own system prompt is already ~50 instructions, so a user file
  **SHOULD** stay within ~100 lines on top of that.

## Include (write this)

- **Routing instructions**: the minimal commands for test / lint / typecheck /
  build / setup (e.g. `npm test`, `npx tsc --noEmit`, setup command).
- **Prohibitions**: each item **SHOULD** carry a reference to an ADR or a linter
  rule, ideally enforced structurally.
- **Pointers**: paths to ADRs (`/docs/adr/`), rules, sub-directory AGENTS.md, etc.

## Exclude (do not write this)

- Descriptive prose explaining "how the system currently works", architecture
  overviews, hand-written API descriptions.
- Tech-stack explanations — readable from `package.json` / `go.mod`.
- Coding style / formatting — delegate to the linter and formatter.
- Timestamp-less specs that rot independently of the code.

## The deletion test

- For every line ask: **"Would the agent get this wrong if I deleted this line?"**
  If **No**, delete it. Push detail to on-demand loading instead.

## Split strategy (push detail out of the root)

- **Skills** — split by capability/feature, loaded on demand.
- **`.claude/rules/`** — split rule detail.
- **Sub-directory AGENTS.md** — split by domain.
- **ADRs (`/docs/adr/`)** — preserve decisions in an immutable, dated form.
- **Separate repo** — consider for large documentation sets.

## Prefer enforceable artifacts over written rules

- Don't merely write "run the linter" — enforce it with a Hook
  (PreToolUse / PostToolUse) or a linter rule so it runs without exception.
- Executable artifacts (code, tests, schemas, ADRs) resist rot far better than
  prose. Tests are more durable documentation than descriptions.
- **SHOULD** verify pointers in CI (link-check) so broken references fail loudly.

## Quick checklist

1. Root file ≤50 lines (hard max 150)?
2. Pointers over prose — every claim references a real path?
3. Routing commands (test/lint/typecheck/build/setup) present and minimal?
4. Prohibitions each tied to an ADR or linter/hook rule?
5. Removed tech-stack/style/architecture prose the tooling already covers?
6. Each remaining line passes the deletion test?
7. Detail pushed to skills / rules / sub-dir AGENTS.md / ADRs?
