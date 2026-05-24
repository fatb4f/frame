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

#AwarenessExecution: {
	executable: _awarenessExecutable
	if _awarenessExecutable == false {
		reason: _awarenessExecutionReason
	}
}

#AgentFeedChannel: "stdout.additionalContext" | "stdout.systemMessage" | "continue.reason"

#AgentFeedStatus: "not_attempted" | "emitted" | "unsupported_event" | "invalid_output"

#AgentFeed: {
	enabled!: bool
	channel?: #AgentFeedChannel
	status!:  #AgentFeedStatus
	bytes?:   int & >=0
}

#NoAgentFeed: #AgentFeed & {
	enabled: false
	status:  "not_attempted"
}

#PreToolUseAgentContext: string | *""

#PreToolUseAgentFeed: #AgentFeed & {
	enabled: *false | bool
	status:  *"not_attempted" | #AgentFeedStatus
}

if _hookInput.hook_event_name == "PreToolUse" && len(_awarenessResults) > 0 {
	#PreToolUseAgentContext: "Cuerail observed repo evidence: PreToolUse awareness ran \(_awarenessResults[0].id) via \(_awarenessResults[0].tool). Full evidence persisted under .cuerail/runs/\(_hookInput.session_id)/\(_hookInput.turn_id)/events."

	#PreToolUseAgentFeed: #AgentFeed & {
		enabled: true
		channel: "stdout.additionalContext"
		status:  "emitted"
		bytes:   len(#PreToolUseAgentContext) & <=1000
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
	output: hooks.#SessionStartCommandOutput
	agentFeed: #NoAgentFeed
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
	output: hooks.#UserPromptSubmitCommandOutput
	agentFeed: #NoAgentFeed
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
		if #PreToolUseAgentFeed.status == "emitted" {
			hookSpecificOutput: {
				hookEventName:      "PreToolUse"
				additionalContext: #PreToolUseAgentContext
			}
		}
	}
	agentFeed: #PreToolUseAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PermissionRequestHookManifest: {
	input: hooks.#PermissionRequestCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PermissionRequest"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#PermissionRequestCommandOutput
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
	output: hooks.#PostToolUseCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PreCompactHookManifest: {
	input: hooks.#PreCompactCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PreCompact"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#PreCompactCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#PostCompactHookManifest: {
	input: hooks.#PostCompactCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "PostCompact"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#PostCompactCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#SubagentStartHookManifest: {
	input: hooks.#SubagentStartCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStart"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#SubagentStartCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}

#SubagentStopHookManifest: {
	input: hooks.#SubagentStopCommandInput & _hookInput
	let captureInput = input
	awareness: {
		plan:    #NoAwarenessPlan & {phase: "SubagentStop"}
		results: _awarenessResults
		#AwarenessExecution
	}
	output: hooks.#SubagentStopCommandOutput
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
	output: hooks.#StopCommandOutput
	agentFeed: #NoAgentFeed
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}
