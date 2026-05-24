# Codex Repo Contract

This repository exists to make repo awareness explicit, typed, bounded, and
CUE-governed for Codex turns.

The current active surface is Cuerails, not the earlier `workflows/frame`
surface.

## Active Surface

Use the current Cuerail tools and schemas:

```txt
bin/cuerail-hook
bin/cuerail-doctor
bin/cuerail-schema-sync
git-mcp-server
mcp-ripgrep
bin/repo-git
bin/repo-rg
cue/runtime/*
fixtures/*
```

`git-mcp-server` and `mcp-ripgrep` are the preferred live read substrate for
agent-visible repository observations and hook-executed CUE-approved ReadOps.
Their JSON output is preserved opaquely; do not normalize, compact, or reshape
git/rg results into semantic projections.

`repo-git` and `repo-rg` are temporary worktree-local fallback adapters for
bootstrap and fallback checks only. They are not canonical repo/search
interfaces and must not be used silently when MCP is required:

```txt
git-mcp-server -> live git observation surface
mcp-ripgrep    -> live bounded search surface

repo-git       -> temporary shell fallback for git observations
repo-rg        -> temporary shell fallback for bounded ripgrep observations
```

## Inactive / Legacy Surface

Do not use `workflows/frame` as the active bootstrap path.

```txt
workflows/frame/
workflows/frame/bin/repo-frame
workflows/frame/cue/#ContextFrame
workflows/frame/skills/*
```

These belong to the earlier Cuerails model and may remain only as historical
reference until pruned.

Do not run:

```sh
./workflows/frame/bin/repo-frame . "$USER_GOAL"
repo-frame . "$USER_GOAL"
```

There is no current durable frame runtime and no active `#ContextFrame` contract.

## Turn Start Contract

At the start of repo-aware work, prefer bounded local inspection through the
configured MCP servers:

```txt
git-mcp-server
mcp-ripgrep
```

Use the MCP tools directly when Codex can see them in the active
project/profile. Keep their returned JSON raw and opaque. Do not parse ripgrep
results into path/line/text fields, parse git results into branch/head/dirty
fields, compact diff/log/status output, or add projection layers.

If MCP visibility is in question, inspect the active Codex MCP configuration:

```sh
codex mcp list --json
codex mcp get mcp-ripgrep --json || true
codex mcp get git-mcp-server --json || true
```

If an MCP allowlist exists, `mcp-ripgrep` and `git-mcp-server` must be allowed.
If the allowlist is empty, all MCP servers are disabled. Report missing
commands, missing config, or allowlist blockers explicitly.

Use the repo-local fallback adapter surface only when MCP is unavailable,
when bootstrapping MCP itself, or when a validation path explicitly targets the
fallback adapters. Do not silently fall back from MCP-required work to
`repo-git` or `repo-rg`.

Set the repo-local tool path explicitly from the active worktree:

```sh
PATH="$PWD/bin:$PATH"
```

Fallback repository state checks:

```sh
repo-git status .
repo-git diff .
```

Do not treat `repo-git` as a git-compatible argv passthrough. Do not pass raw
git flags such as `--short` or `--stat`; parse the JSON returned by `repo-git`
when a compact summary is needed.

Fallback exact code, symbol, config key, filename, or string searches:

```sh
repo-rg 'literal text' . literal 80
repo-rg 'regex_pattern' . regex 80
```

Do not expand `repo-git` or `repo-rg` beyond the minimum needed for current
Cuerail checks. If more repo/search capability is needed, add it to the MCP
capture adapter path, not to these fallback scripts. Use direct shell tools only
when neither the MCP surface nor the fallback adapter surface exposes the
required observation.

## Hook / Manifest Contract

CUE is the authority for hook manifest shape and capture policy.

Current active hook manifest surface:

```txt
cue/runtime/hook_manifest.cue
#HookManifest
#HookManifest.capture.persist
```

Persist only the CUE-approved hook events:

```txt
UserPromptSubmit
Stop
PostToolUse where tool_name == mcp-ripgrep
PostToolUse where tool_name == git-mcp-server
```

Do not move capture policy into shell.

Shell scripts are adapters only. They may:

```txt
read hook input
invoke CUE
derive paths
acquire locks
write temp files
validate manifests
rename atomically
```

Shell scripts must not become policy authorities.

## Validation Contract

After changing CUE schemas, hook behavior, schema-sync behavior, or adapter
wiring, run:

```sh
PATH="$PWD/cuerail/bin:$PATH" sh -n cuerail/bin/*
```

Run schema validation:

```sh
CODEX_HOME="${CODEX_HOME:-$HOME/.local/share/codex}" \
CODEX_STATE="${CODEX_STATE:-$HOME/.local/state/codex}" \
PATH="$PWD/cuerail/bin:$PATH" \
cuerail-schema-sync --check
```

Run the doctor:

```sh
CODEX_HOME="${CODEX_HOME:-$HOME/.local/share/codex}" \
CODEX_STATE="${CODEX_STATE:-$HOME/.local/state/codex}" \
PATH="$PWD/cuerail/bin:$PATH" \
cuerail-doctor
```

If changing CUE directly, also run the narrow CUE checks already used by the
current slice. Prefer existing repo-local validation commands over inventing new
ones.

## Plan And Gate Contract

Do not extend Codex's native `update_plan` schema. Treat it as the human-visible
status rail only:

```txt
step text
pending | in_progress | completed
```

Do not parse `PlanDelta` streaming text as canonical. The completed native plan
item is the only native plan text worth binding to.

Do not add dynamic tools, daemons, new runtime tool registries, or MCP
dependencies for plan validation.

For future semantic plan validation, use this side-rail shape:

```txt
normalize native plan
-> bind sidecar to native step identity
-> validate sidecar with CUE
-> run evals/tests through stable adapters
-> validate evidence with CUE
```

Native plan identity should be bound by stable fields such as:

```txt
turn id
step ordinal
completed step text
text hash
```

The sidecar owns semantic fields:

```txt
reads
writes
symbols
protected impact
gates
required evidence
```

This is future-facing unless the repo contains an explicit current CUE schema and
doctor gate for it.

## Skill Routing

Use repo-local skills only as routing hints, not as independent authority.

Current preferred routing:

```txt
CUE work:
  inspect cue/runtime and current schema-sync/doctor fixtures

Git evidence:
  prefer git-mcp-server; use bin/repo-git only as an explicit temporary fallback

Search evidence:
  prefer mcp-ripgrep; use bin/repo-rg only as an explicit temporary fallback

Hook behavior:
  use cuerail-hook, cuerail-doctor, fixtures, and #HookManifest
```

Do not route current work through:

```txt
workflows/frame/skills/SKILL.md
workflows/frame/bin/repo-frame
#ContextFrame
```

## Boundaries

CUE is the authority plane for:

```txt
state shape
validation
selectors
capture policy
projections
examples
```

Shell is the adapter plane for:

```txt
filesystem mechanics
process execution
tool invocation
locking
atomic writes
smoke checks
```

Do not add:

```txt
agent loop
planner framework
Go runtime
Python runtime
broad framework layer
durable frame runtime
new MCP dependency before the adapter path is ready
```

Keep observations bounded to the current repository. Do not search `$HOME` or
`/`.

Keep the project deletable: every new file must support one of:

```txt
state
validation
adapter behavior
fixture coverage
repo-local skill routing
single-turn context contract
```

## Pruning Rule

`workflows/frame` may be pruned once its useful adapter pieces have been moved
into the active Cuerail surface.

Before pruning, confirm no active docs or scripts require:

```txt
workflows/frame/bin/repo-frame
workflows/frame/cue/#ContextFrame
workflows/frame/skills/*
```

It is acceptable for `repo-git` and `repo-rg` to survive under:

```txt
bin/
```

as interim adapters.
