package repo

#RepoConstraints: #RepoState & {
	root: #SafeRoot

	git: {
		clean: bool
	}

	search: {
		queries: [...#RgQuery]
		results: [...#RgResult]
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
