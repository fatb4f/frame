package cuerail

#ExampleSessionStartHook: #SessionStartHookManifest & {
	_hookInput: #ExampleSessionStartHookInput
}

#ExampleSessionStartHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "SessionStart"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	source:          "startup"
	transcript_path: null
}

#ExampleSessionStartHookOutput: #ExampleSessionStartHook.output

#ExampleUserPromptSubmitHook: #UserPromptSubmitHookManifest & {
	_hookInput: #ExampleUserPromptSubmitHookInput
}

#ExampleUserPromptSubmitHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "UserPromptSubmit"
	model:           "gpt-4.1"
	permission_mode: "default"
	prompt:          "show me the hook output"
	session_id:      "session-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExampleUserPromptSubmitHookOutput: #ExampleUserPromptSubmitHook.output

#ExamplePreToolUseHook: #PreToolUseHookManifest & {
	_hookInput: #ExamplePreToolUseHookInput
}

#ExamplePreToolUseHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PreToolUse"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name:       "mcp-ripgrep"
	tool_use_id:     "tool-use-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExamplePreToolUseHookOutput: #ExamplePreToolUseHook.output

#ExamplePermissionRequestHook: #PermissionRequestHookManifest & {
	_hookInput: #ExamplePermissionRequestHookInput
}

#ExamplePermissionRequestHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PermissionRequest"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name:       "mcp-ripgrep"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExamplePermissionRequestHookOutput: #ExamplePermissionRequestHook.output

#ExamplePostToolUseHook: #PostToolUseHookManifest & {
	_hookInput: #ExamplePostToolUseHookInput
}

#ExamplePostToolUseHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PostToolUse"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name: "mcp-ripgrep"
	tool_response: {}
	tool_use_id:     "tool-use-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExamplePostToolUseHookOutput: #ExamplePostToolUseHook.output

#ExamplePreCompactHook: #PreCompactHookManifest & {
	_hookInput: #ExamplePreCompactHookInput
}

#ExamplePreCompactHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PreCompact"
	model:           "gpt-4.1"
	session_id:      "session-example"
	transcript_path: null
	trigger:         "manual"
	turn_id:         "turn-example"
}

#ExamplePreCompactHookOutput: #ExamplePreCompactHook.output

#ExamplePostCompactHook: #PostCompactHookManifest & {
	_hookInput: #ExamplePostCompactHookInput
}

#ExamplePostCompactHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PostCompact"
	model:           "gpt-4.1"
	session_id:      "session-example"
	transcript_path: null
	trigger:         "manual"
	turn_id:         "turn-example"
}

#ExamplePostCompactHookOutput: #ExamplePostCompactHook.output

#ExampleSubagentStartHook: #SubagentStartHookManifest & {
	_hookInput: #ExampleSubagentStartHookInput
}

#ExampleSubagentStartHookInput: {
	agent_id:        "agent-example"
	agent_type:      "analysis"
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "SubagentStart"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExampleSubagentStartHookOutput: #ExampleSubagentStartHook.output

#ExampleSubagentStopHook: #SubagentStopHookManifest & {
	_hookInput: #ExampleSubagentStopHookInput
}

#ExampleSubagentStopHookInput: {
	agent_id:               "agent-example"
	agent_transcript_path:  null
	agent_type:             "analysis"
	cwd:                    "/tmp/cuerail-example"
	hook_event_name:        "SubagentStop"
	last_assistant_message: null
	model:                  "gpt-4.1"
	permission_mode:        "default"
	session_id:             "session-example"
	stop_hook_active:       false
	transcript_path:        null
	turn_id:                "turn-example"
}

#ExampleSubagentStopHookOutput: #ExampleSubagentStopHook.output

#ExampleStopHook: #StopHookManifest & {
	_hookInput: #ExampleStopHookInput
}

#ExampleStopHookInput: {
	cwd:                    "/tmp/cuerail-example"
	hook_event_name:        "Stop"
	last_assistant_message: null
	model:                  "gpt-4.1"
	permission_mode:        "default"
	session_id:             "session-example"
	stop_hook_active:       true
	transcript_path:        null
	turn_id:                "turn-example"
}

#ExampleStopHookOutput: #ExampleStopHook.output
