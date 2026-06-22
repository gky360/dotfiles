---
paths:
  - "**/*.py"
---

# Python

- **SHOULD** prefer read-only abstract types over concrete mutable ones:
  - `Sequence` / `Mapping` (from `collections.abc`) over `list` / `dict`
  - `frozenset[T]` over `set[T]`
- Concrete mutable types **MAY** still be used for internal / private state.
