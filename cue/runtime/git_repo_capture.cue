package cuerail

#GitRepoName:            =~"^[A-Za-z0-9._-]+$"
#GitRepoRoot:            =~"^/.*[^/]$"
#GitObjectID:            =~"^[0-9a-f]{7,64}$"
#GitCaptureTimestamp:    =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
#GitRepoCaptureKind:     "status" | "diff-unstaged" | "diff-staged" | "log"
#GitRepoDiffCaptureKind: "diff-unstaged" | "diff-staged"
#GitRepoDiffScope:       "unstaged" | "staged"

#GitRepoCaptureBase: {
	schema:     "cuerail.git-mcp-go.capture.v1"
	adapter:    "git-mcp-go"
	kind:       #GitRepoCaptureKind
	capturedAt: #GitCaptureTimestamp
	repo: {
		name: #GitRepoName
		root: #GitRepoRoot
	}
	source: {
		tool:        "git-mcp-go"
		mode:        "shell"
		autoApprove: "allow-read-only"
	}
	evidence: {
		cacheRel: "mcp/git-mcp-go/evidence/repos/\(repo.name)/\(kind).json"
	}
	...
}

#GitRepoCapture: #GitRepoStatusCapture | #GitRepoDiffCapture | #GitRepoLogCapture

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

#ExampleGitRepoStatusCapture: #GitRepoStatusCapture & {
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

#ExampleGitRepoUnstagedDiffCapture: #GitRepoDiffCapture & {
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

#ExampleGitRepoStagedDiffCapture: #GitRepoDiffCapture & {
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

#ExampleGitRepoLogCapture: #GitRepoLogCapture & {
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
