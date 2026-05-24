package cuerail

hook_execution: {
	name: "hook_execution"
	plain: "A hook event plus the tool events that happened with it."
	from:  "tool_event"
	next:  "hook_execution_manifest"
}
