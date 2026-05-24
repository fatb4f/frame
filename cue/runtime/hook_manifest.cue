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
	output: hooks.#PreToolUseCommandOutput
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
	capture: #CaptureDecisionForInput & {
		_input: captureInput
	}
}
