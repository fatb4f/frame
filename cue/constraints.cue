package repo

#RepoConstraints: #RepoState & {
	root: #SafeRoot

	git: {
		clean: bool
	}

	search: {
		for _, r in results {
			r.query.root:       #SafeRoot
			r.query.maxResults: <=200
		}
	}
}

#RuntimePolicy: {
	noMCP:          true
	noGo:           true
	noWriteTools:   true
	noPatchTools:   true
	noPlannerModel: true
	allowedSkills: ["cue", "repo-search", "semantic-git"]
}
