package repo

// Selectors/projections over #RepoState evidence.

#Views: {
	root:   #SafeRoot
	git:    #GitState
	search: #SearchState

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
	context: #TurnContext & {view: "agent"}
	threadId: context.threadId
	turnId?:  context.turnId
	input:    context.input
	cwd:      context.cwd
	repo:     context.repo.views.agent
	items:    context.items
	diff?:    context.diff
	evaluation?: context.evaluation
}

#TurnReviewView: {
	context: #TurnContext & {view: "review"}
	threadId: context.threadId
	turnId?:  context.turnId
	input:    context.input
	cwd:      context.cwd
	repo:     context.repo.views.review
	items:    context.items
	diff?:    context.diff
	evaluation?: context.evaluation
}

#TurnCommitView: {
	context: #TurnContext & {view: "commit"}
	threadId: context.threadId
	turnId?:  context.turnId
	input:    context.input
	cwd:      context.cwd
	repo:     context.repo.views.commit
	items:    context.items
	diff?:    context.diff
	evaluation?: context.evaluation
}
