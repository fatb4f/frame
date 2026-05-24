package cuerail

#TokenUsageEvidenceSchemaVersion: "cuerail.tokenUsageEvidence.v2"
#TokenUsageEvidenceStatus:        "ok" | "partial" | "unavailable" | "parse_failed"
#TokenUsageEvidenceSourceKind:    "codex-script-log" | "codex-session-artifact" | "chat-paste" | "file" | "unknown"
#TokenUsageEvidenceTimestamp:     =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"

#TokenUsageEvidence: {
	schemaVersion: #TokenUsageEvidenceSchemaVersion

	run: {
		id:       string
		exitCode: int & >=0
		status:   "ok" | "failed"
	}

	source: {
		kind:        #TokenUsageEvidenceSourceKind
		path?:       string
		extractedAt: #TokenUsageEvidenceTimestamp
	}

	git?: {
		commit?: =~"^[0-9a-f]{40}$"
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

	observed?: {
		line: string
	}

	notes: [...string]
}

#ExampleTokenUsageEvidence: #TokenUsageEvidence & {
	schemaVersion: "cuerail.tokenUsageEvidence.v2"
	run: {
		id:       "20260524T000000Z"
		exitCode: 0
		status:   "ok"
	}
	source: {
		kind:        "codex-script-log"
		path:        ".cuerail/runs/20260524T000000Z/codex.log"
		extractedAt: "2026-05-24T00:00:00Z"
	}
	git: {
		commit: "0123456789abcdef0123456789abcdef01234567"
	}
	status: "ok"
	usage: {
		total:     101019
		input:     95648
		cached:    482304
		output:    5371
		reasoning: 1620
	}
	observed: {
		line: "Token usage: total=101,019 input=95,648 (+ 482,304 cached) output=5,371 (reasoning 1,620)"
	}
	degraded: false
	notes: []
}
