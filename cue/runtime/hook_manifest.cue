package cuerail

import hooks "github.com/fatb4f/cuerail/cue/generated/hooks"

hookInput: {
	hook_event_name!: #CodexHookEvent
}

_hookInput: hookInput

#HookInputByEvent: {
	"SessionStart":      hooks.#SessionStartCommandInput
	"UserPromptSubmit":  hooks.#UserPromptSubmitCommandInput
	"PreToolUse":        hooks.#PreToolUseCommandInput
	"PermissionRequest": hooks.#PermissionRequestCommandInput
	"PostToolUse":       hooks.#PostToolUseCommandInput
	"PreCompact":        hooks.#PreCompactCommandInput
	"PostCompact":       hooks.#PostCompactCommandInput
	"SubagentStart":     hooks.#SubagentStartCommandInput
	"SubagentStop":      hooks.#SubagentStopCommandInput
	"Stop":              hooks.#StopCommandInput
}

#CodexHookInput: hooks.#SessionStartCommandInput |
	hooks.#UserPromptSubmitCommandInput |
	hooks.#PreToolUseCommandInput |
	hooks.#PermissionRequestCommandInput |
	hooks.#PostToolUseCommandInput |
	hooks.#PreCompactCommandInput |
	hooks.#PostCompactCommandInput |
	hooks.#SubagentStartCommandInput |
	hooks.#SubagentStopCommandInput |
	hooks.#StopCommandInput

#HookManifest: #SessionStartHookManifest |
	#UserPromptSubmitHookManifest |
	#PreToolUseHookManifest |
	#PermissionRequestHookManifest |
	#PostToolUseHookManifest |
	#PreCompactHookManifest |
	#PostCompactHookManifest |
	#SubagentStartHookManifest |
	#SubagentStopHookManifest |
	#StopHookManifest

#McpEvidenceTool: "mcp-ripgrep" | "git-mcp-server"

#SessionStartHookManifest: {
	input: hooks.#SessionStartCommandInput & _hookInput
	output: hooks.#SessionStartCommandOutput
	capture: {
		persist: false
	}
}

#UserPromptSubmitHookManifest: {
	input: hooks.#UserPromptSubmitCommandInput & _hookInput
	output: hooks.#UserPromptSubmitCommandOutput
	capture: {
		persist: true
	}
}

#PreToolUseHookManifest: {
	input: hooks.#PreToolUseCommandInput & _hookInput
	output: hooks.#PreToolUseCommandOutput
	capture: {
		persist: false
	}
}

#PermissionRequestHookManifest: {
	input: hooks.#PermissionRequestCommandInput & _hookInput
	output: hooks.#PermissionRequestCommandOutput
	capture: {
		persist: false
	}
}

#PostToolUseHookManifest: {
	input: hooks.#PostToolUseCommandInput & _hookInput
	output: hooks.#PostToolUseCommandOutput
	capture: {
		if input.tool_name == "mcp-ripgrep" {
			persist: true
		}
		if input.tool_name == "git-mcp-server" {
			persist: true
		}
		if input.tool_name != "mcp-ripgrep" && input.tool_name != "git-mcp-server" {
			persist: false
		}
	}
}

#PreCompactHookManifest: {
	input: hooks.#PreCompactCommandInput & _hookInput
	output: hooks.#PreCompactCommandOutput
	capture: {
		persist: false
	}
}

#PostCompactHookManifest: {
	input: hooks.#PostCompactCommandInput & _hookInput
	output: hooks.#PostCompactCommandOutput
	capture: {
		persist: false
	}
}

#SubagentStartHookManifest: {
	input: hooks.#SubagentStartCommandInput & _hookInput
	output: hooks.#SubagentStartCommandOutput
	capture: {
		persist: false
	}
}

#SubagentStopHookManifest: {
	input: hooks.#SubagentStopCommandInput & _hookInput
	output: hooks.#SubagentStopCommandOutput
	capture: {
		persist: false
	}
}

#StopHookManifest: {
	input: hooks.#StopCommandInput & _hookInput
	output: hooks.#StopCommandOutput
	capture: {
		persist: true
	}
}
