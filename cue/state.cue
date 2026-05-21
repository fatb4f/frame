package repo

#SafeRoot: string & =~"^/" & !="/"

#RepoState: {
	root: #SafeRoot

	git: #GitState

	search: *{
		queries: []
		results: []
	} | {
		queries: [...#RgQuery]
		results: [...#RgResult]
	}

	files?: {
		relevant: [...string]
		changed: [...string]
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
	path:   string
	status: "added" | "modified" | "deleted" | "renamed" | "unknown"
}

#ChangedEntity: {
	file:   string
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
	path: string
	line: int & >0
	text: string
}

#RgResult: {
	adapter: "rg"
	query:   #RgQuery
	matches: [...#RgMatch]
	truncated: *false | bool
}
