package cuerail

#ReviewCheckStatus: "ok" | "failed" | "skipped"
#ReviewTokenUsageStatus: "available" | "unavailable"
#ReviewTokenUsageSource: "explicit" | "auto"

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

	notes: [...string]
}
