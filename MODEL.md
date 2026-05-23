# cuerail Model

`cuerail` models Codex hook invocations as CUE values.

```txt
CodexHookInput JSON
-> hookInput CUE value
-> #HookManifest
-> #HookManifest.output JSON for Codex
-> optional persisted CUE manifest
```

The output is a CUE value internally. It is serialized to JSON only because the
Codex hook protocol expects JSON stdout.

## Event names

```cue
#CodexHookEvent:
  "SessionStart" |
  "UserPromptSubmit" |
  "PreToolUse" |
  "PermissionRequest" |
  "PostToolUse" |
  "PreCompact" |
  "PostCompact" |
  "SubagentStart" |
  "SubagentStop" |
  "Stop"
```

These names are the native Codex hook events. Do not add local runtime event
names.

## Schema authority

CUE hook schemas are generated from or checked against the official OpenAI/Codex
schema artifacts currently expected at:

```txt
/home/_404/src/fatb4f/tmp/codex-schemas/hooks/schema/generated/
```

Where prose conflicts with generated schemas, generated schemas win.

## Hook manifest

```cue
hookInput: _

#HookManifest: {
  input: #CodexHookInput & hookInput
  output: #CodexHookOutput & #OutputForInput
  capture: #CaptureDecision & {
    event: input.hook_event_name
  }
}
```

`#OutputForInput` is event-specific. A shared output type must not admit fields
that any event rejects.

## Output taxonomy

Context-capable outputs:

```txt
SessionStart
UserPromptSubmit
PreToolUse
PostToolUse
SubagentStart
```

Permission-special output:

```txt
PermissionRequest
```

`PermissionRequest` follows the official generated schema shape. In particular,
do not use simplified prose forms when the official output schema uses nested
permission decision fields.

No `hookSpecificOutput`:

```txt
PreCompact
PostCompact
SubagentStop
Stop
```

## Capture policy model

```cue
#CapturePolicy: {
  events: {
    UserPromptSubmit: true
    Stop: true

    PostToolUse: {
      enabled: true
      toolNames: ["mcp-ripgrep", "git-mcp-server"]

      budget: {
        maxToolInputBytes:  int | *16384
        maxToolOutputBytes: int | *65536
        maxManifestBytes:   int | *98304
      }

      redaction: {
        enabled: bool | *true
        denyPatterns: [...string]
      }

      onOversize: "truncate" | "reject" | *"reject"
    }
  }
}
```

The allowlist is for persisted MCP evidence capture only. It does not restrict
unrelated Codex MCP tool usage.

## Turn artifact model

A turn is a directory of captured hook manifests:

```txt
$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/
  events/
    000001-user-prompt-submit.cue
    000002-post-tool-use.mcp-ripgrep.cue
    000003-post-tool-use.git-mcp-server.cue
    000004-stop.cue
  turn.cue
```

`turn.cue` validates ordering, event names, session consistency, turn
consistency where present, manifest shape, and capture policy results.

## Slice 1 exclusions

Do not add these in slice 1:

```txt
collector plans
hook-owned git/rg collectors
Python adapter dispatch
derived telemetry schemas
classification or promotion logic
```

Later consumers may read the captured turn artifact and derive views from it,
but the slice-1 runtime product is the CUE-valid manifest set.

## Superseded model references

The previous model used old names and shell/Python adapter ideas. These terms are
not active model names:

```txt
frame
repo-frame
repo-rg
repo-git
FRAME_HOME
frame-codex-hook
frame-doctor
```
