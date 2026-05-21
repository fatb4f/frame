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
	noMCP:          true
	noGo:           true
	noWriteTools:   true
	noPatchTools:   true
	noPlannerModel: true
	noAgentLoop:    true
	noPlanState:    true

	allowedAdapters: ["repo-rg", "repo-git", "repo-frame"]
	allowedSkills:   ["repo-frame", "cue", "repo-search", "semantic-git"]
	allowedTurnItems: ["userMessage", "agentMessage", "reasoning", "commandExecution", "fileChange", "toolCall", "contextCompaction"]
	maxSearchResults: 200
}

#SkillProjection: {
	keep: [
		"AGENTS.md",
		"skills/repo-frame/SKILL.md",
		"skills/cue/SKILL.md",
		"skills/repo-search/SKILL.md",
		"skills/semantic-git/SKILL.md",
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
