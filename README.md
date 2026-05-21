# agent.cue slim

Minimal repo-context surface for Codex/agent turns.

## Contract

```txt
Keep it deletable.

CUE = one repo state object + slim turn envelope + constraints + selectors
git = semantic repo-change observation
rg  = bounded text search observation

No MCP.
No Go.
No agent-sdk repo.
No framework.
No skill zoo.
```

## Runtime graph

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
    repo-frame
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
repo-git diff .
repo-git staged .
repo-git semantic .

repo-rg 'literal text' . literal 80
repo-rg 'regex_pattern' . regex 80

repo-frame . 'Observe repository state.'
repo-frame . 'Explain repo state wiring.' '#RepoState' literal 80

cue vet ./cue
cue export ./cue -e '#ExampleRepoState'
cue export ./cue -e '#ExampleTurnContext'
cue export ./cue -e '#ExampleContextFrame'
```

## Turn compaction model

The turn frame is a context compiler, not an agent orchestrator:

```txt
observe repo facts -> validate state -> project frame -> agent consumes
agent acts normally -> checks/eval record whether the frame was enough
```

`repo-frame` wires the first half of that loop for local use:

```txt
repo-git status + optional repo-rg query
-> temporary #TurnContext
-> cue export #RuntimeContextFrame
-> JSON #ContextFrame
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
