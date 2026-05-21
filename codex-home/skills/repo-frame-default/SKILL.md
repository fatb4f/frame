---
name: repo-frame-default
description: Use when working in a repository that provides repo-frame. For non-trivial repo work, run repo-frame first and treat its JSON as the current context frame.
---

# Repo Frame Default

## Immediate Rule

For non-trivial repo work, run:

```sh
export PATH="$PWD/bin:$PATH"
repo-frame . "$USER_GOAL"
```

Treat the emitted JSON as the current context frame.

## If Search Evidence Matters

For exact symbols, strings, paths, config keys, or error messages, run:

```sh
repo-frame . "$USER_GOAL" 'literal text' literal 80
```

Use regex only when needed:

```sh
repo-frame . "$USER_GOAL" 'regex_pattern' regex 80
```

## Contract

- Use `repo-frame` before broad file reads.
- Use `repo.changed`, `activeFiles`, `searchEvidence`, and `suggestedChecks` as
  evidence.
- Listed files are attention hints, not mandatory edit targets.
- If the frame lacks evidence, rerun with a narrower query or use `repo-rg`.
- After changing frame CUE or adapters, run the suggested checks.

## Plan Boundary

Do not extend `update_plan`.
Do not parse `PlanDelta` as canonical.
Do not add dynamic tools or MCP.

Use sidecar validation instead:

```txt
normalize native plan
-> bind sidecar to native step identity
-> validate sidecar with CUE
-> run evals/tests through stable shell adapters
-> validate evidence with CUE
```

## Fallback

If `repo-frame` is not present in the current repository, use normal Codex repo
inspection and do not invent a replacement loop.
