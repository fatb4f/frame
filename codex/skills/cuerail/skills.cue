package cuerail

#SkillStatus: "active" | "deferred" | "legacy"

#Skill: {
	id:             string
	path:           string
	entrypoint:     string
	purpose:        string
	required_tools: [...string]
	optional_tools: [...string]
	triggers:       [...string]
	delegates:      [...string]
	status:         #SkillStatus
}

skills: {
	cuerail: #Skill & {
		id:         "cuerail"
		path:       "$CODEX_HOME/skills/cuerail"
		entrypoint: "$CODEX_HOME/skills/cuerail/SKILL.md"
		purpose:    "Agent-facing Cuerail operating procedure, runtime boundary, MCP-only observation policy, validation, and recovery."
		required_tools: [
			"mcp__git_mcp_server__",
			"mcp__mcp_ripgrep__",
		]
		optional_tools: [
			"mcp__ripgrep__",
			"cue",
		]
		triggers: [
			"cuerail",
			"Codex hooks",
			"MCP git/search policy",
			"runtime payload",
			"cuerail fallback",
			"tools/cuerail",
		]
		delegates: [
			"codex-hooks",
			"mcp-git",
			"mcp-ripgrep",
			"runtime-validation",
		]
		status: "active"
	}
}

skillIndex: [{
	id:         skills.cuerail.id
	path:       skills.cuerail.path
	entrypoint: skills.cuerail.entrypoint
	purpose:    skills.cuerail.purpose
	status:     skills.cuerail.status
	triggers:   skills.cuerail.triggers
}]
