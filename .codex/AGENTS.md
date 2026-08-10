# AGENTS.md - Claude Code Development Guidelines

> The terms **MUST** **SHOULD** **MAY** in this document comply with RFC 2119:
>
> - **MUST**: Absolute requirement. Must be followed without exception
> - **SHOULD**: Strong recommendation. Should be followed unless there are special reasons not to
> - **MAY**: Optional item. Adoption should be determined according to the situation

## Core

- Always Think in English, but respond in Japanese.
- **SHOULD** follow YAGNI and KISS: implement only what the current task requires, in the simplest way that works. **SHOULD NOT** add speculative abstractions, options, or generality "for later"
- **MUST** invoke the `ponytail` skill before planning, writing, refactoring, or reviewing code, and follow it

## Workflow Structure

- **MUST** create a git commit before completing each task

## Git and Version Control

- **MUST** write commit messages in English
- **SHOULD** use clear and descriptive commit messages following conventional commit format when possible
- **SHOULD** run `cd <path>` in a separate Bash call before git commands (the working directory persists), instead of `git -C <dir> ...` or `cd <path> && git ...` which bypass permission allowlists like `Bash(git status:*)`

## Context Management

- **MUST** update and maintain AGENTS.md (or CLAUDE.md if you are claude code) files and other documentation to reflect new project knowledge and avoid inconsistencies if necessary
