package cuerail

#MCPStdioServer: {
	name: string
	commandProjection?: {
		rootEnv: string
		rel:     string
	}
	runtime?: {
		rootEnv: string
		rel:     string
		binRel:  string
		marker:  string
	}
	args?: [...string]
	env_vars?: [...string]
	...
}

#MCPRipgrepAdapter: #MCPStdioServer & {
	name:      "ripgrep"
	package:   "mcp-ripgrep"
	version:   "0.4.0"
	transport: "stdio"
	commandProjection: {
		rootEnv: "CODEX_HOME"
		rel:     "bin/cuerail-mcp-ripgrep"
	}
	runtime: {
		rootEnv: "CODEX_STATE"
		rel:     "cuerail/mcp/mcp-ripgrep"
		binRel:  "node_modules/.bin/mcp-ripgrep"
		marker:  ".cuerail-adapter.json"
	}
	args: []
	env_vars: ["PATH", "CODEX_STATE"]

	requires: {
		nodeMajorMin: 18
		rg:           true
	}
	trust: {
		policyBoundary:  false
		sandboxBoundary: false
	}

	tools: [
		"search",
		"advanced-search",
		"count-matches",
		"list-files",
		"list-file-types",
	]
}

mcpRipgrep: #MCPRipgrepAdapter
