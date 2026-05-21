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
repo-rg
  -> emits bounded search evidence

repo-git
  -> emits git evidence and optional sem evidence

cue
  -> unifies evidence into #RepoState
  -> validates constraints
  -> projects views

agent
  -> consumes projected views
```

## Layout

```txt
agent.cue/
  cue.mod/module.cue
  cue/state.cue
  cue/constraints.cue
  cue/views.cue
  cue/turn.cue
  cue/cmd.cue
  bin/repo-rg
  bin/repo-git
  skills/cue/SKILL.md
  skills/repo-search/SKILL.md
  skills/semantic-git/SKILL.md
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

cue vet ./cue
cue export ./cue -e '#RepoConstraints'
cue export ./cue -e '#TurnContext'
```

## Refactor boundary

Removed from the previous model:

```txt
schema/
workflow.cue turn/sidecar model
app-server protocol mirror
MCP schema surface
agent-sdk skill registry
turn/app-server schemas as imported runtime authority
source-repo upstream reference dumps
generated openai.yaml skill metadata
```

Kept as runtime concepts only:

```txt
skills/cue
skills/repo-search
skills/semantic-git
bin/repo-rg
bin/repo-git
cue/*
```

## Slim turn vocabulary

The repo can name Codex runtime concepts without importing the full app-server schema surface.

Kept as local CUE vocabulary:

```txt
#TurnContext
#TurnItemSummary
#TurnEvaluation
#ReviewStart / #ReviewTarget
#ExecCommandApproval
#FileChangeRequestApproval
```

Ignored by design:

```txt
account/auth
marketplace/plugins
model lists
MCP server management
app lists
Windows sandbox setup
feedback upload
realtime
UI thread archive/name/list operations
plan state
```

## Anti-sprawl invariant

Every file must answer one of these:

1. Does it define the CUE state?
2. Does it validate/select/project the state?
3. Does it adapt rg into the state?
4. Does it adapt git/sem into the state?
5. Does it tell Codex when to use one of the above?
