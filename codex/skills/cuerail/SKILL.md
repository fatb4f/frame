---
name: cuerail
description: Use when working in Codex with Cuerail installed, especially for Cuerail runtime changes, hooks, MCP/git/search policy, managed runtime paths, validation, recovery, or questions about Cuerail authority. Enforces that git and search observations use MCP surfaces, not shell git/rg or repo-local fallback adapters.
metadata:
  short-description: Cuerail runtime and MCP policy
---

# Cuerail

## Authority

Cuerail is a managed Codex runtime payload, not the source of agent authority.

- Codex owns authority through `$CODEX_HOME/config.toml`, hooks, and skills.
- This skill is the agent-facing Cuerail operating procedure.
- `$CODEX_HOME/tools/cuerail` is runtime implementation only.
- `cue/agents` in the Cuerail tree is a migration/source artifact from the old `AGENTS.md` model, not active agent policy.
- Do not recreate `$CODEX_HOME/tools/cuerail/AGENTS.md` as policy.

Structured skill metadata lives next to this file:

- `skills.cue`: skill index, triggers, required tools, delegated surfaces.
- `workflow.cue`: Cuerail runtime work phases and blocking gates.

## Runtime Paths

Use the global runtime paths from `$CODEX_HOME/config.toml`:

```txt
CODEX_HOME=$HOME/.local/share/codex
CODEX_STATE=$HOME/.local/state/codex
CUERAIL_HOME=$CODEX_HOME/tools/cuerail
CUERAIL_BIN=$CUERAIL_HOME/bin
CUERAIL_STATE=$CODEX_STATE/cuerail
```

The canonical command surface is:

```txt
$CUERAIL_HOME/bin
```

`$CODEX_HOME/bin` must not contain independent Cuerail command implementations. At most it may contain declared compatibility shims.

## MCP-Only Observation

For git and source search observations, MCP is the only allowed surface.

- Use `mcp__git_mcp_server__` for git status, staging, diffs, and commits.
- Use `mcp__mcp_ripgrep__` or `mcp__ripgrep__` for search and file listing.
- Do not use shell `git`, shell `rg`, `repo-git`, or `repo-rg` for agent observations.
- If MCP is unavailable, denied, or insufficient, report the blocker instead of falling back to shell.
- Shell commands are still acceptable for validation and execution tasks not covered by MCP, such as `cue vet`, `sh -n`, and runtime command smoke checks.

## Working On Cuerail

Before editing, inspect current state through MCP:

- Repository status: `mcp__git_mcp_server__.git_status` with `repo_path`.
- Search/list files: `mcp__mcp_ripgrep__` tools.

Keep runtime and authority separate:

- Hook/runtime behavior belongs under `$CUERAIL_HOME/bin` and `cue/runtime`.
- Agent operating procedure belongs in this skill.
- Global Codex wiring belongs in `$CODEX_HOME/config.toml`.
- Runtime CUE should describe runtime behavior, capture schemas, and validation shape, not active agent policy.

## Validation

For Cuerail changes, run the narrowest relevant validation:

```sh
cue vet -c=false ./cue/...
sh -n bin/cuerail-* bin/git-mcp-go-cuerail
```

When validating the installed runtime, set explicit global paths rather than deriving from `$PWD`:

```sh
CODEX_HOME="${CODEX_HOME:-$HOME/.local/share/codex}" \
CODEX_STATE="${CODEX_STATE:-$HOME/.local/state/codex}" \
CUERAIL_HOME="${CUERAIL_HOME:-$CODEX_HOME/tools/cuerail}" \
CUERAIL_BIN="${CUERAIL_BIN:-$CUERAIL_HOME/bin}" \
CUERAIL_STATE="${CUERAIL_STATE:-$CODEX_STATE/cuerail}" \
PATH="$CUERAIL_BIN:$PATH" \
"$CUERAIL_BIN/cuerail-doctor"
```

## Recovery

If hooks fail closed with `cuerail fallback` and block all tool calls, do not keep retrying from the same locked session. Restore the broken runtime change from an external shell or a session with hooks disabled, then validate.

Prefer reverting only the smallest runtime files that broke hook evaluation. Do not revert unrelated user changes.
