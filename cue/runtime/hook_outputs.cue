package cuerail

import hooks "github.com/fatb4f/cuerail/cue/generated/hooks"

#HookOutputByEvent: {
	"SessionStart":      hooks.#SessionStartCommandOutput
	"UserPromptSubmit":  hooks.#UserPromptSubmitCommandOutput
	"PreToolUse":        hooks.#PreToolUseCommandOutput
	"PermissionRequest": hooks.#PermissionRequestCommandOutput
	"PostToolUse":       hooks.#PostToolUseCommandOutput
	"PreCompact":        hooks.#PreCompactCommandOutput
	"PostCompact":       hooks.#PostCompactCommandOutput
	"SubagentStart":     hooks.#SubagentStartCommandOutput
	"SubagentStop":      hooks.#SubagentStopCommandOutput
	"Stop":              hooks.#StopCommandOutput
}

#CodexHookOutput: hooks.#SessionStartCommandOutput |
	hooks.#UserPromptSubmitCommandOutput |
	hooks.#PreToolUseCommandOutput |
	hooks.#PermissionRequestCommandOutput |
	hooks.#PostToolUseCommandOutput |
	hooks.#PreCompactCommandOutput |
	hooks.#PostCompactCommandOutput |
	hooks.#SubagentStartCommandOutput |
	hooks.#SubagentStopCommandOutput |
	hooks.#StopCommandOutput
