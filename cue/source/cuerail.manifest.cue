package cuerail

// Root Cuerail manifest.
//
// Keep this file simple. It names what Cuerail is, what it watches, and the
// small set of child manifests that describe each layer.

cuerail: {
	name: "cuerail"
	kind: "hook based agent sidecar"
	for:  "codex"

	branches: {
		skill: {
			name: "cuerail skill"
			role: "agent recovery guidance"
			bound_to: [
				"git MCP",
				"rg MCP",
			]
			not: [
				"shell git",
				"shell rg",
				"workflow brain",
			]
		}

		hooks: {
			name: "hook sidecar"
			role: "manifest generating hook phase loop"
			bound_to: [
				"Codex hooks",
				"git MCP",
				"rg MCP",
			]
			not: [
				"agent planning",
				"review framework",
			]
		}

		observation: {
			name: "observation"
			role: "separate hook-collected evidence from ad hoc MCP evidence"
			tracks: [
				"which MCP calls came from hooks",
				"which MCP calls came from agent fallback",
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
