package cuerail

#MCPStdioServer: {
	name:    string
	command: string
	args?: [...string]
	env_vars?: [...string]
	...
}

#MCPRipgrepAdapter: #MCPStdioServer & {
	name:      "ripgrep"
	package:   "mcp-ripgrep"
	version:   "0.4.0"
	transport: "stdio"
	command:   "/home/_404/.local/share/codex/bin/cuerail-mcp-ripgrep"
	args: []
	env_vars: ["PATH", "CODEX_STATE"]

	requires: {
		node: ">=18"
		rg:   true
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
