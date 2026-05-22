Accepted correction. The implementation-ready output taxonomy should be:

```txt id="q89syo"
Context-capable:
  SessionStart
  UserPromptSubmit
  PreToolUse
  PostToolUse
  SubagentStart

Permission-special:
  PermissionRequest

No hookSpecificOutput:
  PreCompact
  PostCompact
  SubagentStop
  Stop
```

## Final output schema split

```cue id="d7hacp"
#CodexHookOutput:
	#SessionStartOutput |
	#UserPromptSubmitOutput |
	#PreToolUseOutput |
	#PermissionRequestOutput |
	#PostToolUseOutput |
	#PreCompactOutput |
	#PostCompactOutput |
	#SubagentStartOutput |
	#SubagentStopOutput |
	#StopOutput
```

## Context-capable outputs

```cue id="o4h9qs"
#ContextHookSpecificOutput: {
	hookEventName: "SessionStart" | "UserPromptSubmit" | "PreToolUse" | "PostToolUse" | "SubagentStart"
	additionalContext?: string
}

#SessionStartOutput: #CommonHookOutput & {
	hookSpecificOutput?: #ContextHookSpecificOutput & {
		hookEventName: "SessionStart"
	}
}

#UserPromptSubmitOutput: #CommonHookOutput & {
	decision?: "block"
	reason?: string
	hookSpecificOutput?: #ContextHookSpecificOutput & {
		hookEventName: "UserPromptSubmit"
	}
}

#PreToolUseOutput: #CommonHookOutput & {
	decision?: "approve" | "block"
	reason?: string
	hookSpecificOutput?: {
		hookEventName: "PreToolUse"
		additionalContext?: string
		permissionDecision?: "allow" | "deny" | "ask"
		updatedInput?: _
	}
}

#PostToolUseOutput: #CommonHookOutput & {
	decision?: "block"
	reason?: string
	hookSpecificOutput?: {
		hookEventName: "PostToolUse"
		additionalContext?: string
		updatedMCPToolOutput?: _
	}
}

#SubagentStartOutput: #CommonHookOutput & {
	hookSpecificOutput?: #ContextHookSpecificOutput & {
		hookEventName: "SubagentStart"
	}
}
```

## Permission-special output

```cue id="scicpe"
#PermissionRequestOutput: #CommonHookOutput & {
	hookSpecificOutput?: {
		hookEventName: "PermissionRequest"
		decision?: "allow" | "deny" | "ask"
	}
}
```

No `additionalContext` here.

## No `hookSpecificOutput`

```cue id="ixlv84"
#PreCompactOutput: #CommonHookOutput

#PostCompactOutput: #CommonHookOutput

#SubagentStopOutput: #CommonHookOutput & {
	decision?: "block"
	reason?: string
}

#StopOutput: #CommonHookOutput & {
	decision?: "block"
	reason?: string
}
```

## Final approved boundary

```txt id="u8lk71"
Generic:
  frame-codex-hook
  collectGit(opts)
  collectRg(opts)
  shared result base
  trace envelope

Typed:
  hook inputs
  hook outputs
  collector item payloads
  collector plans
  evidence projections
```

## Implementation invariant

```txt id="ch5l59"
A hook handler may share code.
A hook output may not share invalid fields.
```

This is the adapter contract to implement.
