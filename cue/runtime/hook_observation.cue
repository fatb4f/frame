package cuerail

#HookPhase: "session_start" | "pre_tool_use" | "post_tool_use" | "stop"
#HookObservationSourceKind: "mcp" | "fallback" | "ad_hoc" | "fixture"
#HookObservationValidity: "green" | "yellow" | "red" | "unknown"
#HookObservationTimestamp: =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"

#HookObservationSource: {
	kind:     #HookObservationSourceKind
	tool:     string
	readOnly: bool
	adapter?: string
	command?: [...string]
}

#ObservationRef: {
	id:     =~"^[A-Za-z0-9._:-]+$"
	phase:  #HookPhase
	source: #HookObservationSource
}

#HookObservation: {
	schema:     "cuerail.hook-observation.v1"
	id:         =~"^[A-Za-z0-9._:-]+$"
	phase:      #HookPhase
	capturedAt: #HookObservationTimestamp
	source:     #HookObservationSource
	repo?: {
		name?: #GitRepoName
		root:  #GitRepoRoot
	}
	query?: _
	command?: [...string]
	raw: _
	...
}

#HookProjectionStatus: {
	captureValidity:    #HookObservationValidity
	projectionValidity: #HookObservationValidity
	sources: [...#HookObservationSource]
	warnings?: [...string]
}

#ExampleHookObservation: #HookObservation & {
	id:         "obs-session-start-git-status"
	phase:      "session_start"
	capturedAt: "2026-05-23T20:00:00Z"
	source: {
		kind:     "fallback"
		tool:     "repo-git"
		readOnly: true
		adapter:  "repo-git"
		command:  ["repo-git", "status", "."]
	}
	repo: {
		name: "cuerail"
		root: "/home/_404/.local/share/codex/tools/cuerail"
	}
	query: {
		op: "git.status"
	}
	raw: {
		clean: true
	}
}
