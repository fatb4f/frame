package repo

// Codex-facing command surface. Wrappers in codexHome/bin are the stable
// contract; venvs and source repositories are implementation details.

#CodexToolSurface: {
	codexHome: #SafeRoot
	binDir:    "\(codexHome)/bin"

	required: [
		"repo-frame",
		"repo-git",
		"repo-rg",
		"cue",
		"rg",
		"git",
	]

	optional: [
		"sem",
		"plan-vet",
		"evidence-vet",
		"codex-frame-doctor",
	]

	pathPrepend: [...#SafeRoot]
	pathPrepend: [binDir, ...]
}

