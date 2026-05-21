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
		relevant: [...#RelPath]
		changed:  [...#RelPath]
	}

	views: #Views & {
		root:   root
		git:    git
		search: search
	}
}

#GitState: {
	head?:   string
	branch?: string
	clean:  bool

	changed:   [...#ChangedFile]
	untracked: [...#RelPath]

	semantic?: {
		changedEntities?: [...#ChangedEntity]
		blastRadius?:     [...#EntityImpact]
		raw?:             string
	}

	diff?: {
		unstaged?: string
		staged?:   string
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
	entity:        string
	file?:         #RelPath
	dependents?:   [...#RelPath]
	dependencies?: [...#RelPath]
	tests?:        [...#RelPath]
}

#SearchState: {
	queries: [...#RgQuery]
	results: [...#RgResult]
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
