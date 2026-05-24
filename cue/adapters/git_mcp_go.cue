package cuerail

import manifest "github.com/fatb4f/cuerail/cue:cuerail"

#GitRepoCaptureKind: "status" | "diff-unstaged" | "diff-staged" | "log"
#GitMCPGoCaptureKinds: [
	"status" & #GitRepoCaptureKind,
	"diff-unstaged" & #GitRepoCaptureKind,
	"diff-staged" & #GitRepoCaptureKind,
	"log" & #GitRepoCaptureKind,
]

#GitMCPGoAdapter: {
	mode:        "shell"
	autoApprove: "allow-read-only"
	evidence: {
		cacheRel: "mcp/git-mcp-go/evidence/repos"
		captures: #GitMCPGoCaptureKinds
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

#ExpectedGitMCPGoEvidenceFixtures: [
	for _, r in #GitMCPGoAdapter.repos
	for _, captureKind in #GitMCPGoCaptureKinds {
		repo:     r.name
		kind:     captureKind
		path:     "test/fixtures/mcp/git-mcp-go/evidence/repos/\(r.name)/\(captureKind).json"
		cacheRel: "mcp/git-mcp-go/evidence/repos/\(r.name)/\(captureKind).json"
	},
]
