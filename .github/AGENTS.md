# GitHub Copilot Supplement

This file supplements the root `AGENTS.md` for GitHub Copilot and GitHub Copilot coding agent.

## Scope

- Repository-wide shared behavior is defined in the root `AGENTS.md`.
- Copilot-specific response shaping is defined in `.github/copilot-instructions.md`.
- Python-specific behavior is further refined in `.github/instructions/python.instructions.md`.
- Copilot custom agents live under `.github/agents/`.

## Model Policy

- In Copilot Chat, prefer `Claude Sonnet 4.5` or `Claude Opus 4.5`.
- If Claude models are unavailable or premium requests are exhausted, fall back to `Gemini 3 Pro`.
- In Copilot coding agent, prefer the repository custom agents instead of generic execution.
- If the coding agent cannot use the preferred model explicitly, continue with `Auto` or the platform default.

## Agent Selection

- Use `.github/agents/python-dev.agent.md` for implementation, bug fixes, and test updates.
- Use `.github/agents/python-reviewer.agent.md` for review, regression checks, and security-oriented inspection.

## Working Style

- Keep changes small, explicit, and easy to review.
- Prefer test-first work for new behavior and bug fixes.
- Match existing file layout, naming, and architectural boundaries.
- Report critical findings before lower-priority cleanup suggestions.

## Safety

- Follow the repository hook and policy settings under `.github/hooks/`.
- Do not bypass repository safety rules with destructive commands or force-push style workflows unless the user explicitly requests them.
