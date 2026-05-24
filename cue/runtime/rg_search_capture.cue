package cuerail

#RgSearchMode:        "literal" | "regex"
#RgCaptureAdapter:    "mcp-ripgrep" | "repo-rg"
#RgCaptureReadiness:  "green" | "yellow"
#RgCaptureTimestamp:  =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
#RgSearchStableName:  =~"^[A-Za-z0-9._-]+$"
#RgSearchResultPath:  !~"^/" & string
#RgSearchResultLine:  int & >=1
#RgSearchResultText:  string

#RgSearchCaptureBase: {
	schema:     "cuerail.mcp-ripgrep.search.v1"
	adapter:    #RgCaptureAdapter
	readiness:  #RgCaptureReadiness
	kind:       "search"
	capturedAt: #RgCaptureTimestamp
	repo: {
		name: #GitRepoName
		root: #GitRepoRoot
	}
	query: {
		pattern:    string
		mode:       #RgSearchMode
		path:       string
		maxResults: int & >0 & <=200
		stableName: #RgSearchStableName
	}
	source: {
		tool: adapter
		mode: "mcp" | "shell"
	}
	evidence: {
		cacheRel: "mcp/mcp-ripgrep/evidence/search/\(query.stableName).json"
	}
	results: [...{
		path: #RgSearchResultPath
		line?: #RgSearchResultLine
		text: #RgSearchResultText
	}]
	truncated: bool
	...
}

#RgSearchMCPCapture: #RgSearchCaptureBase & {
	adapter:   "mcp-ripgrep"
	readiness: "green"
	source: {
		tool: "mcp-ripgrep"
		mode: "mcp"
	}
}

#RgSearchFallbackCapture: #RgSearchCaptureBase & {
	adapter:   "repo-rg"
	readiness: "yellow"
	source: {
		tool: "repo-rg"
		mode: "shell"
	}
}

#RgSearchCapture: #RgSearchMCPCapture | #RgSearchFallbackCapture

#ExampleRgSearchCapture: #RgSearchMCPCapture & {
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	query: {
		pattern:    "#GitRepoCapture"
		mode:       "literal"
		path:       "."
		maxResults: 5
		stableName: "frame-git-repo-capture"
	}
	results: [{
		path: "cue/runtime/git_repo_capture.cue"
		line: 11
		text: "#GitRepoCaptureBase: {"
	}]
	truncated: false
}

#ExampleRgSearchFallbackCapture: #RgSearchFallbackCapture & {
	capturedAt: "2026-05-23T20:00:00Z"
	repo: {
		name: "frame"
		root: "/home/_404/src/frame"
	}
	query: {
		pattern:    "repo-rg"
		mode:       "literal"
		path:       "."
		maxResults: 5
		stableName: "frame-repo-rg"
	}
	results: [{
		path: "bin/repo-rg"
		line: 6
		text: "usage: repo-rg QUERY [ROOT] [MODE] [MAX_RESULTS]"
	}]
	truncated: false
}
