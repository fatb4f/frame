# cuerail Install Contract

Do not make `$CODEX_HOME` a Git repository.

`$CODEX_HOME` is the global Codex runtime root. It contains auth, sessions,
plugins, generated files, caches, and other operational state. The tracked
runtime boundary is only:

```txt
$CODEX_HOME/tools/cuerail
```

## Ownership Split

Tracked runtime worktree:

```txt
$CODEX_HOME/tools/cuerail/
  bin/
  cue/
  cue.mod/
  test/
  README.md
  INSTALL.md
```

Generated install surface:

```txt
$CODEX_HOME/config.toml
$CODEX_HOME/AGENTS.md
$CODEX_HOME/tools/cuerail/bin
```

The active Cuerail command surface is `$CODEX_HOME/tools/cuerail/bin`.
`$CODEX_HOME/bin` must not contain independent Cuerail implementations.

Mutable state:

```txt
$CODEX_STATE/cuerail/
$CUERAIL_HOME/.cuerail/runs/
```

Never track:

```txt
$CODEX_HOME/auth.json
$CODEX_HOME/sessions/
$CODEX_HOME/cache/
$CODEX_HOME/plugins/
$CODEX_HOME/models_cache.json
$CODEX_HOME/version.json
$CODEX_STATE/cuerail/
```

## Runtime Environment

`CODEX_HOME` and `CODEX_STATE` are required. The installer and shims derive:

```sh
CUERAIL_HOME="${CUERAIL_HOME:-$CODEX_HOME/tools/cuerail}"
CUERAIL_STATE="${CUERAIL_STATE:-$CODEX_STATE/cuerail}"
CUERAIL_TURNS="${CUERAIL_TURNS:-$CUERAIL_HOME/.cuerail/runs}"
```

No fallback to `~/.codex` or any other root is allowed.

## Install Shape

Preferred active-development shape:

```txt
$CODEX_HOME/tools/cuerail = Git worktree
```

The source repository may remain named `frame` until the runtime shape proves
out. The important invariant is that hook execution does not require a source
checkout outside `$CODEX_HOME/tools/cuerail`.

Do not symlink `$CODEX_HOME/tools/cuerail` to the authoring checkout. A worktree
keeps a native runtime path, tracked files, and separate mutable state without
making the whole Codex home a repository.

By default the installer creates or reuses a dedicated runtime branch:

```txt
cuerail-runtime
```

Override with `CUERAIL_WORKTREE_BRANCH` only when you intentionally want another
runtime branch.

## Installer Scope

`bin/cuerail-install` wires the runtime projection:

```txt
create $CODEX_HOME/tools
create $CUERAIL_HOME/.cuerail/runs
materialize $CODEX_HOME/tools/cuerail as a Git worktree when missing
use CUERAIL_WORKTREE_BRANCH or cuerail-runtime for the worktree branch
remove legacy Cuerail wrappers from $CODEX_HOME/bin
refuse to use $CODEX_HOME itself as the tracked checkout
refuse symlinked runtime paths
```

Hook registration is installed only after `cuerail-hook` exists. This prevents
registering a non-functional hook during the contract/install slice.
