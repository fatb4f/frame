package cuerail

#ConfigSchemaSync: {
	schemaUrl: "https://developers.openai.com/codex/config-schema.json"
}

#ConfigSchemaLock: {
	provider:        "developers.openai.com"
	schemaPath:      "/codex/config-schema.json"
	schemaKind:      "codex-config"
	codexCliVersion: #Semver
	schemaUrl:       #ConfigSchemaSync.schemaUrl

	files: [{
		path:   "config-schema.json"
		sha256: =~"^[0-9a-f]{64}$"
		bytes:  int & >=0
	}]
}

#ExampleConfigSchemaLock: #ConfigSchemaLock & {
	provider:        "developers.openai.com"
	schemaPath:      "/codex/config-schema.json"
	schemaKind:      "codex-config"
	codexCliVersion: "0.133.0"
	schemaUrl:       "https://developers.openai.com/codex/config-schema.json"
	files: [{
		path:   "config-schema.json"
		sha256: "0000000000000000000000000000000000000000000000000000000000000000"
		bytes:  1
	}]
}
