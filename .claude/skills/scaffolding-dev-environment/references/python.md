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
CI and local use the same toolchain. Put the dev tools in a dependency group (add lower
bounds at whatever the current versions are):

```toml
[dependency-groups]
dev = ["pytest", "ruff", "ty"]
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
  "COM812", # break formatter compatibility(https://docs.astral.sh/ruff/rules/missing-trailing-comma/#formatter-compatibility)
  "S101",   # Use of `assert` detected
  "T20",    # flake8-print (https://pypi.org/project/flake8-print/)
  # Require explicit type annotations on functions and methods.
  # "ANN",    # flkae8-annotations (https://pypi.org/project/flake8-annotations/)
  "INP001", # File {file} is part of an implicit namespace package. Add an `__init__.py`.
]
unfixable = [
  "ERA001", # do not delete commented code
]

[tool.ruff.lint.flake8-tidy-imports.banned-api]
# Deferred annotation evaluation (PEP 563) is superseded by PEP 649 (Python 3.14+)
# and breaks runtime annotation inspection (e.g. pydantic, dataclasses introspection).
"__future__.annotations".msg = "Do not use `from __future__ import annotations`."
```

- `select = ["ALL"]` then a small, *justified* ignore list keeps the lint surface honest.
- Adjust `target-version` / `line-length` to the repo.

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

Use a `src/` layout with a PEP 561 `py.typed` marker for importable packages.

## CI wiring

A `python` job: checkout → `astral-sh/setup-uv` (cached) → `uv sync --locked` → the four
checks above, each as its own step. See ci-cd.md.