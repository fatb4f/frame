package agents

#Command: {
	name?:     string
	run:       string
	purpose:   string
	when?:     string
	fallback?: bool
}

#Surface: {
	id:     string
	status: "active" | "preferred" | "fallback" | "target" | "legacy" | "forbidden"
	paths?: [...string]
	commands?: [...string]
	purpose:      string
	replacement?: string
	notes?: [...string]
}

#Constraint: {
	id:       string
	title:    string
	severity: "required" | "recommended" | "forbidden"
	appliesTo: [...string]
	statement:  string
	rationale?: string
}

#AuthorityBoundary: {
	owner: "cue" | "shell" | "markdown" | "external" | "generated"
	owns: [...string]
	mustNotOwn?: [...string]
}

#ObservationPolicy: {
	priority: [...string]
	mcp: {
		preferred: bool
		servers: [...string]
		preserveRawJSON:               bool
		mustNotNormalizeBeforeCapture: bool
		visibilityChecks: [...#Command]
	}
	fallbackAdapters: {
		useOnlyWhen: [...string]
		commands: [...string]
	}
	directShell: {
		useOnlyWhen: [...string]
	}
	constraints: [...#Constraint]
}

#ValidationContract: {
	commands: [...#Command]
	constraints: [...#Constraint]
}

#AgentContract: {
	id:      string
	purpose: string

	surfaces: {
		active: [...#Surface]
		preferred: [...#Surface]
		fallback: [...#Surface]
		legacy: [...#Surface]
	}

	adapterFactSources: {
		lifecycleAuthority: string
		projectedBy:        string
		agentsMayProject: [...string]
		agentsMustNotDuplicate: [...string]
	}

	authorityBoundaries: [...#AuthorityBoundary]
	observation: #ObservationPolicy

	turnStart: {
		commands: [...#Command]
		constraints: [...#Constraint]
	}

	hookManifest: {
		authority: "cue"
		surfaces: [...string]
		persistedEvents: [...string]
		constraints: [...#Constraint]
	}

	validation: #ValidationContract

	planGate: {
		nativePlanOwns: [...string]
		sidecarOwns: [...string]
		constraints: [...#Constraint]
	}

	skillRouting: {
		preferred: [...#Surface]
		forbidden: [...#Surface]
		constraints: [...#Constraint]
	}

	boundaries: {
		constraints: [...#Constraint]
	}

	pruning: {
		constraints: [...#Constraint]
	}
}
