---
name: semantic-git
description: Use git plus optional sem evidence for bounded repo-change awareness. Trigger for current changes, staged diffs, commit review, changed entities, and blast-radius checks. Do not use as a general crawler.
---

# Semantic Git Skill

## Contract

Use git as the primary change observer.
Use `repo-frame` first when Codex needs a complete turn context.

Use sem only when semantic evidence is useful:
- changed functions/classes/methods
- focused symbol context
- blast radius
- entity-level diff
- staged commit evidence

Do not run semantic analysis from `$HOME`.
Do not use sem to compensate for an underspecified task.
Do not run broad repository scans unless the task requires it.

## Use when

- checking dirty state
- reviewing a diff
- preparing or explaining a commit
- deciding whether semantic evidence is needed for changed entities or impact

## Commands

```sh
repo-frame . "$USER_GOAL"
repo-git status .
repo-git summary .
repo-git diff .
repo-git staged .
repo-git semantic .
```

## Policy

1. Prefer current git root.
2. Prefer staged diff for commit evidence.
3. Prefer changed files before full-tree inspection.
4. Emit JSON when feeding CUE.
5. Treat semantic output as evidence, not policy.
6. Do not hide dirty working tree state from the agent frame.

## Failure handling

- If `sem` is unavailable, `repo-git semantic` still emits valid empty semantic
  fields; do not treat that as fatal.
- If a diff is too large, summarize changed files first and inspect narrower
  paths next.
- If staged and unstaged changes both exist, keep them conceptually separate.
