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

	suggestedChecks: *[
		{
			command: "cue vet ./cue"
			reason:  "validate repo context schema"
		},
	] | [...#SuggestedCheck]

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
