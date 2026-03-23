# Codex Supplement For Python

This file supplements the root `AGENTS.md` for OpenAI Codex usage in this repository.
Use it together with the repository root instructions, not as a replacement.

## Goal

- Adapt the design intent from `everything-claude-code` to Codex.
- Keep the workflow Python-first, test-first, and review-heavy.
- Prefer explicit reasoning depth over broad but shallow changes.

## Model And Reasoning Policy

Codex does not use Claude models directly in this repository setup.
Instead, map the original Claude-oriented intent to Codex reasoning effort:

- Tasks that would normally use `Claude Sonnet` should use `model_reasoning_effort = "high"`.
- Tasks that would normally use `Claude Opus` should use `model_reasoning_effort = "xhigh"`.

Use this mapping consistently in all project-local Codex agents.

## Python Workflow

1. Read existing code, tests, and nearby modules before editing.
2. For non-trivial work, make a short plan before changing files.
3. Prefer test-first changes for new behavior and bug fixes.
4. Keep diffs small and aligned with the current structure.
5. Validate the narrowest relevant scope first, then expand if needed.

## Python Coding Rules

- Follow PEP 8 and use type hints on function signatures.
- Prefer `pathlib.Path` over `os.path`.
- Prefer f-strings over `%` formatting or `.format()`.
- Prefer `logging` over ad hoc `print()` debugging.
- Keep business logic separate from framework and I/O glue.
- Prefer dataclasses or clear DTO-like objects when argument lists grow.

## Testing And Review

- Use `pytest` as the default testing framework.
- Cover unit, integration, and important regression paths.
- Treat missing tests, swallowed exceptions, weak validation, and type drift as real defects.
- Review findings should prioritize correctness, regressions, security, and test gaps before style.

## Security

- Never hardcode secrets, keys, passwords, or tokens.
- Treat external input, file content, and API responses as untrusted.
- Use parameterized queries and safe subprocess invocation.
- Watch for path traversal, unsafe deserialization, and broad exception handling.

## Local Codex Roles

- `python_dev`: Python implementation and focused bug fixing, `high`
- `python_architect`: decomposition, design, and risky refactors, `xhigh`
- `python_reviewer`: correctness and security review, `xhigh`
- `explorer`: read-only evidence gathering, `high`
- `docs_researcher`: docs and API verification, `high`

## Skills

Prefer repository skills from `.agents/skills/` when they match the task:

- `python-tdd` for test-first Python implementation
- `python-review` for Python diff review and risk assessment
- `python-patterns` for structure, typing, and boundary design decisions

## Validation Commands

Use only what exists in the repository:

- `pytest`
- `pytest --cov=src --cov-report=term-missing`
- `ruff check .`
- `black --check .`
- `isort --check-only .`
- `bandit -r src/`
