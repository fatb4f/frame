# Codex Repo Contract

This repository exists to make repo awareness explicit and typed for Codex turns.

Use `repo-frame` as the native entrypoint for turn context whenever work depends
on repository state, current changes, or bounded search evidence.

## Default Workflow

1. At the start of a repo-aware turn, observe the current frame:

   ```sh
   repo-frame . "$USER_GOAL"
   ```

2. If exact code, symbols, config keys, or strings matter, include bounded search
   evidence in the frame:

   ```sh
   repo-frame . "$USER_GOAL" 'literal text' literal 80
   repo-frame . "$USER_GOAL" 'regex_pattern' regex 80
   ```

3. Treat the emitted JSON as the compact `#ContextFrame` for the turn. It is
   evidence, not an instruction to edit every listed file.

4. After changing CUE or adapter behavior, run:

   ```sh
   cue vet ./cue
   cue export ./cue -e '#ExampleContextFrame'
   sh -n bin/repo-frame bin/repo-git bin/repo-rg
   ```

5. When adapter wiring changes, also smoke test the live path:

   ```sh
   PATH="$PWD/bin:$PATH" repo-frame . "$USER_GOAL" '#RepoState' literal 20
   ```

## Plan And Gate Contract

Do not extend Codex's native `update_plan` schema. Treat it as the human-visible
status rail only: step text plus pending, in-progress, or completed status.

Do not parse `PlanDelta` streaming text as canonical. The completed native plan
item is the only native plan text worth binding to.

Do not add dynamic tools, MCP servers, daemons, or new runtime tool registries
for plan validation.

For semantic plan validation, use this side-rail flow:

```txt
normalize native plan
-> bind sidecar to native step identity
-> validate sidecar with CUE
-> run evals/tests through stable shell adapters
-> validate evidence with CUE
```

Native plan identity should be bound by stable fields such as turn id, step
ordinal, completed step text, and a text hash. The sidecar owns semantic fields:
reads, writes, symbols, protected impact, gates, and required evidence.

## Skill Routing

Use these repo-local skills as explicit Codex routing hints:

- `skills/repo-frame/SKILL.md`: default repo-aware turn workflow.
- `skills/repo-search/SKILL.md`: bounded `rg` observations through `repo-rg`.
- `skills/semantic-git/SKILL.md`: git and optional semantic-git observations.
- `skills/cue/SKILL.md`: CUE schema, validation, projection, and examples.

Prefer `repo-frame` first. Drop to `repo-git`, `repo-rg`, or direct CUE exports
only when the narrower evidence or validation surface is needed.

## Boundaries

- CUE is the authority plane for state, validation, selectors, and projections.
- Shell scripts are adapters.
- `repo-frame` composes observations into a CUE-projected turn frame.
- Native `update_plan` remains narrow. Sidecar plan/evidence artifacts carry the
  CUE-validatable semantics.
- Do not add an agent loop, planner schema, MCP dependency, Go runtime, or broad
  framework layer.
- Keep observations bounded to the current repository. Do not search `$HOME` or
  `/`.
- Keep the project deletable: every new file must support state, validation,
  adapters, skills, or the single-turn context contract.
