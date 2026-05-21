# repo-frame-slim

Minimal repo-context surface for Codex/agent turns.

## Contract

```txt
Adapters observe.
CUE unifies.
Views project.
Policies validate.
Agents consume.
Evals judge.
```

Runtime surface:

```txt
repo-rg      -> bounded text-search evidence
repo-git     -> git / optional semantic-git evidence
cue          -> state unification, validation, selectors, views
turn frame   -> bounded context contract for a single agent turn
skills/*     -> Codex routing hints only
```

## Layout

```txt
repo-frame-slim/
  cue/
    state.cue
    turn.cue
    frame.cue
    constraints.cue
    views.cue
    cmd.cue
  bin/
    repo-rg
    repo-git
  skills/
    cue/SKILL.md
    repo-search/SKILL.md
    semantic-git/SKILL.md
```

## Usage

```sh
export PATH="$PWD/bin:$PATH"

repo-git status .
repo-git summary .
repo-rg 'TODO' . literal 40

cue vet ./cue
cue export ./cue -e '#RepoState'
cue export ./cue -e '#TurnContext'
cue export ./cue -e '#ContextFrame'
```

## Turn compaction model

The turn frame is a context compiler, not an agent orchestrator:

```txt
observe repo facts -> validate state -> project frame -> agent consumes
agent acts normally -> checks/eval record whether the frame was enough
```

`#TurnContext` keeps the full typed control state for one turn:

```txt
turn         user input, cwd, and goal
repo         git/search observations and projected views
task         kind, scope, constraints, and unknowns
budget       optional context limits
projection   compact #ContextFrame for agent attention
validation   whether the projection is fresh and valid
eval         optional post-turn checks and missing evidence
```

`#ContextFrame` is the compact consumption surface. Markdown may be rendered from
it, but the CUE/JSON object remains the source of truth.

## Anti-sprawl invariant

Every file must answer one of these:

1. Does it define the CUE state?
2. Does it validate/select/project the state?
3. Does it adapt rg into the state?
4. Does it adapt git/sem into the state?
5. Does it tell Codex when to use one of the above?
6. Does it define the single-turn context projection contract?
