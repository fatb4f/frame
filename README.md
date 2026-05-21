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
skills/*     -> Codex routing hints only
```

## Layout

```txt
repo-frame-slim/
  cue/
    state.cue
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
```

## Anti-sprawl invariant

Every file must answer one of these:

1. Does it define the CUE state?
2. Does it validate/select/project the state?
3. Does it adapt rg into the state?
4. Does it adapt git/sem into the state?
5. Does it tell Codex when to use one of the above?
