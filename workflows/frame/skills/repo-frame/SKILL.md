---
name: repo-frame
description: Use repo-frame as the default Codex turn-context entrypoint when repository state, current changes, or bounded search evidence should be made explicit. Trigger at the start of implementation, review, debug, explain, or commit work in this repo.
---

# Repo Frame Skill

## Contract

`repo-frame` is the Codex-facing context compiler.

It observes bounded repo facts with adapters, unifies them through CUE, and emits
the compact `#ContextFrame` JSON that the agent should use for the current turn.

```txt
repo-git status + optional repo-rg query
-> temporary #TurnContext
-> CUE unification
-> #ContextFrame JSON
```

## Use When

- starting repo-aware work
- checking current dirty files
- gathering search evidence for a concrete symbol, string, config key, or path
- preparing a review, debug pass, commit summary, or explanation
- validating whether the CUE projection contains enough context for a turn

## Do Not Use When

- the user asks a non-repo question
- the task is a single direct shell query unrelated to repo state
- broad crawling would be required to guess the goal

Run from the repository root unless a narrower root is explicitly needed.

## Commands

Observe only git state:

```sh
repo-frame . "$USER_GOAL"
```

Observe git state plus bounded literal search:

```sh
repo-frame . "$USER_GOAL" 'literal text' literal 80
```

Observe git state plus bounded regex search:

```sh
repo-frame . "$USER_GOAL" 'regex_pattern' regex 80
```

## Agent Workflow

1. Run `repo-frame` before broad file reads.
2. Read the emitted `repo.changed`, `activeFiles`, `searchEvidence`, and
   `suggestedChecks` fields.
3. Use listed files as attention hints, not as mandatory edit targets.
4. If the frame lacks needed evidence, run a narrower `repo-frame` query or use
   `repo-rg` directly.
5. After changing schemas, projections, or adapters, run the checks listed by
   the frame plus the verification commands below.

## Native Plan Sidecar

Do not extend `update_plan`.
Do not parse `PlanDelta` as canonical.
Do not add dynamic tools or MCP for plan validation.

Use the native plan only as a status rail. When semantic validation is needed,
bind a sidecar to the completed native plan steps:

```txt
native plan step text/status
-> normalized native-plan artifact
-> sidecar with reads/writes/symbols/protected impact/gates
-> CUE plan gate
-> eval/test evidence
-> CUE evidence gate
```

Bind sidecar steps to native steps by turn id, ordinal, step text, and text hash.
Run validation through stable shell adapters such as `plan-vet` and
`evidence-vet` when those adapters exist.

## Verification

```sh
cue vet ./cue
cue export ./cue -e '#ExampleContextFrame'
repo-frame . "$USER_GOAL" '#RepoState' literal 20
sh -n bin/repo-frame bin/repo-git bin/repo-rg
```

## Failure Handling

- If `repo-frame` fails because `cue` is missing, report that CUE is required.
- If `repo-frame` fails outside a git repo, rerun from the repo root.
- If the search result is too broad or truncated, rerun with a narrower query.
- If CUE validation fails, fix the schema/projection before trusting the frame.

## Boundaries

- Evidence only; no planning loop.
- Current repository only; never `$HOME` or `/`.
- CUE remains the authority. Shell scripts remain adapters.
- Keep output bounded and inspectable.
- Native plan status is not validation status.
