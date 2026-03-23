---
name: python-patterns
description: Use when designing or refactoring Python code and you need repository-friendly patterns for structure, typing, services, DTOs, validation, and testable boundaries.
---

# Python Patterns

Use this skill when deciding how Python code should be structured, not just what it should do.

## Default Patterns

- Keep modules focused and avoid large mixed-responsibility files.
- Separate business rules from transport, CLI, ORM, or framework glue.
- Prefer explicit data flow over hidden mutation.
- Use dataclasses for simple DTOs and configuration-shaped data.
- Use `Protocol` when callers should depend on behavior rather than concrete storage or service classes.

## Function Design

- Favor small functions with explicit inputs and outputs.
- Prefer returning values over mutating passed-in objects.
- Group repeated parameters into a dataclass when signatures get crowded.
- Raise specific exceptions or return explicit domain results instead of silently failing.

## Boundary Design

- Validate external input at the boundary.
- Convert framework objects into plain Python structures before deeper business logic when useful.
- Keep side effects near the edge of the system so unit tests stay simple.

## Common Choices

- File paths: `pathlib.Path`
- String formatting: f-strings
- Resource cleanup: context managers
- Structured shared data: `dataclass` or `NamedTuple`
- Behavioral abstraction: `Protocol`

## When Refactoring

1. Identify the seam between business logic and side effects.
2. Extract pure logic first.
3. Preserve behavior with tests before moving code around.
4. Only then simplify call sites and naming.
