---
name: cue
description: Use CUE as the authority surface for repo state, constraints, validation, selectors, and projections. Trigger when validating or projecting repo evidence.
---

# CUE Skill

## Contract

CUE is the authority.

Shell scripts are adapters.
Generated files must be reproducible from authority sources when a generator exists.

## Use when

- validating repo state
- projecting an agent/review/commit view
- checking adapter output against schemas
- selecting bounded context for an agent turn

## Commands

```sh
cue vet ./cue
cue export ./cue -e '#RepoState'
cue export ./cue -e '#RepoConstraints'
```

## Policy

1. Do not add planner schemas.
2. Do not model the agent loop.
3. Do not turn CUE into a framework registry.
4. Keep state boring and inspectable.
5. Prefer one state object plus constraints and selectors.
