package cuerail

#HookRepoFrame: {
	root:    #GitRepoRoot
	name?:   #GitRepoName
	branch?: string
	head?:   #GitObjectID
	dirty:   bool
}

#SessionStartHookFrame: {
	schema: "cuerail.hook.session-start.v1"
	phase:  "session_start"
	repo:   #HookRepoFrame
	context: {
		relevantFiles: [...string]
		recentChanges?: _
		activeSchemas?: [...string]
	}
	provenance: [...#ObservationRef]
	diagnostics?: [...string]
	status: #HookProjectionStatus
}

#PreToolUseHookFrame: {
	schema: "cuerail.hook.pre-tool-use.v1"
	phase:  "pre_tool_use"
	repo?:  #HookRepoFrame
	tool: {
		name: string
		input?: _
	}
	risk: {
		class: "read" | "write" | "execute" | "unknown"
		touchedPaths: [...string]
		policySnippets?: [...string]
	}
	provenance: [...#ObservationRef]
	diagnostics?: [...string]
	status: #HookProjectionStatus
}

#PostToolUseHookFrame: {
	schema: "cuerail.hook.post-tool-use.v1"
	phase:  "post_tool_use"
	repo?:  #HookRepoFrame
	tool: {
		name: string
		result?: _
	}
	delta: {
		changedPaths: [...string]
		diffSummary?: _
		generatedArtifacts?: [...string]
		newEvidence?: [...string]
	}
	provenance: [...#ObservationRef]
	diagnostics?: [...string]
	status: #HookProjectionStatus
}

#StopHookFrame: {
	schema: "cuerail.hook.stop.v1"
	phase:  "stop"
	repo:   #HookRepoFrame
	summary: {
		unresolvedChanges: [...string]
		generatedArtifacts: [...string]
		validationResults?: [...{
			name:   string
			status: "green" | "yellow" | "red" | "unknown"
		}]
	}
	provenance: [...#ObservationRef]
	diagnostics?: [...string]
	status: #HookProjectionStatus
}

#ExampleSessionStartHookFrame: #SessionStartHookFrame & {
	repo: {
		root:   "/home/_404/.local/share/codex/tools/cuerail"
		name:   "cuerail"
		branch: "main"
		head:   "4da143f"
		dirty:  false
	}
	context: {
		relevantFiles: ["cue/runtime/hook_manifest.cue", "bin/cuerail-hook"]
		activeSchemas: ["#HookManifest"]
	}
	provenance: [{
		id:    "obs-session-start-git-status"
		phase: "session_start"
		source: {
			kind:     "fallback"
			tool:     "repo-git"
			readOnly: true
			adapter:  "repo-git"
		}
	}]
	status: {
		captureValidity:    "green"
		projectionValidity: "green"
		sources: [{
			kind:     "fallback"
			tool:     "repo-git"
			readOnly: true
			adapter:  "repo-git"
		}]
	}
}

#ExamplePreToolUseHookFrame: #PreToolUseHookFrame & {
	repo: {
		root:  "/home/_404/.local/share/codex/tools/cuerail"
		name:  "cuerail"
		dirty: false
	}
	tool: {
		name: "exec_command"
		input: {
			cmd: "repo-rg hook . literal 80"
		}
	}
	risk: {
		class: "read"
		touchedPaths: []
		policySnippets: ["bounded repository search"]
	}
	provenance: []
	status: {
		captureValidity:    "green"
		projectionValidity: "green"
		sources: []
	}
}

#ExamplePostToolUseHookFrame: #PostToolUseHookFrame & {
	repo: {
		root:  "/home/_404/.local/share/codex/tools/cuerail"
		name:  "cuerail"
		dirty: true
	}
	tool: {
		name: "apply_patch"
		result: {
			status: "success"
		}
	}
	delta: {
		changedPaths: ["cue/runtime/hooks.cue"]
		generatedArtifacts: []
		newEvidence: []
	}
	provenance: []
	status: {
		captureValidity:    "green"
		projectionValidity: "green"
		sources: []
	}
}

#ExampleStopHookFrame: #StopHookFrame & {
	repo: {
		root:   "/home/_404/.local/share/codex/tools/cuerail"
		name:   "cuerail"
		branch: "main"
		head:   "4da143f"
		dirty:  true
	}
	summary: {
		unresolvedChanges: ["cue/runtime/hooks.cue"]
		generatedArtifacts: []
		validationResults: [{
			name:   "cuerail-doctor"
			status: "unknown"
		}]
	}
	provenance: []
	status: {
		captureValidity:    "green"
		projectionValidity: "green"
		sources: []
	}
}
