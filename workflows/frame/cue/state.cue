package repo

// One repo-state object. Keep this boring.

#SafeRoot: string & =~"^/" & !="/"
#RelPath:  string & !="" & !~"^/"

#RepoState: {
	root: #SafeRoot

	git: #GitState

	search: #SearchState | *{
		queries: []
		results: []
	}

	files?: {
		relevant: [...string]
		changed: [...string]
	}

	let repoRoot = root
	let repoGit = git
	let repoSearch = search

	views: #Views & {
		root:   repoRoot
		git:    repoGit
		search: repoSearch
	}
}

#GitState: {
	head?:   string
	branch?: string
	clean:   bool

	changed: [...#ChangedFile]
	untracked: [...string]

	diff?: {
		unstaged?: string
		staged?:   string
	}

	semantic?: {
		changedEntities?: [...#ChangedEntity]
		blastRadius?: [...#EntityImpact]
		raw?: string
	}
}

#ChangedFile: {
	path:   #RelPath
	status: "added" | "modified" | "deleted" | "renamed" | "unknown"
}

#ChangedEntity: {
	file:   #RelPath
	kind:   string
	name:   string
	change: "added" | "modified" | "deleted" | "unknown"
}

#EntityImpact: {
	entity: string
	file?:  string
	dependents?: [...string]
	dependencies?: [...string]
	tests?: [...string]
}

#RgQuery: {
	root:       #SafeRoot
	query:      string
	mode:       *"literal" | "regex"
	maxResults: *80 | (int & >0 & <=200)
}

#RgMatch: {
	path: #RelPath
	line: int & >0
	text: string
}

#RgResult: {
	adapter:   "rg"
	query:     #RgQuery
	matches:   [...#RgMatch]
	truncated: *false | bool
}

#SearchState: {
	queries: [...#RgQuery]
	results: [...#RgResult]
}
