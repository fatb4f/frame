package cuerail

#CapturedPostToolUseName: "mcp-ripgrep" | "git-mcp-server"

#CapturePolicy: {
	persist: {
		events: {
			SessionStart:      false
			UserPromptSubmit:  true
			PreToolUse:        false
			PermissionRequest: false
			PostToolUse:       false
			PreCompact:        false
			PostCompact:       false
			SubagentStart:     false
			SubagentStop:      false
			Stop:              true
		}
		plannedAwarenessEvents: ["SessionStart", "PreToolUse", "Stop"]
		postToolUse: {
			"mcp-ripgrep":    true
			"git-mcp-server": true
		}
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
	persist!: bool
	eventSlug?: string
	fileStem?:  string
	toolSlug?:  string
}

#CaptureDecisionForEvent: {
	SessionStart: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.SessionStart
		eventSlug: #CapturePolicy.eventSlugs.SessionStart
		fileStem:  eventSlug
	}
	UserPromptSubmit: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.UserPromptSubmit
		eventSlug: #CapturePolicy.eventSlugs.UserPromptSubmit
		fileStem:  eventSlug
	}
	PreToolUse: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.PreToolUse
		eventSlug: #CapturePolicy.eventSlugs.PreToolUse
		fileStem:  eventSlug
	}
	PermissionRequest: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.PermissionRequest
		eventSlug: #CapturePolicy.eventSlugs.PermissionRequest
		fileStem:  eventSlug
	}
	PostToolUse: #CaptureDecision & {
		eventSlug: #CapturePolicy.eventSlugs.PostToolUse
	}
	PreCompact: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.PreCompact
		eventSlug: #CapturePolicy.eventSlugs.PreCompact
		fileStem:  eventSlug
	}
	PostCompact: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.PostCompact
		eventSlug: #CapturePolicy.eventSlugs.PostCompact
		fileStem:  eventSlug
	}
	SubagentStart: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.SubagentStart
		eventSlug: #CapturePolicy.eventSlugs.SubagentStart
		fileStem:  eventSlug
	}
	SubagentStop: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.SubagentStop
		eventSlug: #CapturePolicy.eventSlugs.SubagentStop
		fileStem:  eventSlug
	}
	Stop: #CaptureDecision & {
		persist:   #CapturePolicy.persist.events.Stop
		eventSlug: #CapturePolicy.eventSlugs.Stop
		fileStem:  eventSlug
	}
}
