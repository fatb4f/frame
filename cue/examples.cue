package repo

// Minimal concrete examples proving the observation -> state -> frame contract.

#ExampleRepoState: #RepoState & {
	root: "/tmp/example-repo"
	git: {
		head:   "abc1234"
		branch: "main"
		clean:  false
		changed: [
			{
				path:   "cue/state.cue"
				status: "modified"
			},
		]
		untracked: []
	}
	search: {
		queries: [
			{
				root:       "/tmp/example-repo"
				query:      "#RepoState"
				mode:       "literal"
				maxResults: 80
			},
		]
		results: [
			{
				adapter: "rg"
				query: {
					root:       "/tmp/example-repo"
					query:      "#RepoState"
					mode:       "literal"
					maxResults: 80
				}
				matches: [
					{
						path: "cue/state.cue"
						line: 8
						text: "#RepoState: {"
					},
				]
				truncated: false
			},
		]
	}
}

#ExampleTurnContext: #TurnContext & {
	turn: {
		id:       "turn-example"
		threadId: "thread-example"
		cwd:      "/tmp/example-repo"
		goal:     "Wire observed repo facts into a CUE-unified context frame."
		input: [
			{
				role:    "user"
				content: "wire it"
			},
		]
	}
	repo: #ExampleRepoState
	task: {
		kind:  "implement"
		scope: "Wire observed repo facts into a CUE-unified context frame."
		constraints: [
			"CUE is the authority plane",
			"shell scripts remain adapters",
		]
		unknowns: []
	}
	budget: {
		maxFiles:      8
		maxSearchHits: 80
	}
}

#ExampleContextFrame: #ExampleTurnContext.projection
