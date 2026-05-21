## Contract

```txt
Agent context compaction with CUE =
  raw repo/tool observations
  → typed state objects
  → unified CUE graph
  → validated projections
  → small agent-consumable frames
```

Core rule:

```txt
Compaction is not summarization first.
Compaction is selection + projection + validation first.
```

The agent should not be handed “a summary of the repo.”
It should be handed **bounded, typed, queryable context views** produced from the current state graph.

---

## Model

```txt
Adapters observe.
CUE unifies.
Policies constrain.
Views project.
Frames hydrate.
Agents consume.
Evals judge.
```

### Raw signals

```txt
repo tree
git status
git diff
semantic git log
rg hits
file metadata
known task goal
prior turn frame
validation failures
```

### CUE state object

```cue
#AgentContext: {
  turn:      #Turn
  repo:      #RepoSnapshot
  git:       #GitSnapshot
  rg?:       #SearchSnapshot
  task:      #TaskFrame
  budget:    #ContextBudget
  policies:  #ContextPolicies
  views:     #ProjectedViews
}
```

---

## Key constraint

The agent’s context should be **lossy only at projection boundaries**, not at ingestion boundaries.

Bad:

```txt
git diff → prose summary → prompt
```

Better:

```txt
git diff → typed diff object → CUE validation → selected hunks → projected frame
```

That keeps the compacted context inspectable, reproducible, and eval-friendly.

---

## Context compaction pipeline

```txt
1. hydrate
   collect raw facts from repo, git, rg, task, previous frame

2. normalize
   turn tool output into typed objects

3. unify
   CUE combines repo state, git state, search state, task state

4. score
   derive relevance / risk / freshness / ownership / change pressure

5. select
   choose files, hunks, symbols, commands, open questions

6. project
   render frame variants for agent consumption

7. validate
   enforce budget, no secrets, no stale assumptions, required evidence present

8. evaluate
   compare frame quality against task outcome
```

---

## Minimal CUE shape

```cue
package agent

#ContextBudget: {
  maxTokens:       int & >0
  maxFiles:        int & >=0
  maxDiffHunks:    int & >=0
  maxRgHits:       int & >=0
  requireEvidence: bool | *true
}

#TaskFrame: {
  goal:        string
  scope?:      string
  constraints: [...string]
  unknowns?:   [...string]
}

#RepoFile: {
  path:       string
  kind?:      "source" | "config" | "test" | "doc" | "generated" | "unknown"
  tracked:    bool
  modified:   bool
  generated?: bool
  sizeBytes?: int
}

#GitChange: {
  path:      string
  status:    "added" | "modified" | "deleted" | "renamed" | "untracked"
  hunks?: [...#DiffHunk]
}

#DiffHunk: {
  file:       string
  header:     string
  added:      int
  removed:    int
  risk?:      "low" | "medium" | "high"
  relevance?: int
}

#SearchHit: {
  query:   string
  path:    string
  line?:   int
  text?:   string
  symbol?: string
}

#AgentContext: {
  task:   #TaskFrame
  budget: #ContextBudget

  repo: {
    root:  string
    files: [...#RepoFile]
  }

  git: {
    branch?: string
    dirty:   bool
    changes: [...#GitChange]
  }

  search?: {
    hits: [...#SearchHit]
  }

  projections: {
    frame:       #ContextFrame
    validation:  #ContextValidation
  }
}
```

---

## Projection object

```cue
#ContextFrame: {
  objective: string

  activeFiles: [...{
    path:   string
    reason: string
  }]

  relevantChanges: [...{
    path:    string
    summary: string
    hunks?:  [...#DiffHunk]
  }]

  searchEvidence: [...{
    query: string
    hits: [...#SearchHit]
  }]

  constraints: [...string]

  suggestedChecks: [...{
    command: string
    reason:  string
  }]

  openQuestions?: [...string]
}
```

The rendered markdown is a **view**, not the source of truth.

---

## Policy layer

Example constraints:

```cue
#ContextPolicies: {
  noGeneratedByDefault: bool | *true
  includeDirtyFiles:    bool | *true
  includeTests:         bool | *true
  includeDocs:          bool | *false

  secretDenyPatterns: [
    "TOKEN",
    "SECRET",
    "PASSWORD",
    "PRIVATE_KEY",
  ]

  requiredSections: [
    "objective",
    "activeFiles",
    "constraints",
    "suggestedChecks",
  ]
}
```

Validation examples:

```cue
#ContextValidation: {
  ok: bool

  errors?: [...{
    code:    string
    message: string
    path?:   string
  }]

  warnings?: [...{
    code:    string
    message: string
    path?:   string
  }]
}
```

Useful validation failures:

```txt
context.budget.exceeded
context.secret.possible_leak
context.git.dirty_unexplained
context.diff.hunks_missing
context.task.goal_missing
context.search.no_evidence
context.generated_file_selected
context.projection.empty
```

---

## Selection functions

CUE should model the selection contract, even if heavy scoring happens in an adapter.

```txt
file relevance =
  touched by git
  OR matched by rg
  OR imported by touched file
  OR owns failing validation
  OR referenced by task goal
```

Risk scoring:

```txt
high risk:
  deletes
  schema changes
  public API changes
  config/session/bootstrap changes
  generated artifacts changed without source change

medium risk:
  tests changed
  wrappers changed
  command flags changed

low risk:
  docs only
  comments only
  isolated examples
```

Frame pressure:

```txt
include first:
  current dirty diff
  relevant schema
  failing validation
  direct rg evidence
  nearby tests
  adapter contracts

exclude first:
  generated files
  vendor files
  lockfiles unless directly changed
  old prose summaries
  broad tree dumps
```

---

## Why CUE fits

CUE is useful here because the problem is mostly **constraint projection**, not text compression.

```txt
Context object too large?
  CUE does not summarize it.
  CUE selects a valid smaller view.

Agent needs freedom?
  Give it executable projections and queryable views.

Need reproducibility?
  Persist input state + selected projection + validation result.

Need evals?
  Evaluate projection quality, not just final answer quality.
```

---

## Practical repo layout

```txt
agent/
  schema/
    context.cue
    repo.cue
    git.cue
    rg.cue
    frame.cue
    validation.cue

  policy/
    budget.cue
    selection.cue
    secrets.cue
    generated.cue

  views/
    turn-frame.cue
    diff-frame.cue
    search-frame.cue
    eval-frame.cue

  adapters/
    repo-tree
    cue.git
    cue.rg
    cue.diff

  frames/
    session-frame.json
    repo-snapshot.json
    git-snapshot.json
    turn-frame.md
```

---

## Executable surface

Keep the agent-facing command surface small:

```txt
cue cmd hydrate
cue cmd frame
cue cmd rg
cue cmd git
cue cmd validate
cue cmd eval
```

Example:

```sh
cue cmd hydrate > .agent/state/context.json
cue cmd frame   > .agent/frames/turn-frame.md
cue cmd validate
```

Then the agent consumes:

```txt
.agent/frames/turn-frame.md
.agent/state/context.json
```

The markdown is for attention.
The JSON/CUE state is for control.

---

## Adapter boundary

Adapters should be boring.

```txt
rg adapter:
  input: query, path constraints, limits
  output: #SearchSnapshot

git adapter:
  input: repo root
  output: #GitSnapshot

tree adapter:
  input: repo root, ignore rules
  output: #RepoSnapshot

diff adapter:
  input: git diff
  output: typed file/hunk objects
```

Adapters do **not** decide policy.

They only produce facts:

```txt
adapter = observation
cue     = unification / constraint / projection
agent   = consumer
```

---

## Agent frame shape

A compact turn-start frame should look like:

```md
# Turn Frame

## Objective
...

## Active constraints
...

## Current repo state
- branch:
- dirty:
- changed files:

## Relevant files
| file | reason | risk |
|---|---|---|

## Relevant diff
...

## Search evidence
...

## Suggested validation
...

## Do not touch
...

## Open questions
...
```

This is compact, but still grounded.

---

## Main design rule

```txt
Never compact by trusting prose.
Compact by preserving typed evidence and projecting only what the agent needs next.
```

The CUE object becomes the stable sidecar memory.

The agent loop stays normal:

```txt
observe → reason → act → verify
```

The sidecar only improves the quality of `observe`.

It does not force the agent. It shapes the observable field.
