---
name: cue
description: Use CUE as the authority surface for repo state, constraints, validation, selectors, and projections. Trigger when validating or projecting repo evidence.
---

# CUE Skill

## Contract

CUE is the authority plane for repo awareness.

Shell scripts are adapters.
`repo-frame` is the Codex-facing consumer of these schemas.

Generated files must be reproducible from authority sources when a generator
exists.

## Use when

- validating repo state
- projecting an agent/review/commit view
- checking adapter output against schemas
- selecting bounded context for an agent turn
- validating slim turn context and review envelopes
- changing `cue/*.cue`
- changing adapter JSON shape

## Commands

```sh
cue vet ./cue
cue export ./cue -e '#ExampleRepoState'
cue export ./cue -e '#ExampleTurnContext'
cue export ./cue -e '#ExampleContextFrame'
cue export ./cue -e '#RepoConstraints'
```

## Workflow

1. Change the CUE schema, selector, projection, or example.
2. Run `cue vet ./cue`.
3. Export `#ExampleContextFrame` and inspect that it contains concrete repo,
   active file, search evidence, constraints, and suggested check fields.
4. If adapter output changed, run `repo-frame` to prove live JSON still unifies.

## Policy

1. Do not add planner schemas.
2. Do not model the agent loop. Only model the slim turn envelope when needed.
3. Do not turn CUE into a framework registry.
4. Keep state boring and inspectable.
5. Prefer one state object plus constraints and selectors.
6. Keep examples concrete enough that `cue export` catches projection drift.

## Failure handling

- Fix CUE validation before trusting adapter output.
- If an export is incomplete, add or repair a concrete example rather than
  weakening the schema.
- If a selector needs surrounding state, use explicit aliases so it does not
  accidentally refer to its own field.
