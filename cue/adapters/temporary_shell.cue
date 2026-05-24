package cuerail

#TemporaryShellAdapter: {
	name:        "repo-git" | "repo-rg"
	lifecycle:   "temporary"
	replacement: "git-mcp-server" | "mcp-ripgrep"
	allowedOps: [...string]
}

temporaryShellAdapters: {
	repoGit: #TemporaryShellAdapter & {
		name:        "repo-git"
		replacement: "git-mcp-server"
		allowedOps: [
			"status <repo-root>",
			"diff <repo-root>",
		]
	}

	repoRg: #TemporaryShellAdapter & {
		name:        "repo-rg"
		replacement: "mcp-ripgrep"
		allowedOps: [
			"<query> <repo-root> literal <max-results>",
			"<query> <repo-root> regex <max-results>",
		]
	}
}
