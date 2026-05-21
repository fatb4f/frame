package repo

// Slim turn vocabulary derived from Codex runtime concepts.
// These contracts name the envelope around repo evidence; they do not model
// the agent loop, planner state, UI state, auth, marketplace, plugins, or MCP.

#TurnView: "agent" | "review" | "commit"

#TurnContext: {
	threadId: string & !=""
	turnId?:  string & !=""

	input: string
	cwd:   #SafeRoot

	model?:          string
	effort?:         string
	approvalPolicy?: string
	sandboxPolicy?:  string

	status?:     "started" | "running" | "completed" | "failed" | "cancelled" | "unknown"
	startedAt?:  string
	completedAt?: string
	durationMs?: int & >=0
	error?: string

	repo: #RepoState
	view: *"agent" | #TurnView

	items: [...#TurnItemSummary]
	diff?: string
	evaluation?: #TurnEvaluation
}

#TurnItemSummary: #UserMessageItem | #AgentMessageItem | #ReasoningItem | #CommandExecutionItem | #FileChangeItem | #ToolCallItem | #ContextCompactionItem

#UserMessageItem: {
	type: "userMessage"
	text?: string
}

#AgentMessageItem: {
	type: "agentMessage"
	text?: string
}

#ReasoningItem: {
	type: "reasoning"
	summary?: string
}

#CommandExecutionItem: {
	type: "commandExecution"
	command: string & !=""
	cwd?: #SafeRoot
	exitCode?: int
	startedAtMs?: int & >=0
	completedAtMs?: int & >=0
	durationMs?: int & >=0
	stdoutPreview?: string
	stderrPreview?: string
}

#FileChangeItem: {
	type: "fileChange"
	path: #RelPath
	kind: "added" | "modified" | "deleted" | "renamed" | "unknown"
	diff?: string
}

#ToolCallItem: {
	type: "toolCall"
	kind: "mcp" | "dynamic" | "collabAgent" | "unknown"
	name?: string
	status?: "started" | "completed" | "failed" | "unknown"
}

#ContextCompactionItem: {
	type: "contextCompaction"
	summary?: string
}

#TurnEvaluation: {
	ok: bool
	checks?: [...#TurnCheck]
	notes?: [...string]
}

#TurnCheck: {
	name: string & !=""
	ok: bool
	detail?: string
}

#ReviewStart: {
	threadId: string & !=""
	cwd: #SafeRoot
	target: #ReviewTarget
}

#ReviewTarget: #ReviewUncommittedChanges | #ReviewBaseBranch | #ReviewCommit | #ReviewCustom

#ReviewUncommittedChanges: {
	mode: "uncommittedChanges"
}

#ReviewBaseBranch: {
	mode: "baseBranch"
	baseBranch: string & !=""
}

#ReviewCommit: {
	mode: "commit"
	commit: string & !=""
}

#ReviewCustom: {
	mode: "custom"
	description: string & !=""
}

#ExecCommandApproval: {
	threadId: string & !=""
	turnId?: string & !=""
	cwd: #SafeRoot
	command: string & !=""
	parsedAction?: string
}

#FileChangeRequestApproval: {
	threadId: string & !=""
	turnId?: string & !=""
	root: #SafeRoot
	path: #RelPath
	kind: "added" | "modified" | "deleted" | "renamed" | "unknown"
}
