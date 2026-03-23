---
name: python-tdd
description: Use when implementing or fixing Python behavior with a test-first workflow. Covers writing failing pytest tests first, making the minimum code change, and validating regressions.
---

# Python TDD

Use this skill for Python feature work and bug fixes when test-first execution is practical.

## Workflow

1. Identify the behavior change in one sentence.
2. Find the closest existing test module and follow its structure.
3. Write a failing `pytest` test first.
4. Run the narrowest test target and confirm it fails for the expected reason.
5. Implement the smallest code change that makes the test pass.
6. Re-run the focused test, then expand to nearby tests.
7. Refactor only after the behavior is covered.

## Test Design

- Prefer one behavioral assertion per test when possible.
- Cover both the happy path and the most likely failure path.
- Name tests by behavior, not by implementation detail.
- Use fixtures and factories already present in the repository before inventing new helpers.

## Python Expectations

- Use type hints in production code touched by the change.
- Keep business logic separate from I/O and framework glue.
- Prefer `pathlib.Path`, f-strings, and `logging`.

## Validation

Use only commands that exist in the repo:

- `pytest path/to/test_file.py`
- `pytest -k some_behavior`
- `pytest --cov=src --cov-report=term-missing`
- `ruff check .`

## Stop Conditions

- If the correct behavior is unclear, do not guess broadly. Read adjacent tests, docstrings, and calling code first.
- If a failing test exposes a larger design issue, switch to the architecture agent before expanding the change.
