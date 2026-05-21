package repo

#TurnContext: {
	turn: #Turn

	repo: #RepoState

	task: #TaskFrame

	budget: #ContextBudget

	let observedRepo = repo
	let currentTurn = turn
	let currentTask = task

	projection: #ContextFrame
	projection: {
		objective: currentTask.scope | currentTurn.goal
		repo: {
			root:    observedRepo.root
			clean:   observedRepo.git.clean
			branch?: observedRepo.git.branch
			changed: observedRepo.views.dirtyFiles
		}
		activeFiles: [for changedPath in observedRepo.views.dirtyFiles {
			path:   changedPath
			reason: "changed in git status"
		}]
		searchEvidence: observedRepo.search.results
		constraints:    currentTask.constraints
		openQuestions?: currentTask.unknowns
	}

	validation: #ContextValidation
	validation: {
		errors:   *[] | [...string]
		warnings: *[] | [...string]
		passed:   len(errors) == 0
		freshness?: {
			gitHead?: observedRepo.git.head
		}
	}

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
