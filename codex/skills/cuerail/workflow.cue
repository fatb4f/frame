package cuerail

#PhaseMode: "observe" | "edit" | "validate" | "recover" | "report"

#Phase: {
	id:             string
	tool:           string
	mode:           #PhaseMode
	mutates_source: bool | *false
	after:          string | *""
	blocks_on:      string | *""
	command?:       [...string]
}

workflow: {
	name: "cuerail-runtime-work"
	phases: [...#Phase] & [
		{
			id:             "inspect_with_mcp"
			tool:           "mcp-git-and-ripgrep"
			mode:           "observe"
			mutates_source: false
			blocks_on:      "mcp_unavailable"
		},
		{
			id:             "edit_runtime_or_skill"
			tool:           "codex-editor"
			mode:           "edit"
			mutates_source: true
			after:          "inspect_with_mcp"
			blocks_on:      "authority_boundary_unclear"
		},
		{
			id:             "validate_cue"
			tool:           "cue"
			mode:           "validate"
			after:          "edit_runtime_or_skill"
			command:        ["cue", "vet", "-c=false", "./cue/..."]
			blocks_on:      "cue_vet_failed"
		},
		{
			id:             "validate_shell"
			tool:           "sh"
			mode:           "validate"
			after:          "validate_cue"
			command:        ["sh", "-n", "bin/cuerail-*", "bin/git-mcp-go-cuerail"]
			blocks_on:      "shell_syntax_failed"
		},
		{
			id:             "report"
			tool:           "codex"
			mode:           "report"
			after:          "validate_shell"
		},
	]
	gate: {
		blocks_on: [
			"mcp_unavailable",
			"authority_boundary_unclear",
			"cue_vet_failed",
			"shell_syntax_failed",
		]
	}
}
