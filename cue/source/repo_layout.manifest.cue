package cuerail

// Repo layout manifest.
//
// This is a descriptive relocation map only.
// It says where current assets belong when the tree is split into branches.
// It does not move files.

repo_layout: {
	name: "cuerail repo layout"

	target: {
		root: "cuerail"

		branches: [
			"definitions",
			"skill",
			"hooks",
			"observation",
		]

		each_branch_has: [
			"runtime",
			"src",
		]
	}

	assets: {
		definitions: {
			plain: "Shared names and schemas Cuerail uses to describe itself."

			runtime: [
				{
					from: "cue/generated/hooks"
					to:   "definitions/runtime/generated/hooks"
				},
				{
					from: "cue/generated/config"
					to:   "definitions/runtime/generated/config"
				},
			]

			src: [
				{
					from: "cue/source"
					to:   "definitions/src/source"
				},
				{
					from: "cue/sync"
					to:   "definitions/src/sync"
				},
				{
					from: "bin/cuerail-schema-sync"
					to:   "definitions/src/bin/cuerail-schema-sync"
				},
				{
					from: "bin/cuerail-config-schema-sync"
					to:   "definitions/src/bin/cuerail-config-schema-sync"
				},
			]
		}

		skill: {
			plain: "The dedicated agent-facing MCP skills and their source."

			runtime: [
				{
					from: "codex/skills/git"
					to:   "skill/runtime/codex/skills/git"
				},
				{
					from: "codex/skills/rg"
					to:   "skill/runtime/codex/skills/rg"
				},
			]

			src: [
				{
					from: "cue/source/cuerail.manifest.cue"
					to:   "skill/src/cuerail.manifest.cue"
				},
			]
		}

		hooks: {
			plain: "The hook sidecar and the CUE files that make hook manifests."

			runtime: [
				{
					from: "bin/cuerail-hook"
					to:   "hooks/runtime/bin/cuerail-hook"
				},
				{
					from: "codex/config.toml"
					to:   "hooks/runtime/codex/config.toml"
				},
			]

			src: [
				{
					from: "cue/runtime/codex_events.cue"
					to:   "hooks/src/codex_events.cue"
				},
				{
					from: "cue/runtime/hook_manifest.cue"
					to:   "hooks/src/hook_manifest.cue"
				},
				{
					from: "cue/runtime/hook_outputs.cue"
					to:   "hooks/src/hook_outputs.cue"
				},
				{
					from: "cue/runtime/capture_policy.cue"
					to:   "hooks/src/capture_policy.cue"
				},
				{
					from: "cue/runtime/awareness_plan.cue"
					to:   "hooks/src/awareness_plan.cue"
				},
				{
					from: "cue/runtime/examples_hooks.cue"
					to:   "hooks/src/examples_hooks.cue"
				},
				{
					from: "test/fixtures/hooks"
					to:   "hooks/src/test/fixtures/hooks"
				},
			]
		}

		observation: {
			plain: "MCP evidence capture and call-origin tracking."

			runtime: [
				{
					from: "bin/cuerail-mcp-ripgrep"
					to:   "observation/runtime/bin/cuerail-mcp-ripgrep"
				},
				{
					from: "bin/cuerail-mcp-capture"
					to:   "observation/runtime/bin/cuerail-mcp-capture"
				},
				{
					from: "bin/cuerail-git-mcp-go"
					to:   "observation/runtime/bin/cuerail-git-mcp-go"
				},
				{
					from: "bin/git-mcp-go-cuerail"
					to:   "observation/runtime/bin/git-mcp-go-cuerail"
				},
				{
					from: "bin/cuerail-git-capture"
					to:   "observation/runtime/bin/cuerail-git-capture"
				},
				{
					from: "bin/cuerail-rg-capture"
					to:   "observation/runtime/bin/cuerail-rg-capture"
				},
			]

			src: [
				{
					from: "cue/runtime/hook_observation.cue"
					to:   "observation/src/hook_observation.cue"
				},
				{
					from: "cue/runtime/git_repo_capture.cue"
					to:   "observation/src/git_repo_capture.cue"
				},
				{
					from: "cue/runtime/rg_search_capture.cue"
					to:   "observation/src/rg_search_capture.cue"
				},
				{
					from: "cue/adapters/git_mcp_go.cue"
					to:   "observation/src/adapters/git_mcp_go.cue"
				},
				{
					from: "cue/adapters/mcp_ripgrep.cue"
					to:   "observation/src/adapters/mcp_ripgrep.cue"
				},
				{
					from: "cache/mcp/git-mcp-go/adapter.json"
					to:   "observation/src/cache/mcp/git-mcp-go/adapter.json"
				},
				{
					from: "test/fixtures/mcp"
					to:   "observation/src/test/fixtures/mcp"
				},
			]
		}
	}

	pending: [
		{
			from: "README.md"
			note: "docs; keep at root or split later"
		},
		{
			from: "ADAPTER.md"
			note: "docs; keep at root or split later"
		},
		{
			from: "MODEL.md"
			note: "docs; keep at root or split later"
		},
		{
			from: "INSTALL.md"
			note: "docs; keep at root or split later"
		},
		{
			from: "bin/cuerail-install"
			note: "installer; branch target undecided"
		},
		{
			from: "bin/cuerail-doctor"
			note: "doctor; branch target undecided"
		},
		{
			from: "bin/cuerail-review-packet"
			note: "review helper; branch target undecided"
		},
		{
			from: "bin/cuerail-token-usage"
			note: "usage helper; branch target undecided"
		},
		{
			from: "bin/cuerail-run"
			note: "runner; branch target undecided"
		},
		{
			from: "cue/agents"
			note: "old control inventory; do not move until role is decided"
		},
		{
			from: "cue/runtime/review_packet.cue"
			note: "review helper schema; branch target undecided"
		},
		{
			from: "cue/runtime/token_usage_evidence.cue"
			note: "usage helper schema; branch target undecided"
		},
		{
			from: "cue/runtime/turn.cue"
			note: "turn aggregate schema; branch target undecided"
		},
		{
			from: "cue/runtime/examples.cue"
			note: "example aggregate; branch target undecided"
		},
		{
			from: "cue/runtime/hooks.cue"
			note: "hook model helper; branch target undecided"
		},
		{
			from: "cue/adapters/temporary_shell.cue"
			note: "temporary adapter definition; branch target undecided"
		},
		{
			from: "codex/skills/.system"
			note: "mirrored Codex system skills; not Cuerail branch ownership"
		},
		{
			from: "legacy"
			note: "legacy frame runtime; quarantine or delete later"
		},
		{
			from: "test/fixtures/token-usage"
			note: "usage helper fixtures; branch target undecided"
		},
	]
}
