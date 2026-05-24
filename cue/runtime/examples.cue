package cuerail

#ExamplePostToolUseRipgrepHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PostToolUse"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name: "mcp-ripgrep"
	tool_response: {}
	tool_use_id:     "tool-use-rg-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExamplePostToolUseGitHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PostToolUse"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name: "git-mcp-server"
	tool_response: {}
	tool_use_id:     "tool-use-git-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExampleUncapturedPostToolUseHookInput: {
	cwd:             "/tmp/cuerail-example"
	hook_event_name: "PostToolUse"
	model:           "gpt-4.1"
	permission_mode: "default"
	session_id:      "session-example"
	tool_input: {}
	tool_name: "some-other-tool"
	tool_response: {}
	tool_use_id:     "tool-use-other-example"
	transcript_path: null
	turn_id:         "turn-example"
}

#ExampleSessionStartManifest: #SessionStartHookManifest & {
	input: #ExampleSessionStartHookInput
}

#ExampleUserPromptSubmitManifest: #UserPromptSubmitHookManifest & {
	input: #ExampleUserPromptSubmitHookInput
}

#ExamplePreToolUseManifest: #PreToolUseHookManifest & {
	input: #ExamplePreToolUseHookInput
}

#ExamplePostToolUseRipgrepManifest: #PostToolUseHookManifest & {
	input: #ExamplePostToolUseRipgrepHookInput
}

#ExamplePostToolUseGitManifest: #PostToolUseHookManifest & {
	input: #ExamplePostToolUseGitHookInput
}

#ExampleUncapturedPostToolUseManifest: #PostToolUseHookManifest & {
	input: #ExampleUncapturedPostToolUseHookInput
}

#ExampleStopManifest: #StopHookManifest & {
	input: #ExampleStopHookInput
}

#ExampleTurnTrace: #TurnTrace & {
	session_id: "session-example"
	turn_id:    "turn-example"
	manifests: [
		#ExampleUserPromptSubmitManifest,
		#ExamplePostToolUseRipgrepManifest,
		#ExamplePostToolUseGitManifest,
		#ExampleStopManifest,
	]
}
