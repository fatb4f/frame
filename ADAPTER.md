# cuerail Adapter Contract

`cuerail-hook` is a thin shell transport for CUE.

It does not own hook semantics, event routing, collector planning, or output
construction. CUE owns validity, output shape, capture policy, and manifest
structure.

## Runtime path

```txt
Codex runtime
-> $CODEX_HOME/tools/cuerail/bin/cuerail-hook
-> hookInput CUE envelope
-> #HookManifest
-> #HookManifest.output
```

## Shell responsibilities

```txt
read stdin into temp JSON
wrap as {"hookInput": <payload>} without interpreting semantics
run cue export for #HookManifest.output
run cue export for #HookManifest.capture.persist
if capture.persist is true:
  allocate sequence under lock
  render #HookManifest with the pinned command
  validate temporary manifest
  atomically rename into the turn events directory
print only #HookManifest.output JSON to stdout
write diagnostics only to stderr
```

Using `jq` only to wrap the complete input payload under `hookInput` is allowed.
`jq` must not perform semantic hook parsing.

## Required environment

```sh
: "${CODEX_HOME:?CODEX_HOME is required}"
: "${CODEX_STATE:?CODEX_STATE is required}"
: "${CUERAIL_HOME:=$CODEX_HOME/tools/cuerail}"

CUERAIL_STATE="${CUERAIL_STATE:-$CODEX_STATE/cuerail}"
CUERAIL_TURNS="${CUERAIL_TURNS:-$CUERAIL_STATE/turns}"
```

No fallback roots are allowed in the hook path.

## Installed disk shape

```txt
$CODEX_HOME/tools/cuerail/
  bin/
    cuerail-hook
    cuerail-doctor
    cuerail-schema-sync
    cuerail-config-schema-sync

  cue.mod/
    module.cue

  cue/
    codex_events.cue
    codex_inputs.cue
    codex_outputs.cue
    hook_manifest.cue
    capture_policy.cue
    turn.cue
    examples.cue

  test/
    fixtures/
      hooks/
        session-start.json
        user-prompt-submit.json
        post-tool-use.mcp-ripgrep.json
        post-tool-use.git-mcp-server.json
        stop.json
```

## Pinned CUE commands

The exact commands are part of the contract and must be fixture-tested.

```sh
 cue export "$CUERAIL_HOME/cue/runtime" "$wrapped_json" -e '#HookManifest.output'
 cue export "$CUERAIL_HOME/cue/runtime" "$wrapped_json" -e '#HookManifest.capture.persist'
```

The persisted manifest command must be pinned by implementation tests. Preferred
form, if supported by the installed CUE version:

```sh
 cue export "$CUERAIL_HOME/cue/runtime" "$wrapped_json" -e '#HookManifest' --out cue
```

If that form is not supported or does not produce the desired manifest shape,
use the tested fallback:

```sh
 cue eval "$CUERAIL_HOME/cue/runtime" "$wrapped_json" -e '#HookManifest'
```

Do not leave persisted manifest rendering ambiguous.

## Failure behavior

On CUE failure, the shell may inspect only `hook_event_name` to choose a
hard-coded transport-safety fallback. This is not semantic routing; it exists to
avoid malformed stdout.

Context-capable hooks:

```txt
SessionStart
UserPromptSubmit
PostToolUse
SubagentStart
```

Fallback: emit valid no-op output when a safe no-op exists, do not persist a
manifest, and write diagnostics to stderr.

Gate/policy hooks:

```txt
PreToolUse
PermissionRequest
Stop
SubagentStop
```

Fallback: emit valid block/deny output where the official schema supports it.
If no valid fail-closed output is available, exit non-zero with concise stderr.

Compact hooks:

```txt
PreCompact
PostCompact
```

Fallback: emit event-valid no-op output if the official schema permits it;
otherwise fail clearly.

## Atomic persistence protocol

```txt
turn root = $CODEX_STATE/cuerail/turns/<session_id>/<turn_id>
events root = $turn_root/events
lock file = $turn_root/.lock
sequence = next integer allocated while holding lock
filename = <seq>-<event>-<safe-tool-name>.cue
```

Rules:

```txt
uncaptured events do not consume sequence numbers
write manifest to temp file in the target directory
validate temp manifest
rename temp file atomically
never write partial final files
```

## Doctor gates

`cuerail-doctor` checks:

```txt
CODEX_HOME and CODEX_STATE are set
CUERAIL_HOME resolves to $CODEX_HOME/tools/cuerail unless overridden
CUERAIL_STATE and CUERAIL_TURNS are writable or creatable
cue, jq, mktemp, flock, mv, mkdir, chmod are available
official schema source exists
CUE schema internalization is current against official generated schemas
cue vet -c=false ./cue/runtime
cue vet -c=false ./cue/sync
each fixture exports #HookManifest.output
each fixture exports #HookManifest.capture.persist
each supported fixture runs through cuerail-hook without fallback
persisted manifest fixtures validate through turn.cue
sh -n bin/cuerail-hook bin/cuerail-doctor bin/cuerail-schema-sync bin/cuerail-config-schema-sync
```

## Slice 1 exclusions

Do not implement these in the adapter slice:

```txt
Python dispatch
collector plans
hook-owned git/rg collectors
derived telemetry schemas
classification or promotion logic
```

## Superseded adapter references

The previous adapter proposal used these names and responsibilities. They are
superseded history, not active adapter design. `repo-git` and `repo-rg` remain
only as temporary worktree-local fallback adapters until `git-mcp-server` and
`mcp-ripgrep` replace them:

```txt
frame-codex-hook
frame-doctor
FRAME_HOME
Python-owned hook adapter
collectGit(opts)
collectRg(opts)
repo-frame
```
