package repo

#Views: {
	root:   #SafeRoot
	git:    #GitState
	search: {
		queries: [...#RgQuery]
		results: [...#RgResult]
	}

	dirtyFiles: [for f in git.changed {f.path}]

	agent: {
		root:       root
		branch?:    git.branch
		clean:      git.clean
		changed:    dirtyFiles
		searchHits: search.results
	}

	review: {
		root:       root
		clean:      git.clean
		changed:    git.changed
		untracked:  git.untracked
		semantic?:  git.semantic
		searchHits: search.results
	}

	commit: {
		clean:     git.clean
		changed:   git.changed
		semantic?: git.semantic
	}

	needsSemantic: *false | bool
}
