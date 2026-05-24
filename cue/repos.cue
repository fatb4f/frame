package cuerail

#RepoRole:     "schema-authority" | "system-config" | "command-surface-generator"
#AbsolutePath: =~"^/.*[^/]$"

#Repo: {
	name:   string
	role:   #RepoRole
	root:   #AbsolutePath
	active: bool | *true
	git: {
		capture: bool | *true
	}
}

repos: {
	[string]: #Repo

	frame: {
		name: "frame"
		role: "schema-authority"
		root: "/home/_404/src/frame"
	}

	dotfiles: {
		name: "dotfiles"
		role: "system-config"
		root: "/home/_404/.local/share/chezmoi"
	}

	bashly: {
		name: "bashly"
		role: "command-surface-generator"
		root: "/home/_404/.local/share/src/bashly.sh"
	}
}
