package cuerail

#TokenUsageEvidenceSchemaVersion: "cuerail.tokenUsageEvidence.v1"
#TokenUsageEvidenceSourceKind:    "codex-session-artifact" | "chat-paste" | "file" | "unknown"
#TokenUsageEvidenceStatus:        "ok" | "partial" | "unavailable" | "parse_failed"
#TokenUsageEvidenceTimestamp:     =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"

#TokenUsageEvidence: {
	schemaVersion: #TokenUsageEvidenceSchemaVersion

	source: {
		kind:        #TokenUsageEvidenceSourceKind
		path?:       string
		commit?:     string
		extractedAt: #TokenUsageEvidenceTimestamp
	}

	status:   #TokenUsageEvidenceStatus
	degraded: bool

	usage?: {
		total?:     int & >=0
		input?:     int & >=0
		cached?:    int & >=0
		output?:    int & >=0
		reasoning?: int & >=0
	}

	notes?: [...string]
}

#ExampleTokenUsageEvidence: #TokenUsageEvidence & {
	schemaVersion: "cuerail.tokenUsageEvidence.v1"
	source: {
		kind:        "chat-paste"
		extractedAt: "2026-05-23T00:00:00Z"
	}
	status: "ok"
	usage: {
		total:     101019
		input:     95648
		cached:    482304
		output:    5371
		reasoning: 1620
	}
	degraded: false
	notes:    []
}
