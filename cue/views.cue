package repo

// Selectors/projections over #RepoState evidence.

#Views: {
	root: #SafeRoot
	git:  #GitState
	search: {
		queries: [...#RgQuery]
		results: [...#RgResult]
	}

	let repoRoot = root

	dirtyFiles: [
		for f in git.changed {f.path},
		for path in git.untracked {path},
	]

	agent: {
		root:       repoRoot
		branch?:    git.branch
		clean:      git.clean
		changed:    dirtyFiles
		searchHits: search.results
		...
	}

	review: {
		root:       repoRoot
		clean:      git.clean
		changed:    git.changed
		untracked:  git.untracked
		semantic?:  git.semantic
		searchHits: search.results
		...
	}

	commit: {
		clean:     git.clean
		changed:   git.changed
		semantic?: git.semantic
		...
	}

	needsSemantic: *false | bool
}

#AgentView: {
	state: #RepoState
	view:  state.views.agent
}

#ReviewView: {
	state: #RepoState
	view:  state.views.review
}

#CommitView: {
	state: #RepoState
	view:  state.views.commit
}


#TurnAgentView: {
	context: #TurnContext
	threadId?: context.turn.threadId
	turnId?:   context.turn.id
	input:     context.turn.input
	cwd:       context.turn.cwd
	repo:     context.repo.views.agent
	task:     context.task
	frame:    context.projection
	eval?:    context.eval
}

#TurnReviewView: {
	context: #TurnContext
	threadId?: context.turn.threadId
	turnId?:   context.turn.id
	input:     context.turn.input
	cwd:       context.turn.cwd
	repo:     context.repo.views.review
	task:     context.task
	frame:    context.projection
	eval?:    context.eval
}

#TurnCommitView: {
	context: #TurnContext
	threadId?: context.turn.threadId
	turnId?:   context.turn.id
	input:     context.turn.input
	cwd:       context.turn.cwd
	repo:     context.repo.views.commit
	task:     context.task
	frame:    context.projection
	eval?:    context.eval
}
