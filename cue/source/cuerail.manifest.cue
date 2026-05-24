package cuerail

// Root Cuerail manifest.
//
// Keep this file simple.
// It names what Cuerail is, what it watches, and the small set of
// child manifests that describe each layer.

cuerail: {
	name: "cuerail"

	kind: "hook based agent sidecar"

	for: "codex"

	plain: "Cuerail renders Codex hook activity as simple CUE manifests."

	branches: {
		skill: {
			name:  "cuerail skill"
			plain: "Agent guidance for MCP bound git and rg."
			bound_to: [
				"git MCP",
				"rg MCP",
			]
		}

		hooks: {
			name:  "hook sidecar"
			plain: "Manifest generating hook phase loop."
			bound_to: [
				"Codex hooks",
				"git MCP",
				"rg MCP",
			]
		}

		observation: {
			name:  "observation"
			plain: "Post tool evidence gathering and MCP call origin tracking."
			tracks: [
				"hook MCP calls",
				"ad hoc MCP calls",
			]
		}
	}

	definitions: [
		{
			name: "native_hook_schema"
			file: "cue/source/native_hook_schema.manifest.cue"
		},
		{
			name: "cue_hook_object"
			file: "cue/source/cue_hook_object.manifest.cue"
		},
		{
			name: "hook_event"
			file: "cue/source/hook_event.manifest.cue"
		},
		{
			name: "tool_event"
			file: "cue/source/tool_event.manifest.cue"
		},
		{
			name: "hook_execution"
			file: "cue/source/hook_execution.manifest.cue"
		},
		{
			name: "hook_execution_manifest"
			file: "cue/source/hook_execution_manifest.manifest.cue"
		},
		{
			name: "repo_layout"
			file: "cue/source/repo_layout.manifest.cue"
		},
	]

	flow: [
		"native_hook_schema",
		"cue_hook_object",
		"hook_event",
		"tool_event",
		"hook_execution",
		"hook_execution_manifest",
	]
}
