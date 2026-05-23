# cuerail Agent Contract

This repository defines `cuerail`: a CUE-managed side rail over Codex's native
hook event stream.

For work in this repository, treat CUE as the authority. Do not infer hook
schemas from prose. The official OpenAI/Codex generated hook schemas are the
upstream source, currently expected at:

```txt
/home/_404/src/fatb4f/tmp/codex-schemas/hooks/schema/generated/
```

## Default workflow

1. Preserve the runtime boundary:

   ```txt
   Codex hook JSON
   -> cuerail-hook
   -> CUE #HookManifest
   -> event-valid Codex hook output
   -> optional persisted CUE manifest
   ```

2. Do not implement collectors, Python dispatch, derived telemetry, or
   classification in slice 1.

3. After changing CUE schemas or docs, run:

   ```sh
   cue vet ./cue
   cue export ./cue -e '#ExampleHookManifest'
   cue export ./cue -e '#ExampleTurn'
   ```

4. After changing shell transport scripts, run:

   ```sh
   sh -n bin/cuerail-hook bin/cuerail-doctor
   ```

5. After contract refactors, run the old-name sweep:

   ```sh
   rg 'frame|repo-frame|repo-rg|repo-git|noMCP|FRAME_HOME|frame-codex-hook|frame-doctor' .
   ```

   Every remaining hit must be superseded history, a migration note, or an
   explicit old-name compatibility reference. No remaining hit may be active
   contract text.

## Runtime boundaries

- `cuerail` is installed globally under `$CODEX_HOME/tools/cuerail`.
- `CODEX_HOME` and `CODEX_STATE` are required runtime environment variables.
- `CUERAIL_HOME`, `CUERAIL_STATE`, and `CUERAIL_TURNS` are derived values.
- Runtime execution must not depend on the development checkout path.
- `cuerail-hook` is shell transport only: read stdin, wrap input, call `cue`,
  print CUE-selected output, and persist CUE-selected manifests atomically.
- CUE owns validity, output shape, capture policy, and manifest structure.

## MCP evidence capture

`cuerail` does not govern all MCP usage. It governs what MCP evidence becomes
persisted turn evidence.

MCP evidence capture is allowlisted only for:

```txt
mcp-ripgrep
git-mcp-server
```

Persist initially:

```txt
UserPromptSubmit
Stop
PostToolUse where tool_name is allowlisted for git/rg MCP evidence capture
```

Do not persist unrelated hook events unless a later contract expands the capture
policy.

## Design constraints

- Do not create fake hook event names.
- Do not add a Python-owned adapter in slice 1.
- Do not add hook-owned git/rg collectors in slice 1.
- Do not add derived telemetry schemas in slice 1.
- Do not emit generic hook output that permits fields rejected by the official
  event schema.
- Do not let shell construct semantic output; shell is transport and safety
  fallback only.
- Keep the project deletable: every new file must support official schema
  internalization, CUE validation/projection, capture policy, hook transport,
  doctor gates, or turn artifact validation.

## Superseded names

The following belong only in migration history or explicit compatibility notes:

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
