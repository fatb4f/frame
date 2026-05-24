package cuerail

#CapturedPostToolUseName: "mcp-ripgrep" | "git-mcp-server"

#CapturePolicy: {
	persist: {
		events: ["UserPromptSubmit", "Stop"]
		postToolUse: [#CapturedPostToolUseName]
	}
}

#CaptureDecision: {
	persist!: bool
	eventSlug?: string
	fileStem?:  string
	toolSlug?:  string
}
