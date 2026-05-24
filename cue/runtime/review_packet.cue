package cuerail

#ReviewCheckStatus: "ok" | "failed" | "skipped"
#ReviewTokenUsageStatus: "available" | "unavailable"
#ReviewTokenUsageSource: "explicit" | "auto"
#ReviewEvidenceState: "green" | "yellow" | "red"

#ReviewEvidenceSurface: {
	state: #ReviewEvidenceState
	files: [...{
		kind:      string
		path:      string
		cacheRel:  string
		adapter:   string
		readiness: #ReviewEvidenceState & ("green" | "yellow")
	}]
}

#ReviewPacket: {
	commit:  =~"^[0-9a-f]{40}$"
	parent:  null | =~"^[0-9a-f]{40}$"
	subject: string

	changedFiles: [...string]
	lineStats: [...{
		path:    string
		added:   null | int
		deleted: null | int
	}]

	touched: {
		bin:      bool
		cue:      bool
		cache:    bool
		hooks:    bool
		schemas:  bool
		adapters: bool
	}

	checks: {
		sourceDoctor:  #ReviewCheckStatus
		cueVet:        #ReviewCheckStatus
		schemaSync:    #ReviewCheckStatus
		runtimeDoctor: #ReviewCheckStatus
	}

	tokenUsage: {
		available: bool
		status:    #ReviewTokenUsageStatus
		path:      null | string
		source:    null | #ReviewTokenUsageSource
	}

	readSources: {
		git: #ReviewEvidenceSurface
		rg:  #ReviewEvidenceSurface
	}

	hookFrames: {
		sessionStart: #SessionStartHookFrame
		preToolUse:   #PreToolUseHookFrame
		postToolUse:  #PostToolUseHookFrame
		stop:         #StopHookFrame
	}

	notes: [...string]
}
