package cuerail

import hooks "github.com/fatb4f/cuerail/cue/generated/hooks"

hookInput: {
	hook_event_name!: #CodexHookEvent
	...
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
	_hookInputValue: hooks.#SessionStartCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #SessionStartAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#SessionStartCommandOutput
	capture: #CaptureDecisionForEvent.SessionStart
}

#UserPromptSubmitHookManifest: {
	_hookInputValue: hooks.#UserPromptSubmitCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #UserPromptSubmitAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#UserPromptSubmitCommandOutput
	capture: #CaptureDecisionForEvent.UserPromptSubmit
}

#PreToolUseHookManifest: {
	_hookInputValue: hooks.#PreToolUseCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #PreToolUseAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#PreToolUseCommandOutput
	capture: #CaptureDecisionForEvent.PreToolUse
}

#PermissionRequestHookManifest: {
	_hookInputValue: hooks.#PermissionRequestCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PermissionRequest"}
		results: _awarenessResults
	}
	output: hooks.#PermissionRequestCommandOutput
	capture: #CaptureDecisionForEvent.PermissionRequest
}

#PostToolUseHookManifest: {
	_hookInputValue: hooks.#PostToolUseCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #PostToolUseAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#PostToolUseCommandOutput
	capture: #CaptureDecisionForEvent.PostToolUse & {
		if input.tool_name == "mcp-ripgrep" {
			persist:  #CapturePolicy.persist.postToolUse."mcp-ripgrep"
			toolSlug: "mcp-ripgrep"
			fileStem: "\(#CapturePolicy.eventSlugs.PostToolUse).\(toolSlug)"
		}
		if input.tool_name == "git-mcp-server" {
			persist:  #CapturePolicy.persist.postToolUse."git-mcp-server"
			toolSlug: "git-mcp-server"
			fileStem: "\(#CapturePolicy.eventSlugs.PostToolUse).\(toolSlug)"
		}
		if input.tool_name != "mcp-ripgrep" && input.tool_name != "git-mcp-server" {
			persist: #CapturePolicy.persist.events.PostToolUse
			fileStem: #CapturePolicy.eventSlugs.PostToolUse
		}
	}
}

#PreCompactHookManifest: {
	_hookInputValue: hooks.#PreCompactCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PreCompact"}
		results: _awarenessResults
	}
	output: hooks.#PreCompactCommandOutput
	capture: #CaptureDecisionForEvent.PreCompact
}

#PostCompactHookManifest: {
	_hookInputValue: hooks.#PostCompactCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PostCompact"}
		results: _awarenessResults
	}
	output: hooks.#PostCompactCommandOutput
	capture: #CaptureDecisionForEvent.PostCompact
}

#SubagentStartHookManifest: {
	_hookInputValue: hooks.#SubagentStartCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStart"}
		results: _awarenessResults
	}
	output: hooks.#SubagentStartCommandOutput
	capture: #CaptureDecisionForEvent.SubagentStart
}

#SubagentStopHookManifest: {
	_hookInputValue: hooks.#SubagentStopCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStop"}
		results: _awarenessResults
	}
	output: hooks.#SubagentStopCommandOutput
	capture: #CaptureDecisionForEvent.SubagentStop
}

#StopHookManifest: {
	_hookInputValue: hooks.#StopCommandInput & _hookInput
	input:           _hookInputValue
	awareness: {
		plan:    #StopAwarenessPlan
		results: _awarenessResults
	}
	output: hooks.#StopCommandOutput
	capture: #CaptureDecisionForEvent.Stop
}
