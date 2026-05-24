package cuerail

import hooks "github.com/fatb4f/cuerail/cue/generated/hooks"

hookInput: {
	hook_event_name!: #CodexHookEvent
}

_hookInput: hookInput

awarenessResults: [...#ReadResultEnvelope] | *[]

_awarenessResults: awarenessResults

#HookInputByEvent: {
	"SessionStart":      hooks.#SessionStartCommandInput
	"UserPromptSubmit":  hooks.#UserPromptSubmitCommandInput
	"PreToolUse":        hooks.#PreToolUseCommandInput
	"PermissionRequest": hooks.#PermissionRequestCommandInput
	"PostToolUse":       hooks.#PostToolUseCommandInput
	"PreCompact":        hooks.#PreCompactCommandInput
	"PostCompact":       hooks.#PostCompactCommandInput
	"SubagentStart":     hooks.#SubagentStartCommandInput
	"SubagentStop":      hooks.#SubagentStopCommandInput
	"Stop":              hooks.#StopCommandInput
}

#CodexHookInput: hooks.#SessionStartCommandInput |
	hooks.#UserPromptSubmitCommandInput |
	hooks.#PreToolUseCommandInput |
	hooks.#PermissionRequestCommandInput |
	hooks.#PostToolUseCommandInput |
	hooks.#PreCompactCommandInput |
	hooks.#PostCompactCommandInput |
	hooks.#SubagentStartCommandInput |
	hooks.#SubagentStopCommandInput |
	hooks.#StopCommandInput

#HookManifest: #SessionStartHookManifest |
	#UserPromptSubmitHookManifest |
	#PreToolUseHookManifest |
	#PermissionRequestHookManifest |
	#PostToolUseHookManifest |
	#PreCompactHookManifest |
	#PostCompactHookManifest |
	#SubagentStartHookManifest |
	#SubagentStopHookManifest |
	#StopHookManifest

#McpEvidenceTool: "mcp-ripgrep" | "git-mcp-server"

#SessionStartHookManifest: {
	input: hooks.#SessionStartCommandInput & _hookInput
	awareness: {
		plan:    #SessionStartAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#SessionStartCommandOutput
	capture: #CaptureDecision & {
		persist:   true
		eventSlug: "session-start"
		fileStem:  eventSlug
	}
}

#UserPromptSubmitHookManifest: {
	input: hooks.#UserPromptSubmitCommandInput & _hookInput
	awareness: {
		plan:    #UserPromptSubmitAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#UserPromptSubmitCommandOutput
	capture: #CaptureDecision & {
		persist:   true
		eventSlug: "user-prompt-submit"
		fileStem:  eventSlug
	}
}

#PreToolUseHookManifest: {
	input: hooks.#PreToolUseCommandInput & _hookInput
	awareness: {
		plan:    #PreToolUseAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#PreToolUseCommandOutput
	capture: #CaptureDecision & {
		persist:   true
		eventSlug: "pre-tool-use"
		fileStem:  eventSlug
	}
}

#PermissionRequestHookManifest: {
	input: hooks.#PermissionRequestCommandInput & _hookInput
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PermissionRequest"}
		results: _awarenessResults
	}
	output: hooks.#PermissionRequestCommandOutput
	capture: #CaptureDecision & {
		persist:   false
		eventSlug: "permission-request"
		fileStem:  eventSlug
	}
}

#PostToolUseHookManifest: {
	input: hooks.#PostToolUseCommandInput & _hookInput
	awareness: {
		plan:    #PostToolUseAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#PostToolUseCommandOutput
	capture: #CaptureDecision & {
		eventSlug: "post-tool-use"
		if input.tool_name == "mcp-ripgrep" {
			persist:  true
			toolSlug: "mcp-ripgrep"
			fileStem: "\(eventSlug).\(toolSlug)"
		}
		if input.tool_name == "git-mcp-server" {
			persist:  true
			toolSlug: "git-mcp-server"
			fileStem: "\(eventSlug).\(toolSlug)"
		}
		if input.tool_name != "mcp-ripgrep" && input.tool_name != "git-mcp-server" {
			persist: false
			fileStem: eventSlug
		}
	}
}

#PreCompactHookManifest: {
	input: hooks.#PreCompactCommandInput & _hookInput
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PreCompact"}
		results: _awarenessResults
	}
	output: hooks.#PreCompactCommandOutput
	capture: #CaptureDecision & {
		persist:   false
		eventSlug: "pre-compact"
		fileStem:  eventSlug
	}
}

#PostCompactHookManifest: {
	input: hooks.#PostCompactCommandInput & _hookInput
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PostCompact"}
		results: _awarenessResults
	}
	output: hooks.#PostCompactCommandOutput
	capture: #CaptureDecision & {
		persist:   false
		eventSlug: "post-compact"
		fileStem:  eventSlug
	}
}

#SubagentStartHookManifest: {
	input: hooks.#SubagentStartCommandInput & _hookInput
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStart"}
		results: _awarenessResults
	}
	output: hooks.#SubagentStartCommandOutput
	capture: #CaptureDecision & {
		persist:   false
		eventSlug: "subagent-start"
		fileStem:  eventSlug
	}
}

#SubagentStopHookManifest: {
	input: hooks.#SubagentStopCommandInput & _hookInput
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStop"}
		results: _awarenessResults
	}
	output: hooks.#SubagentStopCommandOutput
	capture: #CaptureDecision & {
		persist:   false
		eventSlug: "subagent-stop"
		fileStem:  eventSlug
	}
}

#StopHookManifest: {
	input: hooks.#StopCommandInput & _hookInput
	awareness: {
		plan:    #StopAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#StopCommandOutput
	capture: #CaptureDecision & {
		persist:   true
		eventSlug: "stop"
		fileStem:  eventSlug
	}
}
