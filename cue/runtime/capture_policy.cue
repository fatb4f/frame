package cuerail

#CapturePolicy: {
	persist: {
		events: {
			SessionStart:      true
			UserPromptSubmit:  true
			PreToolUse:        true
			PermissionRequest: false
			PostToolUse:       true
			PreCompact:        false
			PostCompact:       false
			SubagentStart:     false
			SubagentStop:      false
			Stop:              true
		}
		plannedAwarenessEvents: ["SessionStart", "PreToolUse", "Stop"]
	}
	eventSlugs: {
		SessionStart:      "session-start"
		UserPromptSubmit:  "user-prompt-submit"
		PreToolUse:        "pre-tool-use"
		PermissionRequest: "permission-request"
		PostToolUse:       "post-tool-use"
		PreCompact:        "pre-compact"
		PostCompact:       "post-compact"
		SubagentStart:     "subagent-start"
		SubagentStop:      "subagent-stop"
		Stop:              "stop"
	}
}

#CaptureDecision: {
	persist!:   bool
	eventSlug?: string
	fileStem?:  string
	toolSlug?:  string
}

#CaptureDecisionForInput: #CaptureDecision & {
	_input!: {
		hook_event_name!: #CodexHookEvent
		if hook_event_name == "PostToolUse" {
			tool_name!: string
		}
		...
	}

	_eventName: _input.hook_event_name
	_eventPolicy: #CapturePolicy.persist.events & {
		(_eventName): *false | bool
	}

	eventSlug: #CapturePolicy.eventSlugs[_eventName]

	if _eventName != "PostToolUse" {
		persist:  _eventPolicy[_eventName]
		fileStem: eventSlug
	}

	if _eventName == "PostToolUse" {
		_toolName: _input.tool_name
		persist:   true
		toolSlug:  _toolName
		fileStem:  "\(eventSlug).\(toolSlug)"
	}
}
