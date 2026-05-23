package cuerail

#ExpectedHookSchemaFiles: [
	"session-start.command.input.schema.json",
	"session-start.command.output.schema.json",
	"user-prompt-submit.command.input.schema.json",
	"user-prompt-submit.command.output.schema.json",
	"pre-tool-use.command.input.schema.json",
	"pre-tool-use.command.output.schema.json",
	"permission-request.command.input.schema.json",
	"permission-request.command.output.schema.json",
	"post-tool-use.command.input.schema.json",
	"post-tool-use.command.output.schema.json",
	"pre-compact.command.input.schema.json",
	"pre-compact.command.output.schema.json",
	"post-compact.command.input.schema.json",
	"post-compact.command.output.schema.json",
	"subagent-start.command.input.schema.json",
	"subagent-start.command.output.schema.json",
	"subagent-stop.command.input.schema.json",
	"subagent-stop.command.output.schema.json",
	"stop.command.input.schema.json",
	"stop.command.output.schema.json",
]

#Semver: =~"^[0-9]+\\.[0-9]+\\.[0-9]+$"

#SchemaSync: {
	codexVersion: *"0.133.0" | #Semver @tag(codexVersion)

	candidates: [
		"rust-v\(codexVersion)",
		"v\(codexVersion)",
		"codex-cli-v\(codexVersion)",
		codexVersion,
	]

	selectedRef: "rust-v\(codexVersion)"
}
