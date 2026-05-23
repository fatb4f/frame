# cuerail

CUE-managed side rail for Codex turn and hook events.

`cuerail` is a global Codex runtime component. It validates native Codex hook
inputs against CUE-internalized official schemas, emits native Codex hook
outputs, and persists policy-selected CUE hook manifests as turn artifacts.

The repository is the authoring and distribution source. The executing runtime
is installed under `$CODEX_HOME/tools/cuerail` and must not depend on a source
checkout path.

## Contract

```txt
Keep it deletable.

CUE = official Codex hook schemas + capture policy + manifest projection
Codex hooks = native event stream
MCP evidence capture = allowlisted git/rg transport only
Shell = byte transport, cue invocation, atomic persistence

No Python adapter in slice 1.
No hook-owned git/rg collectors in slice 1.
No derived telemetry taxonomy in slice 1.
No source-checkout dependency at runtime.
```

## Runtime graph

```txt
Codex hook event JSON
-> cuerail-hook
-> non-semantic hookInput envelope
-> CUE validates official hook schema
-> CUE generates #HookManifest
-> CUE exports event-valid Codex hook output
-> CapturePolicy decides whether to persist
-> selected hook manifests accumulate under $CODEX_STATE/cuerail/turns
```

## Installed layout

```txt
$CODEX_HOME/tools/cuerail/
  bin/
    cuerail-hook
    cuerail-doctor
    cuerail-schema-sync

  cue.mod/
    module.cue

  cue/
    schema_sync.cue
    schema_lock.cue
    codex_events.cue
    codex_inputs.cue
    codex_outputs.cue
    hook_manifest.cue
    capture_policy.cue
    turn.cue
    examples.cue
    generated/
      hooks/

  test/
    fixtures/
      hooks/
        session-start.json
        user-prompt-submit.json
        post-tool-use.mcp-ripgrep.json
        post-tool-use.git-mcp-server.json
        stop.json
```

## Runtime environment

`CODEX_HOME` and `CODEX_STATE` are required. They are expected to be supplied by
`environment.d` with shell-init fallback outside cuerail.

```sh
: "${CODEX_HOME:?CODEX_HOME is required}"
: "${CODEX_STATE:?CODEX_STATE is required}"
: "${CUERAIL_HOME:=$CODEX_HOME/tools/cuerail}"

CUERAIL_STATE="${CUERAIL_STATE:-$CODEX_STATE/cuerail}"
CUERAIL_TURNS="${CUERAIL_TURNS:-$CUERAIL_STATE/turns}"
```

`cuerail` must not silently choose `~/.codex` or any other fallback root.

## Schema authority

The upstream source for hook schemas is the official OpenAI/Codex generated
schema set currently available at:

```txt
/home/_404/src/fatb4f/tmp/codex-schemas/hooks/schema/generated/
```

CUE files in `cue/codex_events.cue`, `cue/codex_inputs.cue`, and
`cue/codex_outputs.cue` are generated from or mechanically checked against that
source. Prose docs are non-authoritative where they diverge from those schemas.

## Capture policy

`cuerail` governs persisted turn evidence, not all Codex tool usage.

MCP evidence capture is allowlisted only for:

```txt
mcp-ripgrep
git-mcp-server
```

Initial persistence policy:

```txt
persist:
  UserPromptSubmit
  Stop
  PostToolUse where tool_name matches the git/rg MCP allowlist

do not persist initially:
  unrelated PostToolUse
  PreToolUse
  PermissionRequest
  PreCompact
  PostCompact
  SubagentStart
  SubagentStop
```

`PostToolUse.tool_response` is unbounded by nature. Capture policy must include
payload budgets and redaction fields from the first implementation, even if the
initial values are conservative defaults.

## Turn artifact

```txt
$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/
  events/
    000001-user-prompt-submit.cue
    000002-post-tool-use.mcp-ripgrep.cue
    000003-post-tool-use.git-mcp-server.cue
    000004-stop.cue

  turn.cue
```

Persistence rules:

```txt
lock turn directory
allocate sequence only for persisted events
write temp manifest
validate temp manifest
rename temp manifest atomically
uncaptured events do not consume sequence numbers
```

`turn.cue` is static validation/projection CUE. It is not rewritten per event.

## Failure behavior

Context-capable hooks should emit valid no-op output when CUE validation or
projection fails and a safe no-op exists:

```txt
SessionStart
UserPromptSubmit
PostToolUse
SubagentStart
```

Gate/policy hooks fail closed where the official output schema supports it:

```txt
PreToolUse
PermissionRequest
Stop
SubagentStop
```

If no valid fail-closed output applies, the hook exits non-zero with concise
stderr. The hook must never print malformed JSON to stdout.

## Doctor gates

`cuerail-doctor` verifies:

```txt
required env: CODEX_HOME, CODEX_STATE
runtime roots: CUERAIL_HOME, CUERAIL_STATE, CUERAIL_TURNS
required deps: cue, jq, mktemp, flock, mv, mkdir, chmod
official schema source exists
CUE schema internalization does not drift from the official generated schemas
cue vet -c=false ./cue/runtime
cue vet -c=false ./cue/sync
fixtures export #HookManifest.output
fixtures export #HookManifest.capture.persist
supported fixtures run through cuerail-hook without fallback
persisted manifest fixtures validate against turn.cue
sh -n bin/cuerail-hook bin/cuerail-doctor
schema cache/import availability via cuerail-schema-sync --check
```

## Superseded names

The previous contract used these names and concepts. They are migration history,
not the active contract:

```txt
frame
repo-frame
repo-rg
repo-git
noMCP
FRAME_HOME
frame-codex-hook
frame-doctor
```
