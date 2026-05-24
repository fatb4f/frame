package cuerail

import manifest "github.com/fatb4f/cuerail/cue:cuerail"

#GitMCPGoAdapter: {
	mode:        "shell"
	autoApprove: "allow-read-only"
	evidence: {
		cacheRel: "mcp/git-mcp-go/evidence/repos"
		captures: ["status", "diff-unstaged", "diff-staged", "log"]
	}

	repos: [
		for _, r in manifest.repos
		if r.active && r.git.capture {
			name: r.name
			role: r.role
			root: r.root
		},
	]

	repoRoots: [
		for _, r in manifest.repos
		if r.active && r.git.capture {
			r.root
		},
	]
}
