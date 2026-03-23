#!/usr/bin/env bash
set -euo pipefail

mode="${1:?mode is required}"

python - "$mode" <<'PY'
import json
import os
import re
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path


def read_input() -> dict:
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    return json.loads(raw)


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def write_json_line(path: Path, value: dict) -> None:
    with path.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(value, ensure_ascii=False) + "\n")


def shorten(text: str, limit: int = 96) -> str:
    if not text:
        return ""
    value = re.sub(r"\s+", " ", text).strip()
    if len(value) <= limit:
        return value
    return value[: limit - 3].rstrip() + "..."


def slugify(text: str) -> str:
    value = re.sub(r"[^a-z0-9]+", "-", (text or "session").lower()).strip("-")
    return value or "session"


def classify(text: str) -> dict:
    lowered = text.lower()
    if re.search(r"pytest|test|coverage|ruff|black|isort|mypy|bandit|lint|typecheck", lowered):
        return {
            "category": "verification",
            "suggestedSkill": "verification-loop",
            "summary": "Python changes repeatedly touched validation commands or test signals. This session is a good candidate for a reusable verification loop.",
        }
    if re.search(r"worktree|parallel|orchestr|subagent|fleet", lowered):
        return {
            "category": "orchestration",
            "suggestedSkill": "parallel-worktrees",
            "summary": "The session referenced orchestration or parallel execution. Capture the branching, worktree, and merge pattern as a reusable workflow.",
        }
    if re.search(r"review|regression|security|bug", lowered):
        return {
            "category": "review",
            "suggestedSkill": "python-review",
            "summary": "The session centered on review, regression control, or security checks. This may be reusable as a Python review checklist.",
        }
    if re.search(r"refactor|pattern|architecture|service|protocol|dataclass|boundary", lowered):
        return {
            "category": "patterns",
            "suggestedSkill": "python-patterns",
            "summary": "The session contained structure or architecture decisions that may be worth curating as a Python pattern.",
        }
    return {
        "category": "implementation",
        "suggestedSkill": "python-tdd",
        "summary": "The session looks like general implementation work. Review whether any test-first workflow or local convention should be promoted into a skill.",
    }


def format_markdown(candidate: dict) -> str:
    tools = ", ".join(candidate["toolsUsed"]) if candidate["toolsUsed"] else "none"
    errors = "; ".join(candidate["errors"]) if candidate["errors"] else "none"
    prompts = "\n".join(f"- {item}" for item in candidate["promptSamples"]) if candidate["promptSamples"] else "- none captured"
    return f"""# Learning Candidate

- Captured at: {candidate['capturedAt']}
- Category: {candidate['category']}
- Suggested skill: {candidate['suggestedSkill']}
- Session end reason: {candidate['reason']}
- Prompt count: {candidate['promptCount']}
- Tool count: {candidate['toolCount']}

## Summary

{candidate['summary']}

## Evidence

- Last prompt: {candidate['lastPrompt']}
- Tools used: {tools}
- Errors: {errors}

## Prompt Samples

{prompts}
"""


data = read_input()
mode = sys.argv[1]
cwd = data.get("cwd") or os.getcwd()
state_root = Path(cwd) / ".git" / "copilot-memory"
sessions_root = state_root / "sessions"
current_session = state_root / "current-session.jsonl"
learning_candidates = state_root / "learning-candidates.jsonl"
latest_candidate = state_root / "latest-learning-candidate.md"

ensure_dir(state_root)
ensure_dir(sessions_root)

if mode == "sessionStart":
    source = str(data.get("source", ""))
    if source != "resume" or not current_session.exists():
        if current_session.exists():
            current_session.unlink()
    write_json_line(
        current_session,
        {
            "eventType": "sessionStart",
            "timestamp": data.get("timestamp"),
            "cwd": cwd,
            "source": source,
            "initialPrompt": data.get("initialPrompt", ""),
        },
    )
    sys.exit(0)

if mode == "userPromptSubmitted":
    current_session.touch(exist_ok=True)
    write_json_line(
        current_session,
        {
            "eventType": "userPromptSubmitted",
            "timestamp": data.get("timestamp"),
            "cwd": cwd,
            "prompt": data.get("prompt", ""),
        },
    )
    sys.exit(0)

if mode == "postToolUse":
    current_session.touch(exist_ok=True)
    tool_result = data.get("toolResult") or {}
    write_json_line(
        current_session,
        {
            "eventType": "postToolUse",
            "timestamp": data.get("timestamp"),
            "cwd": cwd,
            "toolName": data.get("toolName", ""),
            "toolArgs": data.get("toolArgs", ""),
            "resultType": tool_result.get("resultType", ""),
            "resultText": tool_result.get("textResultForLlm", ""),
        },
    )
    sys.exit(0)

if mode == "errorOccurred":
    current_session.touch(exist_ok=True)
    error = data.get("error") or {}
    write_json_line(
        current_session,
        {
            "eventType": "errorOccurred",
            "timestamp": data.get("timestamp"),
            "cwd": cwd,
            "errorName": error.get("name", ""),
            "errorMessage": error.get("message", ""),
        },
    )
    sys.exit(0)

if mode == "sessionEnd":
    if not current_session.exists():
        sys.exit(0)

    write_json_line(
        current_session,
        {
            "eventType": "sessionEnd",
            "timestamp": data.get("timestamp"),
            "cwd": cwd,
            "reason": data.get("reason", ""),
        },
    )

    events = []
    for line in current_session.read_text(encoding="utf-8").splitlines():
        if line.strip():
            events.append(json.loads(line))

    prompts = []
    for event in events:
        if event.get("eventType") == "sessionStart" and event.get("initialPrompt"):
            prompts.append(str(event["initialPrompt"]))
        if event.get("eventType") == "userPromptSubmitted" and event.get("prompt"):
            prompts.append(str(event["prompt"]))

    post_tools = [event for event in events if event.get("eventType") == "postToolUse"]
    tools_used = sorted({str(event.get("toolName", "")).strip() for event in post_tools if str(event.get("toolName", "")).strip()})
    errors = []
    for event in events:
        if event.get("eventType") == "errorOccurred":
            name = str(event.get("errorName", "")).strip()
            message = str(event.get("errorMessage", "")).strip()
            errors.append(shorten(f"{name}: {message}" if name else message, 80))

    classification_text = "\n".join(prompts + [f"{item.get('toolName', '')} {item.get('toolArgs', '')} {item.get('resultText', '')}" for item in post_tools])
    recommendation = classify(classification_text)

    timestamp = data.get("timestamp")
    if isinstance(timestamp, int):
        captured_at = datetime.fromtimestamp(timestamp / 1000, tz=timezone.utc).isoformat()
        archive_stamp = datetime.fromtimestamp(timestamp / 1000, tz=timezone.utc).strftime("%Y%m%d-%H%M%S")
    else:
        now = datetime.now(tz=timezone.utc)
        captured_at = now.isoformat()
        archive_stamp = now.strftime("%Y%m%d-%H%M%S")

    candidate = {
        "capturedAt": captured_at,
        "cwd": cwd,
        "reason": str(data.get("reason", "")),
        "category": recommendation["category"],
        "suggestedSkill": recommendation["suggestedSkill"],
        "summary": recommendation["summary"],
        "lastPrompt": shorten(prompts[-1], 120) if prompts else "No prompt captured",
        "promptCount": len(prompts),
        "promptSamples": [shorten(item, 120) for item in prompts[-3:]],
        "toolCount": len(post_tools),
        "toolsUsed": tools_used,
        "errors": errors,
    }

    write_json_line(learning_candidates, candidate)
    latest_candidate.write_text(format_markdown(candidate), encoding="utf-8")
    shutil.copyfile(current_session, sessions_root / f"session-{archive_stamp}-{slugify(candidate['reason'])}.jsonl")
    current_session.unlink()
PY
