package cuerail

#GitRepoName:             =~"^[A-Za-z0-9._-]+$"
#GitRepoRoot:             =~"^/.*[^/]$"
#GitObjectID:             =~"^[0-9a-f]{7,64}$"
#GitCaptureTimestamp:     =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
#GitRepoCaptureKind:      "status" | "diff-unstaged" | "diff-staged" | "log"
#GitRepoDiffCaptureKind:  "diff-unstaged" | "diff-staged"
#GitRepoDiffScope:        "unstaged" | "staged"
#GitRepoCaptureAdapter:   "git-mcp-go" | "repo-git"
#GitRepoCaptureReadiness: "green" | "yellow"

#GitRepoCaptureBase: {
	schema:     "cuerail.git-mcp-go.capture.v1"
	adapter:    #GitRepoCaptureAdapter
	readiness:  #GitRepoCaptureReadiness
	kind:       #GitRepoCaptureKind
	capturedAt: #GitCaptureTimestamp
	repo: {
		name: #GitRepoName
		root: #GitRepoRoot
	}
	source: {
		tool:        adapter
		mode:        "shell"
		autoApprove: "allow-read-only" | null
	}
	evidence: {
		cacheRel: "mcp/git-mcp-go/evidence/repos/\(repo.name)/\(kind).json"
	}
	...
}

#GitRepoMCPCapture: #GitRepoCaptureBase & {
	adapter:   "git-mcp-go"
	readiness: "green"
	source: {
		tool:        "git-mcp-go"
		autoApprove: "allow-read-only"
	}
}

#GitRepoFallbackCapture: #GitRepoCaptureBase & {
	adapter:   "repo-git"
	readiness: "yellow"
	source: {
		tool:        "repo-git"
		autoApprove: null
	}
}

#GitRepoCapture: (#GitRepoMCPCapture | #GitRepoFallbackCapture) & (#GitRepoStatusCapture | #GitRepoDiffCapture | #GitRepoLogCapture)

#GitRepoStatusCapture: #GitRepoCaptureBase & {
	kind: "status"
	payload: {
		head:   #GitObjectID
		branch: string
		clean:  bool
		changed: [...string]
		untracked: [...string]
	}
}

#GitRepoDiffCapture: #GitRepoCaptureBase & {
	kind: #GitRepoDiffCaptureKind & "diff-\(payload.scope)"
	payload: {
		scope: #GitRepoDiffScope
		patch: string
		stat: {
			files:      int & >=0
			insertions: int & >=0
			deletions:  int & >=0
		}
		paths: [...string]
	}
}

#GitRepoLogCapture: #GitRepoCaptureBase & {
	kind: "log"
	payload: {
		commits: [...{
			commit: #GitObjectID
			parents: [...#GitObjectID]
			author:  string
			date:    #GitCaptureTimestamp
			subject: string
		}]
	}
}

#ExampleGitRepoStatusCapture: #GitRepoMCPCapture & #GitRepoStatusCapture & {
	adapter:    "git-mcp-go"
	readiness:  "green"
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	payload: {
		head:   "8568c54"
		branch: "main"
		clean:  true
		changed: []
		untracked: []
	}
}

#ExampleGitRepoUnstagedDiffCapture: #GitRepoMCPCapture & #GitRepoDiffCapture & {
	adapter:    "git-mcp-go"
	readiness:  "green"
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	payload: {
		scope: "unstaged"
		patch: ""
		stat: {
			files:      0
			insertions: 0
			deletions:  0
		}
		paths: []
	}
}

#ExampleGitRepoStagedDiffCapture: #GitRepoMCPCapture & #GitRepoDiffCapture & {
	adapter:    "git-mcp-go"
	readiness:  "green"
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	payload: {
		scope: "staged"
		patch: ""
		stat: {
			files:      0
			insertions: 0
			deletions:  0
		}
		paths: []
	}
}

#ExampleGitRepoLogCapture: #GitRepoMCPCapture & #GitRepoLogCapture & {
	adapter:    "git-mcp-go"
	readiness:  "green"
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	payload: {
		commits: [{
			commit: "8568c54"
			parents: ["e0b3de6"]
			author:  "Cuerail"
			date:    "2026-05-23T19:59:00Z"
			subject: "chore: define git capture evidence"
		}]
	}
}
