---
name: scaffolding-dev-environment
description: Use when setting up or auditing a repository's development-environment tooling — per-language lint/typecheck/format/test, GitHub Actions CI, Dependabot, pinact, and mise version pinning. Triggers on "開発環境を整備して", "set up CI", "add lint/typecheck", "add dependabot/pinact", "整備して".
---

# Scaffolding a Dev Environment

> The terms **MUST** **SHOULD** **MAY** comply with RFC 2119.

Bring any repository up to a consistent baseline of development-environment machinery:
per-language quality checks, CI, dependency hygiene, version pinning, and the agent
harness. The point is **uniform coverage across repos** — the same checks pass the same
way everywhere, so quality is enforced by tooling, not memory.

This skill encodes a recommended default stack (Python: uv/ruff/ty/pytest; Node-TS:
pnpm; Terraform: fmt/validate/tflint/trivy; plus Dependabot + pinact + mise). It is
**opinionated about defaults but respectful of what exists** — see the core principle.

## Core principle: audit first, fill gaps, never clobber

- **MUST** detect what the repo already has **before** writing anything. Setup is an
  *audit-then-fill* operation, not a template dump.
- **Respect choices, fill gaps.** "Respect what exists" means *don't swap a tool the repo
  already chose* (don't replace its eslint with vite-plus, its mypy with ty). It does
  **not** mean "skip a check that's entirely absent." A missing linter / formatter / type
  check / test runner is a **gap to fill** with the recommended default — not a choice to
  respect. The target is all four checks present and CI-runnable for every language; only
  the *tool* yields to what's already there.
- **MUST** enforce quality with deterministic tools wired into CI and the harness, not
  with prose. A check that runs on every push beats a sentence in CLAUDE.md.
- **SHOULD** keep every check runnable two ways: locally (one command) and in CI (the
  same command). If they diverge, they rot.

## Step 1 — Detect

Before proposing changes, inventory the repo:

- **Languages**: `pyproject.toml` / `package.json` / `*.tf` / `go.mod` / `Cargo.toml`.
- **Existing quality config**: ruff/eslint/biome/prettier/tsconfig, test runner config.
- **CI**: `.github/workflows/*.{yml,yaml}` — which jobs already exist?
- **Dependency hygiene**: `.github/dependabot.yml`, `.github/pinact.yaml`, pnpm `minimumReleaseAge`.
- **Version pinning**: `mise.toml` / `.tool-versions` / `.python-version` / `.nvmrc`.
- **Harness**: `.claude/settings.json`, `.claude/hooks/`, `CLAUDE.md` / `AGENTS.md`.

Report present vs. missing per category, then fill only the gaps.

## Step 2 — Fill each category

Each category has a reference with the recommended config, exact commands, and the
generalized snippet to adapt. Read the relevant one before writing files:

| Category | What to set up | Reference |
|---|---|---|
| **Python** | uv + ruff (format/check) + ty + pytest | [references/python.md](references/python.md) |
| **Node / TypeScript** | pnpm + tsconfig(strictest) + lint/format/typecheck/test | [references/node-ts.md](references/node-ts.md) |
| **Terraform** | fmt -check + validate + tflint + trivy | [references/terraform.md](references/terraform.md) |
| **CI/CD** | GitHub Actions: per-language lint+typecheck+test jobs + a `pinact` job | [references/ci-cd.md](references/ci-cd.md) |
| **Dependency hygiene** | Dependabot, pinact, pnpm `minimumReleaseAge` / `cooldown` | [references/dependency-hygiene.md](references/dependency-hygiene.md) |
| **Version pinning & misc** | mise pinning; other-language fallback | [references/common.md](references/common.md) |

For languages outside the first-class three (Go, Rust, …), apply the same *shape* —
a formatter, a linter, a type/compile check, and a test runner, each wired into CI and
pinned via mise. See the fallback note in [references/common.md](references/common.md).

## Step 3 — Harness (delegate, don't re-document)

The agent harness is part of the dev environment, but its detail lives in dedicated
skills. Don't reinvent or re-document it here — point at them:

- **Hooks** (quality-feedback loops, completion gates, safety gates) → [[configuring-harness-hooks]].
  Wire the per-language checks from Step 2 into hooks so the harness enforces what CI does.
- **`CLAUDE.md` / `AGENTS.md`** → [[authoring-agent-instructions]]. Keep it lean: point at
  the tools you just set up rather than re-describing them.

## Quick checklist

Audit a repo against this; every "no" is a gap to fill.

1. Each present language has format + lint + typecheck + test, each as a single command?
2. A `mise.toml` (or equivalent) pins every tool/runtime version used in CI?
3. A GitHub Actions workflow runs those checks on push and PR, one job per language?
4. The CI includes a `pinact` job, and workflow actions are pinned to commit SHAs (with `.github/pinact.yaml`, including a `min_age` adoption delay)?
5. `dependabot.yml` covers every ecosystem (github-actions/npm/uv/terraform, weekly), grouped, with `cooldown`?
6. New-version adoption delay set where supported (pnpm `minimumReleaseAge`)?
7. Harness wired — hooks ([[configuring-harness-hooks]]) and lean `CLAUDE.md`/`AGENTS.md` ([[authoring-agent-instructions]])?
8. Nothing pre-existing was overwritten — only gaps were filled?
