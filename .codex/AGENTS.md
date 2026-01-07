# AGENTS.md - Claude Code Development Guidelines

> The terms **MUST** **SHOULD** **MAY** in this document comply with RFC 2119:
>
> - **GLOBAL MUST**: A higher-level concept than MUST. Takes precedence over project-specific AGENTS.md (or CLAUDE.md if you are claude code) files
> - **MUST**: Absolute requirement. Must be followed without exception
> - **SHOULD**: Strong recommendation. Should be followed unless there are special reasons not to
> - **MAY**: Optional item. Adoption should be determined according to the situation

## Core

- Don't hold back. Give it your all.
- Always Think in English, but respond in Japanese.
- For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
- **SHOULD** use subagents for complex problem verification
- After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding. Use your thinking to plan and iterate based on this new information, and then take the best next action.

## Workflow Structure

- Follow Explore-Plan-Code-Commit approach
- Always read and understand existing code before making changes
- Create detailed plans before implementation
- Use iterative approaches
- Course-correct early and frequently
- **MUST** run project-specific format commands and lint commands (if available) before completing each task
- **MUST** run project-specific tests (if available) for affected functionality before completing each task
- **MUST** create a git commit before completing each task

## Git and Version Control

- **MUST** write commit messages in English
- **MUST** use clear and descriptive commit messages following conventional commit format when possible
- **MUST** include you as a co-author on every git commit
    - e.g. if you are Codex, use `Co-authored-by: codex <codex@users.noreply.github.com>`

## Context Management

- Provide visual references
- Include relevant background information and constraints
- **MUST** update and maintain AGENTS.md (or CLAUDE.md if you are claude code) files and other documentation to reflect new project knowledge and avoid inconsistencies if necessary
- Document project-specific patterns and conventions

## Problem-Solving Approach

- Leverage thinking capabilities for complex multi-step reasoning
- Focus on understanding problem requirements rather than just passing tests
- Use test-driven development

## Tool and Resource Optimization

- Optimize tool usage with parallel calling for maximum efficiency
- Use subagents for complex problem verification
