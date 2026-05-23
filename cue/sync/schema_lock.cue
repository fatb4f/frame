package cuerail

#SchemaLock: {
	provider:        "github.com/openai/codex"
	schemaPath:      "codex-rs/hooks/schema/generated"
	schemaKind:      "hooks-command"
	codexCliVersion: #Semver
	providerRef:     string

	files: [...{
		path:   string
		sha256: =~"^[0-9a-f]{64}$"
		bytes:  int & >=0
	}]
}

#ExampleSchemaLock: #SchemaLock & {
	provider:        "github.com/openai/codex"
	schemaPath:      "codex-rs/hooks/schema/generated"
	schemaKind:      "hooks-command"
	codexCliVersion: "0.133.0"
	providerRef:     "rust-v0.133.0"
	files: [{
		path:   "session-start.command.input.schema.json"
		sha256: "0000000000000000000000000000000000000000000000000000000000000000"
		bytes:  1
	}]
}
