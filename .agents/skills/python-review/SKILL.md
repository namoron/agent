---
name: python-review
description: Use when reviewing Python changes for bugs, regressions, missing tests, typing issues, and security risks. Optimized for risk-first code review rather than style-only feedback.
---

# Python Review

Use this skill when asked to review Python code or to sanity-check a Python diff before merge.

## Review Order

1. Correctness and behavioral regressions
2. Exception handling and edge cases
3. Missing or weak tests
4. Type safety and maintainability
5. Security-sensitive issues

## Things To Look For

- Silent exception swallowing or overly broad `except`
- Mutable default arguments
- Missing validation at system boundaries
- Unsafe subprocess usage or shell string interpolation
- SQL built with string concatenation or f-strings
- Path traversal risks from user-controlled paths
- N+1 query patterns or repeated I/O in loops
- Public functions without useful type hints
- Tests that do not cover the changed branch or failure path

## Output Style

- Lead with findings, not a summary.
- Order findings by severity.
- Be concrete about file, behavior, and likely impact.
- Treat missing tests as a real risk when behavior changed.

## Helpful Commands

- `git diff -- '*.py'`
- `pytest path/to/test_file.py`
- `ruff check .`
- `black --check .`
- `bandit -r src/`

## Review Standard

Prefer minimal, high-signal feedback.
Do not suggest broad cleanup unless it clearly reduces risk.
