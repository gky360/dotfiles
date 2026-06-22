---
paths:
  - "**/*.py"
---

# Python

- **SHOULD** favor immutability wherever practical:
  - `Sequence` / `Mapping` (from `collections.abc`) over `list` / `dict`; `frozenset[T]` over `set[T]`
  - `tuple` over `list`; frozen dataclasses / `NamedTuple` over mutable classes
