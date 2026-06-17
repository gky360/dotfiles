# AGENTS.md - Claude Code Development Guidelines

> The terms **MUST** **SHOULD** **MAY** in this document comply with RFC 2119:
>
> - **MUST**: Absolute requirement. Must be followed without exception
> - **SHOULD**: Strong recommendation. Should be followed unless there are special reasons not to
> - **MAY**: Optional item. Adoption should be determined according to the situation

## Core

- Always Think in English, but respond in Japanese.

## Workflow Structure

- **MUST** create a git commit before completing each task

## Git and Version Control

- **MUST** write commit messages in English
- **MUST** use clear and descriptive commit messages following conventional commit format when possible
- **SHOULD NOT** use `git -C <dir> ...` or `cd <path> && git ...` forms. Both bypass permission allowlists like `Bash(git status:*)` (the matcher does not split on `&&`).
- **SHOULD** instead run `cd <path>` in a separate Bash call, then run git commands. The Bash tool's working directory persists across calls.

## Context Management

- **MUST** update and maintain AGENTS.md (or CLAUDE.md if you are claude code) files and other documentation to reflect new project knowledge and avoid inconsistencies if necessary
