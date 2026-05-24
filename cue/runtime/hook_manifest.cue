package cuerail

import hooks "github.com/fatb4f/cuerail/cue/generated/hooks"

hookInput: {
	hook_event_name!: #CodexHookEvent
	...
}

_hookInput: hookInput

awarenessResults: [...#ReadResultEnvelope] | *[]

_awarenessResults: awarenessResults

awarenessExecutable: bool | *true

_awarenessExecutable: awarenessExecutable

awarenessExecutionReason?: string

_awarenessExecutionReason: awarenessExecutionReason

agentFeedbackContext: string | *""

_agentFeedbackContext: agentFeedbackContext

agentFeedbackMaxBytes: int & >=0 | *8000

_agentFeedbackMaxBytes: agentFeedbackMaxBytes

agentFeedbackTruncated: bool | *false

_agentFeedbackTruncated: agentFeedbackTruncated

agentFeedbackSource: string | *""

_agentFeedbackSource: agentFeedbackSource

#AwarenessExecution: {
	executable: _awarenessExecutable
	if _awarenessExecutable == false {
		reason: _awarenessExecutionReason
	}
}

#AgentFeedChannel: "stdout.additionalContext"

#AgentFeedStatus: "not_attempted" | "emitted" | "invalid_output"

#AgentFeedPayloadKind: "none" | "raw.event" | "raw.tool.response"

#AgentFeed: {
	enabled!:     bool
	channel?:     #AgentFeedChannel
	status!:      #AgentFeedStatus
	payloadKind!: #AgentFeedPayloadKind | *"none"
	bytes?:       int & >=0
	maxBytes?:    int & >=0
	truncated?:   bool
	source?:      string
}

#NoAgentFeed: #AgentFeed & {
	enabled:     false
	status:      "not_attempted"
	payloadKind: "none"
}

#RawEventAgentFeed: #AgentFeed & {
	if _agentFeedbackContext == "" {
		#NoAgentFeed
	}
	if _agentFeedbackContext != "" {
		enabled:     true
		channel:     "stdout.additionalContext"
		status:      "emitted"
		payloadKind: "raw.event"
		bytes:       len(_agentFeedbackContext)
		maxBytes:    _agentFeedbackMaxBytes
		truncated:   _agentFeedbackTruncated
		source:      _agentFeedbackSource
	}
}

#RawToolResponseAgentFeed: #AgentFeed & {
	if _agentFeedbackContext == "" {
		#NoAgentFeed
	}
	if _agentFeedbackContext != "" {
		enabled:     true
		channel:     "stdout.additionalContext"
		status:      "emitted"
		payloadKind: "raw.tool.response"
		bytes:       len(_agentFeedbackContext)
		maxBytes:    _agentFeedbackMaxBytes
		truncated:   _agentFeedbackTruncated
		source:      _agentFeedbackSource
	}
}

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

#SessionStartHookManifest: {
	input: hooks.#SessionStartCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #SessionStartAwarenessPlan
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#SessionStartCommandOutput & {
		if _agentFeedbackContext != "" {
			hookSpecificOutput: {
				hookEventName:     "SessionStart"
				additionalContext: _agentFeedbackContext
			}
		}
	}
	agentFeed: #RawEventAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#UserPromptSubmitHookManifest: {
	input: hooks.#UserPromptSubmitCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #UserPromptSubmitAwarenessPlan
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#UserPromptSubmitCommandOutput & {
		if _agentFeedbackContext != "" {
			hookSpecificOutput: {
				hookEventName:     "UserPromptSubmit"
				additionalContext: _agentFeedbackContext
			}
		}
	}
	agentFeed: #RawEventAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PreToolUseHookManifest: {
	input: hooks.#PreToolUseCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #PreToolUseAwarenessPlan
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#PreToolUseCommandOutput & {
		if _agentFeedbackContext != "" {
			hookSpecificOutput: {
				hookEventName:     "PreToolUse"
				additionalContext: _agentFeedbackContext
			}
		}
	}
	agentFeed: #RawEventAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PermissionRequestHookManifest: {
	input: hooks.#PermissionRequestCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan: #NoAwarenessPlan & {phase: "PermissionRequest"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#PermissionRequestCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PostToolUseHookManifest: {
	input: hooks.#PostToolUseCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #PostToolUseAwarenessPlan
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#PostToolUseCommandOutput & {
		if _agentFeedbackContext != "" {
			hookSpecificOutput: {
				hookEventName:     "PostToolUse"
				additionalContext: _agentFeedbackContext
			}
		}
	}
	agentFeed: #RawToolResponseAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PreCompactHookManifest: {
	input: hooks.#PreCompactCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan: #NoAwarenessPlan & {phase: "PreCompact"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#PreCompactCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PostCompactHookManifest: {
	input: hooks.#PostCompactCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan: #NoAwarenessPlan & {phase: "PostCompact"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#PostCompactCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#SubagentStartHookManifest: {
	input: hooks.#SubagentStartCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan: #NoAwarenessPlan & {phase: "SubagentStart"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#SubagentStartCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#SubagentStopHookManifest: {
	input: hooks.#SubagentStopCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan: #NoAwarenessPlan & {phase: "SubagentStop"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#SubagentStopCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#StopHookManifest: {
	input: hooks.#StopCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #StopAwarenessPlan
		results: _awarenessResults
		#AwarenessExecution
	}
	output:    hooks.#StopCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}
