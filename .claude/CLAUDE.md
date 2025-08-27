# CLAUDE.md - Claude Code Development Guidelines

> The terms [MUST][SHOULD][MAY] in this document comply with RFC 2119:
>
> - [MUST GLOBAL]: A higher-level concept than MUST. Takes precedence over project-specific CLAUDE.md files
> - [MUST]: Absolute requirement. Must be followed without exception
> - [SHOULD]: Strong recommendation. Should be followed unless there are special reasons not to
> - [MAY]: Optional item. Adoption should be determined according to the situation

## [MUST] Core

- Don't hold back. Give it your all.
- Always Think in English, but respond in Japanese.
- For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
- MUST use subagents for complex problem verification
- After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding. Use your thinking to plan and iterate based on this new information, and then take the best next action.

## [MUST] Workflow Structure

- Follow Explore-Plan-Code-Commit approach
- Always read and understand existing code before making changes
- Create detailed plans before implementation
- Use iterative approaches
- Course-correct early and frequently
- MUST run project-specific lint commands (if available) before completing each task
- MUST run project-specific tests (if available) for affected functionality before completing each task
- MUST create a git commit before completing each task

## [MUST] Git and Version Control

- MUST write commit messages in English
- Use clear and descriptive commit messages following conventional commit format when possible

## [MUST] Context Management

- Provide visual references
- Include relevant background information and constraints
- MUST update and maintain CLAUDE.md files for persistent project context
- Document project-specific patterns and conventions

## [MUST] Problem-Solving Approach

- Leverage thinking capabilities for complex multi-step reasoning
- Focus on understanding problem requirements rather than just passing tests
- Use test-driven development

## [MUST] Tool and Resource Optimization

- Optimize tool usage with parallel calling for maximum efficiency
- Use subagents for complex problem verification
