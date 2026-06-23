# CI/CD (GitHub Actions)

A single `Check` workflow runs the same checks CI and the harness enforce locally. The
shape: **one job per language** (each running that language's format/lint/typecheck/test
from its reference) **plus a `pinact` job** that verifies actions are SHA-pinned.

## Principles

- **Trigger** on `push` to the default branch and `pull_request` against it.
- **One job per language** so failures are isolated and the matrix is legible. Mirror the
  exact commands from python.md / node-ts.md / terraform.md — no CI-only variants.
- **Pin every `uses:` to a commit SHA** with a `# vX.Y.Z` comment; pinact (see
  dependency-hygiene.md) maintains these and a dedicated job fails the build if any drift.
- **Cache** language deps via the setup action's cache option.
- Terraform lives in its own workflow with a `paths:` filter (see terraform.md); keep app
  and infra checks separate so each only runs when relevant.

## `.github/workflows/check.yaml`

Version-bearing values below (`<sha> # vX.Y.Z`, runtime versions) are placeholders —
resolve the current ones at setup time and keep them in sync with `mise.toml`:

```yaml
name: Check
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  python:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: py
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: astral-sh/setup-uv@<sha> # vX.Y.Z
        with:
          version: "<uv version, matching mise>"
          enable-cache: true
          cache-dependency-glob: py/uv.lock
      - run: uv sync --locked
      - run: uv run ruff format --check
      - run: uv run ruff check
      - run: uv run ty check
      - run: uv run pytest

  node:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: node
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: voidzero-dev/setup-vp@<sha> # vX.Y.Z
        with:
          working-directory: node
          node-version: "<node major, matching mise>"
          cache: true
      - run: vp install --frozen-lockfile
      - run: vp check   # format-check + lint + typecheck
      - run: vp test    # vitest

  pinact:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: suzuki-shunsuke/pinact-action@<sha> # vX.Y.Z
        with:
          skip_push: "true"
```

- `<sha>` placeholders are filled by running pinact (see dependency-hygiene.md); keep the
  `# vX.Y.Z` trailing comment so Dependabot can read the version.
- Include only the jobs for languages the repo actually has (drop `node` from a
  Python-only repo, etc.). The `pinact` job is always present.
- Add specialized jobs as needed — e.g. a long e2e job (Playwright) with its own
  `timeout-minutes` and an `upload-artifact` step for the report.

## Deploy workflows

Deployment (build+push image, `terraform apply`, release) is genuinely
project-specific — keep it in a separate `deploy.yaml`, gated on push to the default
branch, using OIDC/WIF for cloud auth. This skill scaffolds the **check** workflow; wire
deploy per the project's infra.
