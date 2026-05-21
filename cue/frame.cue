package repo

#ContextFrame: {
	objective: string

	repo: {
		root:    #SafeRoot
		clean:   bool
		branch?: string
		changed: [...string]
	}

	activeFiles: [...#ActiveFile]

	searchEvidence: [...#RgResult]

	constraints: [...string]

	suggestedChecks: [...#SuggestedCheck]

	openQuestions?: [...string]
}

#ActiveFile: {
	path:   string
	reason: string
	risk?:  "low" | "medium" | "high"
}

#SuggestedCheck: {
	command: string
	reason:  string
}
