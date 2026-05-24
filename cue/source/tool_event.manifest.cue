package cuerail

tool_event: {
	name: "tool_event"
	plain: "One tool call seen during a hook or fallback path."
	from:  "hook_event"
	next:  "hook_execution"

	kinds: [
		"hook MCP call",
		"ad hoc MCP call",
	]
}
