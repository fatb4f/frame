package repo

// Validation rules. These are policy constraints over observed state,
// not a planner, scheduler, or agent-loop model.

#RepoConstraints: #RepoState & {
	root: #SafeRoot
	git: {
		clean: bool
	}
	search: #SearchState
}

#RuntimePolicy: {
	mcpEvidenceCapture: {
		enabled: true
		allowlistedTools: [
			"mcp-ripgrep",
			"git-mcp-server",
		]
		persistedContext: "cue-hook-manifests"
	}
	noDynamicTools: true
	noGo:           true
	noWriteTools:   true
	noPatchTools:   true
	noPlannerModel: true
	noAgentLoop:    true
	noPlanLoop:     true
	noPlanDeltaAsCanonical: true
	noUpdatePlanExtension:  true

	runtimeAdapters: ["cuerail-hook", "cuerail-doctor"]
	allowedSkills:   ["cue"]
	allowedTurnItems: ["hookManifest", "turnManifest"]
	maxSearchResults: 200
}

#SkillProjection: {
	keep: [
		"AGENTS.md",
		"skills/cue/SKILL.md",
	]

	removeFromRuntime: [
		"agent-sdk",
		"go-sdk",
		"argc",
		"bash-ast",
		"bashly",
		"bats-core",
		"shell-validation",
		"shellspec",
		"tree-sitter",
		"schema",
		"workflow.cue",
		"source-repo/references",
	]
}
