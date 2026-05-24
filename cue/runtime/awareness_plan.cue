package cuerail

import manifest "github.com/fatb4f/cuerail/cue:cuerail"

#ReadKind: "git" | "rg"

#ReadSubstrate: "mcp"

#ReadTool: "git-mcp-server" | "mcp-ripgrep"

#ReadStatus: "ok" | "error"

_schemaAuthorityRepoRoot: manifest.repos.frame.root

#ReadOp: {
	id!:        string
	phase!:     #CodexHookEvent
	kind!:      #ReadKind
	substrate!: #ReadSubstrate
	tool!:      #ReadTool
	op!:        string
	input!:     _
	readOnly!:  true

	if kind == "git" {
		tool: "git-mcp-server"
	}
	if kind == "rg" {
		tool: "mcp-ripgrep"
	}
}

#ReadResultEnvelope: {
	id!:        string
	substrate!: #ReadSubstrate
	tool!:      #ReadTool
	op!:        string
	input!:     _
	raw?:       _
	rawText?:   string
	error?:     string
	status!:    #ReadStatus
}

#AwarenessPlan: {
	phase!: #CodexHookEvent
	ops!: [...#ReadOp]
}

#NoAwarenessPlan: #AwarenessPlan & {
	ops: []
}

#SessionStartAwarenessPlan: #AwarenessPlan & {
	phase: "SessionStart"
	ops: [{
		id:        "session-start.git.status"
		phase:     "SessionStart"
		kind:      "git"
		substrate: "mcp"
		tool:      "git-mcp-server"
		op:        "git_status"
		input: {
			repo_path: _schemaAuthorityRepoRoot
		}
		readOnly: true
	}]
}

#UserPromptSubmitAwarenessPlan: #AwarenessPlan & {
	phase: "UserPromptSubmit"
	ops: []
}

#PreToolUseAwarenessPlan: #AwarenessPlan & {
	phase: "PreToolUse"
	ops: [{
		id:        "pre-tool-use.rg.tool-policy"
		phase:     "PreToolUse"
		kind:      "rg"
		substrate: "mcp"
		tool:      "mcp-ripgrep"
		op:        "advanced-search"
		input: {
			pattern:      "skills/cuerail/SKILL.md"
			path:         "$CODEX_HOME"
			fixedStrings: true
			maxResults:   20
		}
		readOnly: true
	}]
}

#PostToolUseAwarenessPlan: #AwarenessPlan & {
	phase: "PostToolUse"
	ops: []
}

#StopAwarenessPlan: #AwarenessPlan & {
	phase: "Stop"
	ops: [{
		id:        "stop.git.status"
		phase:     "Stop"
		kind:      "git"
		substrate: "mcp"
		tool:      "git-mcp-server"
		op:        "git_status"
		input: {
			repo_path: _schemaAuthorityRepoRoot
		}
		readOnly: true
	}, {
		id:        "stop.git.diff"
		phase:     "Stop"
		kind:      "git"
		substrate: "mcp"
		tool:      "git-mcp-server"
		op:        "git_diff_unstaged"
		input: {
			repo_path: _schemaAuthorityRepoRoot
		}
		readOnly: true
	}]
}
