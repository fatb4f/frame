package repo

#TurnContext: {
	turn: #Turn

	repo: #RepoState

	task: #TaskFrame

	budget: #ContextBudget

	projection: #ContextFrame

	validation: #ContextValidation

	eval?: #TurnEval
}

#Turn: {
	id?:       string
	threadId?: string
	cwd:       #SafeRoot
	input: [...#UserInput]
	goal: string
}

#UserInput: {
	role:    "user" | "assistant" | "tool" | "system"
	content: string
	source?: string
}

#TaskFrame: {
	kind: "implement" | "review" | "debug" | "explain" | "commit" | "unknown"

	scope?: string

	constraints: [...string]

	unknowns?: [...string]
}

#ContextBudget: {
	maxFiles?:      int & >0
	maxSearchHits?: int & >0
	maxTokens?:     int & >0
}

#ContextValidation: {
	passed: bool

	errors?: [...string]

	warnings?: [...string]

	freshness?: {
		gitHead?:    string
		observedAt?: string
	}
}

#TurnEval: {
	checksRun: [...#CheckRun]

	validationPassed: bool

	unresolvedRisks?: [...string]

	missingEvidence?: [...string]
}

#CheckRun: {
	command:  string
	exitCode: int
}
