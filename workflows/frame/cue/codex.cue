package repo

// Codex-facing cuerail runtime surface. The source checkout is an authoring
// location; hook execution uses the global runtime under CODEX_HOME.

#CodexRuntimeEnv: {
	codexHome:  #SafeRoot
	codexState: #SafeRoot

	cuerailHome:  *"\(codexHome)/tools/cuerail" | #SafeRoot
	cuerailState: *"\(codexState)/cuerail" | #SafeRoot
	cuerailTurns: *"\(cuerailState)/turns" | #SafeRoot
}

#CodexToolSurface: {
	codexHome:  #SafeRoot
	codexState: #SafeRoot

	cuerailHome:  *"\(codexHome)/tools/cuerail" | #SafeRoot
	cuerailState: *"\(codexState)/cuerail" | #SafeRoot
	cuerailTurns: *"\(cuerailState)/turns" | #SafeRoot

	let railHome = cuerailHome
	binDir: "\(railHome)/bin"

	required: [
		"cuerail-hook",
		"cuerail-doctor",
		"cue",
		"jq",
		"mktemp",
		"flock",
		"mv",
		"mkdir",
		"chmod",
	]

	officialSchemaSource: "/home/_404/src/fatb4f/tmp/codex-schemas/hooks/schema/generated"

	hookCommand: "\(railHome)/bin/cuerail-hook"
	doctorCommand: "\(railHome)/bin/cuerail-doctor"
}

#CuerailInstallSurface: {
	codexHome:  #SafeRoot
	codexState: #SafeRoot

	cuerailHome:  *"\(codexHome)/tools/cuerail" | #SafeRoot
	cuerailState: *"\(codexState)/cuerail" | #SafeRoot
	cuerailTurns: *"\(cuerailState)/turns" | #SafeRoot

	let home = codexHome
	let state = codexState
	let railHome = cuerailHome
	let railState = cuerailState
	let railTurns = cuerailTurns

	toolsDir: "\(home)/tools"
	homeBin:  "\(home)/bin"
	worktreePath: railHome

	hookCommand:   "\(railHome)/bin/cuerail-hook"
	doctorCommand: "\(railHome)/bin/cuerail-doctor"

	generatedWrappers: [
		"\(homeBin)/cuerail-hook",
		"\(homeBin)/cuerail-doctor",
	]

	generatedHookRegistration: "\(home)/hooks.json"

	installerRequired: [
		"git",
		"mkdir",
		"chmod",
		"ln",
	]

	mutableState: [
		railState,
		railTurns,
	]

	neverTrack: [
		home,
		state,
		"\(home)/auth.json",
		"\(home)/sessions",
		"\(home)/cache",
		"\(home)/plugins",
		"\(home)/models_cache.json",
		"\(home)/version.json",
		railState,
	]
}
