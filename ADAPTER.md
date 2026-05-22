Approved correction.

## Revised adapter contract

```txt
Shell:
  executable compatibility only

Python:
  main Codex hook adapter
  JSON parsing/validation
  event dispatch
  collector planning
  output construction
  trace writing

CUE:
  authoritative schema/projection layer

git/rg:
  low-level collectors, callable from Python
```

This adapter is installed globally under `$CODEX_HOME`. Repository checkouts are
development sources; the runtime command surface is the installed global Codex
home.

The shape should be:

```txt
Codex runtime
  -> $CODEX_HOME/bin/frame-codex-hook
     -> exec python adapter
        -> validate CodexHookInput[event]
        -> map event -> FrameHookIntent
        -> build CollectorPlan
        -> collectGit(opts) / collectRg(opts)
        -> project evidence
        -> emit CodexHookOutput[event]
```

## Installed disk shape

```txt
$CODEX_HOME/
  bin/
    frame-codex-hook              # tiny shim
    frame-doctor                  # install/runtime/schema doctor

  hooks.json                      # global Codex hook registration

  tools/
    frame/
      frame/
        __init__.py

        hooks/
          __init__.py
          adapter.py              # stdin/stdout hook entry
          events.py               # event -> intent dispatch
          outputs.py              # event-specific output builders
          traces.py               # trace persistence

        collectors/
          __init__.py
          git.py                  # collectGit(opts)
          rg.py                   # collectRg(opts)
          mcp.py                  # optional later collector normalization

        evidence/
          __init__.py
          types.py                # Python-side typed envelopes, if useful
          classify.py             # AdhocUsageEvent classifier

      cue.mod/
        module.cue

      cue/
        codex_hooks.cue           # CodexHookInput/Output
        collectors.cue            # CollectorPlan/Result
        evidence.cue              # GitEvidence/RgEvidence/ToolEvidence
        turn_frame.cue            # TurnFrame projection
        adhoc_usage.cue           # AdhocUsageEvent
        traces.cue                # trace records
        examples.cue

      test/
        fixtures/
          hooks/
            session-start.json
            user-prompt-submit.json
            post-tool-use.json
            stop.json
```

Development checkout shape may mirror `tools/frame/`, but hook execution must
not depend on the current repository path.

## Global hook registration

```txt
$CODEX_HOME/hooks.json
  registers command hooks that call:
    $CODEX_HOME/bin/frame-codex-hook
```

## `bin/frame-codex-hook`

```sh
#!/usr/bin/env sh
set -eu

: "${CODEX_HOME:=$HOME/.codex}"
: "${FRAME_HOME:=$CODEX_HOME/tools/frame}"

export CODEX_HOME FRAME_HOME
exec python3 "$FRAME_HOME/frame/hooks/adapter.py" "$@"
```

## Python owns these boundaries

```txt
adapter.py:
  read stdin
  decode JSON
  dispatch by hook_event_name
  catch failures
  emit event-valid JSON when recovery is safe

events.py:
  SessionStart -> session_context
  UserPromptSubmit -> turn_context
  PreToolUse -> pre_tool_policy
  PermissionRequest -> permission_policy
  PostToolUse -> post_tool_capture
  PreCompact -> pre_compact_gate
  PostCompact -> post_compact_capture
  SubagentStart -> subagent_context
  SubagentStop -> subagent_capture
  Stop -> completion_gate

outputs.py:
  build_session_start_output(...)
  build_user_prompt_submit_output(...)
  build_pre_tool_use_output(...)
  build_permission_request_output(...)
  build_post_tool_use_output(...)
  build_pre_compact_output(...)
  build_post_compact_output(...)
  build_subagent_start_output(...)
  build_subagent_stop_output(...)
  build_stop_output(...)
```

## Initial implementation slice

```txt
Slice 1:
  SessionStart
  UserPromptSubmit
  PostToolUse
  Stop

Schema contract from the start:
  model the full CodexHookInput / CodexHookOutput union
  implement unsupported events as explicit no-op handlers or disabled bindings
  do not silently treat unsupported events as successful policy decisions
```

## Failure behavior

```txt
Context hooks:
  SessionStart
  UserPromptSubmit
  PostToolUse
  SubagentStart

  On collector/projection failure:
    record trace
    emit event-valid JSON without additionalContext when safe
    never emit malformed JSON

Policy or gate hooks:
  PreToolUse
  PermissionRequest
  Stop
  SubagentStop

  On validation/planning/gate failure:
    fail closed when the event controls permission or completion
    emit decision:block + reason when the schema supports it
    otherwise exit non-zero with a concise stderr reason

Compact hooks:
  PreCompact
  PostCompact

  On failure:
    record trace
    return event-valid no-op output or fail clearly if no valid output applies
```

## Collector rule

```txt
collectGit(opts) and collectRg(opts) are reusable generic collectors.

They do not know:
  hook event semantics
  whether context should be injected
  whether Stop should block
  whether an action is avoidable

They only know:
  mode
  root
  paths
  query/base
  budget
  output schema
```

## Shell remains acceptable only here

```txt
Good shell uses:
  bin/frame-codex-hook shim
  bin/frame-doctor if simple
  maybe direct fallback wrappers during migration

Bad shell uses:
  main hook adapter
  event-specific output builders
  JSON/schema normalization
  trace classification
  MCP output rewriting
```

## Final approved implementation shape

```txt
Generic:
  $CODEX_HOME/bin/frame-codex-hook shim
  Python adapter kernel
  collectGit(opts)
  collectRg(opts)
  shared trace envelope

Typed:
  event-specific input schemas
  event-specific output schemas
  collector item payloads
  collector plans
  TurnFrame / ToolEvidence / AdhocUsageEvent projections
```

This is the right point to proceed to slices.
