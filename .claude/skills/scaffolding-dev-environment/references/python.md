# Python tooling

Recommended default stack: **uv** (package manager + runner), **ruff** (formatter +
linter), **ty** (type checker, Astral), **pytest** (tests). All four are fast, share a
single `pyproject.toml`, and run identically locally and in CI.

If the repo already uses a different stack (poetry, black, mypy/pyright, flake8),
respect it — add only the missing check rather than swapping tools.

> **Versions:** numbers below are illustrative. At setup time, resolve the *current*
> stable of each tool and pin that — don't copy a number from this doc, it will be stale.

## Commands (the four checks)

```bash
uv sync --locked          # install deps + dev group from the lockfile
uv run ruff format --check # format (drop --check to apply)
uv run ruff check         # lint
uv run ty check           # typecheck
uv run pytest             # test
```

Pin `python` and `uv` versions in `mise.toml` (see common.md), so
CI and local use the same toolchain. The Python version lives in exactly **two** places:
`mise.toml` and the CI `setup-uv` step's `python-version:` — don't add a `.python-version`
file as a third source that can drift out of sync.

Put the dev tools in a dependency group (add lower bounds at whatever the current versions
are), together with any type stubs (`types-*`, `*-stubs`) the runtime deps need — without
them `ty` can't check third-party calls:

```toml
[dependency-groups]
dev = ["pytest", "ruff", "ty", "types-pyyaml"]
```

## ruff config — copy this verbatim

The default rule set is intentionally broad (`select = ["ALL"]`) with a curated,
justified ignore list. The ignore list is the reusable part — copy it as-is:

```toml
[tool.ruff]
line-length = 100
target-version = "py3XX"   # match the project's Python version
src = ["src", "tests"]

[tool.ruff.lint]
select = ["ALL"]
ignore = [
  "E501",   # Line too long (ignored by pysen)
  "D",      # pydocstyle (https://pypi.org/project/pydocstyle/)
  "ICN",    # flake8-import-conventions (https://github.com/joaopalmeiro/flake8-import-conventions)
  "CPY",    # flake8-copyright (https://pypi.org/project/flake8-copyright/): no license headers
  "COM812", # break formatter compatibility(https://docs.astral.sh/ruff/rules/missing-trailing-comma/#formatter-compatibility)
  "S101",   # Use of `assert` detected
  "T20",    # flake8-print (https://pypi.org/project/flake8-print/)
  # Require explicit type annotations on functions and methods.
  # "ANN",    # flake8-annotations (https://pypi.org/project/flake8-annotations/)
  "INP001", # File {file} is part of an implicit namespace package. Add an `__init__.py`.
]
unfixable = [
  "ERA001", # do not delete commented code
]

[tool.ruff.lint.flake8-tidy-imports.banned-api]
# Deferred annotation evaluation (PEP 563) is superseded by PEP 649 (Python 3.14+)
# and breaks runtime annotation inspection (e.g. pydantic, dataclasses introspection).
"__future__.annotations".msg = "Do not use `from __future__ import annotations`."

[tool.ruff.lint.per-file-ignores]
"tests/**" = [
  "PLR0913", # Too many arguments: keyword-only test-fixture helpers are fine
  "PLR2004", # Magic value used in comparison: literal expected values are idiomatic in tests
]
```

- `select = ["ALL"]` then a small, *justified* ignore list keeps the lint surface honest.
- Adjust `target-version` / `line-length` to the repo.
- Keep the relaxations for test code in `per-file-ignores` rather than the global `ignore`
  list, so production code stays under the full rule set.

## uv / ty / pytest config

```toml
[tool.uv]
# Reproducible resolution: ignore releases newer than this window when resolving,
# which also dodges brand-new (possibly compromised) versions. See dependency-hygiene.md.
exclude-newer = "1 week"

[tool.ty.src]
include = ["src", "tests"]

[tool.pytest.ini_options]
testpaths = ["tests"]
# Tier slow/external tests behind markers and exclude them from the default run
# so the inner loop and CI's fast job stay quick:
# addopts = "-m 'not integration'"
# markers = ["integration: ..."]
```

## Package layout

Use a `src/` layout with a PEP 561 `py.typed` marker for importable packages, and build it
with uv's own backend so no extra build tool enters the toolchain:

```toml
[build-system]
requires = ["uv_build>=X.Y,<X.Z"]   # current stable, capped at the next minor
build-backend = "uv_build"

[project.scripts]
<name> = "<pkg>.cli:app"   # only if the package exposes a CLI
```

Put `tests/` at the repo root, outside `src/` — `src = ["src", "tests"]` in the ruff config
and `include = ["src", "tests"]` in `[tool.ty.src]` already cover both.

## CI & harness wiring

A `python` job: checkout → `astral-sh/setup-uv` (cached, `python-version` matching
`mise.toml`) → `uv sync --locked` → the four checks above, each as its own step. See
ci-cd.md.

The harness should run the same checks per edited file — add `--no-sync`
(`uv run --no-sync ruff check "$file"`) so every edit doesn't re-resolve the environment.
See [[configuring-harness-hooks]].