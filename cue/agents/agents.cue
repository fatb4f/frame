package agents

#AgentContract: {
	id: "cuerail-agent-contract"

	purpose: """
		Migration artifact for the former repo-local AGENTS.md contract.
		Active agent-facing Cuerail policy has moved to
		$CODEX_HOME/skills/cuerail/SKILL.md and Codex hook/config wiring.
		This package remains only to validate and unwind historical projections
		without changing runtime, hook, adapter, or MCP behavior.
		"""

	surfaces: {
		active: [
			{
				id:      "cuerail-command-surface"
				status:  "active"
				purpose: "Current Cuerail hook, validation, and MCP wrapper command surface."
				paths: [
					"bin/cuerail-hook",
					"bin/cuerail-doctor",
					"bin/cuerail-schema-sync",
				]
			},
			{
				id:      "cuerail-runtime-cue"
				status:  "active"
				purpose: "Current CUE runtime schemas, hook manifests, and capture policy."
				paths: [
					"cue/runtime/*",
					"cue/adapters/*",
					"cue/agents/*",
					"fixtures/*",
				]
			},
		]

		preferred: [
			{
				id:      "git-mcp-server"
				status:  "active"
				purpose: "Only live git surface for agent-visible repository observations and user-requested staging or commits."
				commands: ["git-mcp-server"]
			},
			{
				id:      "mcp-ripgrep"
				status:  "active"
				purpose: "Only live bounded search surface for agent-visible repository observations."
				commands: ["mcp-ripgrep"]
			},
		]

		fallback: []

		legacy: [
			{
				id:      "workflows-frame"
				status:  "legacy"
				purpose: "Earlier Cuerails model retained only as historical reference until pruned."
				paths: [
					"workflows/frame/",
					"workflows/frame/bin/repo-frame",
					"workflows/frame/cue/#ContextFrame",
					"workflows/frame/skills/*",
				]
				commands: [
					"./workflows/frame/bin/repo-frame . \"$USER_GOAL\"",
					"repo-frame . \"$USER_GOAL\"",
				]
			},
		]
	}

	adapterFactSources: {
		lifecycleAuthority: "cue/adapters/temporary_shell.cue"
		projectedBy:        "#FallbackAdapterFacts"
		agentsMayProject: [
			"adapter id",
			"lifecycle",
			"replacement target",
			"allowed operations",
		]
		agentsMustNotDuplicate: [
			"replacement mapping",
			"lifecycle state",
			"deprecation state",
		]
	}

	authorityBoundaries: [
		{
			owner: "cue"
			owns: [
				"state shape",
				"validation",
				"selectors",
				"capture policy",
				"projections",
				"examples",
			]
			mustNotOwn: [
				"active agent policy",
				"agent constraints",
				"project constraints",
				"filesystem locking mechanics",
				"atomic rename mechanics",
				"process execution mechanics",
			]
		},
		{
			owner: "shell"
			owns: [
				"filesystem mechanics",
				"process execution",
				"tool invocation",
				"locking",
				"atomic writes",
				"smoke checks",
			]
			mustNotOwn: [
				"policy",
				"semantic projection",
				"capture decisions",
				"agent constraints",
				"project constraints",
			]
		},
		{
			owner: "markdown"
			owns: [
				"human/bootstrap pointer to Codex config and the Cuerail skill",
			]
			mustNotOwn: [
				"agent policy",
				"project policy",
				"validation policy",
				"architecture authority boundaries",
			]
		},
	]

	observation: {
		priority: [
			"configured-mcp-server",
		]

		mcp: {
			preferred: true
			servers: ["git-mcp-server", "mcp-ripgrep"]
			preserveRawJSON:               true
			mustNotNormalizeBeforeCapture: true
			visibilityChecks: [
				{
					run:     "codex mcp list --json"
					purpose: "Inspect active Codex MCP configuration when MCP visibility is in question."
				},
				{
					run:     "codex mcp get mcp-ripgrep --json || true"
					purpose: "Inspect mcp-ripgrep availability and allowlist state."
				},
				{
					run:     "codex mcp get git-mcp-server --json || true"
					purpose: "Inspect git-mcp-server availability and allowlist state."
				},
			]
		}

		fallbackAdapters: {
			useOnlyWhen: []
			commands: []
		}

		directShell: {
			useOnlyWhen: []
		}

		constraints: [
			{
				id:       "observation-mcp-only"
				title:    "Use MCP for git and search observations"
				severity: "required"
				appliesTo: ["repo-aware work", "repository observations"]
				statement: "Use git-mcp-server and mcp-ripgrep for git and search observations. Do not use shell git, shell rg, repo-git, or repo-rg as observation surfaces."
			},
			{
				id:       "mcp-raw-json-preservation"
				title:    "Preserve raw MCP JSON"
				severity: "required"
				appliesTo: ["MCP observations", "evidence capture"]
				statement: "Configured MCP server responses must be preserved opaquely as raw JSON evidence before any derived projection."
			},
			{
				id:       "mcp-no-pre-capture-normalization"
				title:    "Do not normalize MCP output before capture"
				severity: "forbidden"
				appliesTo: ["MCP observations", "evidence capture"]
				statement: "Do not parse ripgrep results into path/line/text fields, parse git results into branch/head/dirty fields, compact diff/log/status output, or add projection layers before raw MCP evidence capture."
			},
			{
				id:       "no-shell-fallback-observation"
				title:    "No shell fallback for git or search"
				severity: "forbidden"
				appliesTo: ["repo-git", "repo-rg", "repository observations"]
				statement: "Do not use repo-git or repo-rg for agent repository observation. If MCP is unavailable or insufficient, report the blocker instead of falling back to shell."
			},
			{
				id:       "repo-git-not-argv-passthrough"
				title:    "repo-git is not git argv passthrough"
				severity: "forbidden"
				appliesTo: ["repo-git"]
				statement: "repo-git must not be used as an agent repository observation surface."
			},
			{
				id:       "repo-rg-bounded-search"
				title:    "repo-rg is bounded search only"
				severity: "forbidden"
				appliesTo: ["repo-rg"]
				statement: "repo-rg must not be used as an agent repository observation surface."
			},
			{
				id:       "adapter-facts-projected-not-duplicated"
				title:    "Project adapter lifecycle facts"
				severity: "required"
				appliesTo: ["cue/agents", "cue/adapters"]
				statement: "Fallback adapter lifecycle and replacement facts come from #FallbackAdapterFacts projected from cue/adapters/temporary_shell.cue, not duplicated fields in cue/agents."
			},
			{
				id:       "bounded-repo-observation"
				title:    "Keep observations repo-bounded"
				severity: "forbidden"
				appliesTo: ["repo-aware work", "search"]
				statement: "Keep observations bounded to the current repository. Do not search $HOME or /."
			},
		]
	}

	gitWorkflow: {
		preferredSurface: "git-mcp-server"

		commands: [
			{
				run:     "git-mcp-server.git_status"
				purpose: "Inspect repository status before staging or committing."
			},
			{
				run:     "git-mcp-server.git_add"
				purpose: "Stage user-approved paths through the MCP git surface."
				when:    "staging is requested or required for a user-approved commit"
			},
			{
				run:     "git-mcp-server.git_diff_staged"
				purpose: "Inspect staged content before committing."
				when:    "before creating a commit"
			},
			{
				run:     "git-mcp-server.git_commit"
				purpose: "Create the user-approved commit through the MCP git surface."
				when:    "after staged contents and commit intent are confirmed"
			},
			{
				run:     "git-mcp-server.git_status"
				purpose: "Verify repository status after committing."
				when:    "after creating a commit"
			},
		]

		constraints: [
			{
				id:       "git-workflow-mcp-stage-commit"
				title:    "Use MCP for staging and commits"
				severity: "required"
				appliesTo: ["staging", "committing", "git workflow"]
				statement: "Use git-mcp-server for staging and committing. Do not use shell git."
			},
			{
				id:       "git-workflow-status-before-commit"
				title:    "Inspect staged contents before commit"
				severity: "required"
				appliesTo: ["committing"]
				statement: "Inspect status and staged diff before creating a commit."
			},
			{
				id:       "git-workflow-user-approved-commit"
				title:    "Commit only approved work"
				severity: "required"
				appliesTo: ["committing"]
				statement: "Commit only user-approved staged changes and do not stage unrelated work."
			},
			{
				id:       "git-workflow-no-repo-git-mutation"
				title:    "repo-git remains read-only"
				severity: "forbidden"
				appliesTo: ["repo-git", "committing", "staging"]
				statement: "Do not extend repo-git into a staging or commit adapter."
			},
		]
	}

	turnStart: {
		commands: [
			{
				run:     "codex mcp list --json"
				purpose: "Inspect active Codex MCP configuration when MCP visibility is in question."
			},
			{
				run:     "codex mcp get mcp-ripgrep --json || true"
				purpose: "Inspect mcp-ripgrep availability and allowlist state."
			},
			{
				run:     "codex mcp get git-mcp-server --json || true"
				purpose: "Inspect git-mcp-server availability and allowlist state."
			},
		]

		constraints: [
			{
				id:       "turn-start-mcp-only"
				title:    "Start with configured MCP"
				severity: "required"
				appliesTo: ["repo-aware work"]
				statement: "At the start of repo-aware work, inspect repository status and source search only through configured git-mcp-server and mcp-ripgrep tools."
			},
			{
				id:       "turn-start-report-mcp-blockers"
				title:    "Report MCP blockers"
				severity: "required"
				appliesTo: ["repo-aware work"]
				statement: "If MCP allowlists, missing commands, missing configuration, denied repository paths, or insufficient MCP tools block git or search observation, report that explicitly instead of falling back to shell."
			},
		]
	}

	hookManifest: {
		authority: "cue"

		surfaces: [
			"cue/runtime/hook_manifest.cue",
			"#HookManifest",
			"#HookManifest.capture.persist",
		]

		persistedEvents: [
			"UserPromptSubmit",
			"Stop",
			"PostToolUse where tool_name == mcp-ripgrep",
			"PostToolUse where tool_name == git-mcp-server",
		]

		constraints: [
			{
				id:       "hook-cue-authority"
				title:    "CUE owns hook manifest shape and capture policy"
				severity: "required"
				appliesTo: ["hook behavior", "manifest behavior"]
				statement: "CUE is the authority for hook manifest shape and capture policy."
			},
			{
				id:       "hook-no-shell-policy"
				title:    "Shell must not own capture policy"
				severity: "forbidden"
				appliesTo: ["shell adapters", "hook adapters"]
				statement: "Do not move capture policy into shell."
			},
			{
				id:       "hook-shell-adapter-only"
				title:    "Shell scripts are adapters only"
				severity: "required"
				appliesTo: ["shell adapters"]
				statement: "Shell may read hook input, invoke CUE, derive paths, acquire locks, write temp files, validate manifests, and rename atomically, but must not become policy authority."
			},
		]
	}

	validation: {
		commands: [
			{
				run:     "PATH=\"$PWD/bin:$PATH\" sh -n bin/*"
				purpose: "Validate shell syntax for Cuerail adapters."
				when:    "after changing adapter wiring or hook behavior"
			},
			{
				run:     "CODEX_HOME=\"${CODEX_HOME:-$HOME/.local/share/codex}\" CODEX_STATE=\"${CODEX_STATE:-$HOME/.local/state/codex}\" PATH=\"$PWD/bin:$PATH\" cuerail-schema-sync --check"
				purpose: "Validate generated hook schema sync."
				when:    "after changing CUE schemas or schema-sync behavior"
			},
			{
				run:     "CODEX_HOME=\"${CODEX_HOME:-$HOME/.local/share/codex}\" CODEX_STATE=\"${CODEX_STATE:-$HOME/.local/state/codex}\" CUERAIL_HOME=\"${CUERAIL_HOME:-$CODEX_HOME/tools/cuerail}\" CUERAIL_BIN=\"${CUERAIL_BIN:-$CUERAIL_HOME/bin}\" CUERAIL_STATE=\"${CUERAIL_STATE:-$CODEX_STATE/cuerail}\" PATH=\"$CUERAIL_BIN:$PATH\" \"$CUERAIL_BIN/cuerail-doctor\""
				purpose: "Run Cuerail doctor."
				when:    "after changing hook behavior, schema-sync behavior, or adapter wiring"
			},
			{
				run:     "cue vet -c=false ./cue/..."
				purpose: "Validate all CUE packages recursively."
				when:    "after changing CUE schemas or contract packages"
			},
			{
				run:     "cue vet -c=false ./cue/agents"
				purpose: "Validate the agent contract package directly."
				when:    "after changing cue/agents"
			},
		]

		constraints: [
			{
				id:       "validation-prefer-existing"
				title:    "Prefer repo-local validation"
				severity: "required"
				appliesTo: ["validation"]
				statement: "Prefer existing repo-local validation commands over inventing new ones."
			},
			{
				id:       "validation-recursive-cue-primary"
				title:    "Use recursive CUE validation"
				severity: "required"
				appliesTo: ["validation", "CUE packages"]
				statement: "Use cue vet -c=false ./cue/... as the primary CUE validation gate for contract packages."
			},
		]
	}

	planGate: {
		nativePlanOwns: [
			"step text",
			"pending status",
			"in_progress status",
			"completed status",
		]

		sidecarOwns: [
			"reads",
			"writes",
			"symbols",
			"protected impact",
			"gates",
			"required evidence",
		]

		constraints: [
			{
				id:       "plan-no-native-schema-extension"
				title:    "Do not extend native update_plan"
				severity: "forbidden"
				appliesTo: ["planning", "plan validation"]
				statement: "Do not extend Codex's native update_plan schema. Treat it as the human-visible status rail only."
			},
			{
				id:       "plan-no-streaming-canonical"
				title:    "Do not bind PlanDelta as canonical"
				severity: "forbidden"
				appliesTo: ["planning", "plan validation"]
				statement: "Do not parse PlanDelta streaming text as canonical. Bind only completed native plan item text."
			},
			{
				id:       "plan-no-new-daemons"
				title:    "No dynamic plan runtime"
				severity: "forbidden"
				appliesTo: ["planning", "plan validation"]
				statement: "Do not add dynamic tools, daemons, new runtime registries, or MCP dependencies for plan validation."
			},
			{
				id:       "no-new-mcp-before-adapter-ready"
				title:    "No new MCP dependency before adapter path is ready"
				severity: "forbidden"
				appliesTo: ["architecture", "adapter design", "plan validation"]
				statement: "Do not add a new MCP dependency before the adapter path is ready."
			},
		]
	}

	skillRouting: {
		preferred: [
			{
				id:      "cue-work"
				status:  "active"
				purpose: "Inspect cue/runtime and current schema-sync/doctor fixtures."
				paths: ["cue/runtime", "fixtures"]
			},
			{
				id:      "git-evidence"
				status:  "active"
				purpose: "Use git-mcp-server as the only git evidence surface."
				commands: ["git-mcp-server"]
			},
			{
				id:      "search-evidence"
				status:  "active"
				purpose: "Use mcp-ripgrep as the only search evidence surface."
				commands: ["mcp-ripgrep"]
			},
			{
				id:      "hook-behavior"
				status:  "active"
				purpose: "Use Cuerail hook, doctor, fixtures, and #HookManifest."
				commands: ["bin/cuerail-hook", "bin/cuerail-doctor"]
				paths: ["fixtures", "cue/runtime/hook_manifest.cue"]
			},
		]

		forbidden: [
			{
				id:      "legacy-frame-skills"
				status:  "forbidden"
				purpose: "Legacy skill routing is not active for current work."
				paths: [
					"workflows/frame/skills/SKILL.md",
					"workflows/frame/bin/repo-frame",
					"#ContextFrame",
				]
			},
		]

		constraints: [
			{
				id:       "skills-routing-only"
				title:    "Skills are hints, not authority"
				severity: "required"
				appliesTo: ["skill routing"]
				statement: "Use repo-local skills only as routing hints, not independent authority."
			},
			{
				id:       "legacy-frame-skills-not-active"
				title:    "Do not route through legacy frame skills"
				severity: "forbidden"
				appliesTo: ["skill routing"]
				statement: "Do not route current work through workflows/frame skills, workflows/frame/bin/repo-frame, or #ContextFrame."
			},
		]
	}

	boundaries: {
		constraints: [
			{
				id:       "no-agent-loop"
				title:    "No agent loop"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add an agent loop."
			},
			{
				id:       "no-planner-framework"
				title:    "No planner framework"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add a planner framework."
			},
			{
				id:       "no-go-runtime"
				title:    "No Go runtime"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add a Go runtime."
			},
			{
				id:       "no-python-runtime"
				title:    "No Python runtime"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add a Python runtime."
			},
			{
				id:       "no-broad-framework-layer"
				title:    "No broad framework layer"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add a broad framework layer."
			},
			{
				id:       "no-durable-frame-runtime"
				title:    "No durable frame runtime"
				severity: "forbidden"
				appliesTo: ["architecture"]
				statement: "Do not add a durable frame runtime."
			},
			{
				id:       "project-deletable"
				title:    "Keep project deletable"
				severity: "required"
				appliesTo: ["new files"]
				statement: "Every new file must support state, validation, adapter behavior, fixture coverage, repo-local skill routing, or a single-turn context contract."
			},
		]
	}

	pruning: {
		constraints: [
			{
				id:       "prune-workflows-frame-after-adapter-recovery"
				title:    "Prune workflows/frame only after useful adapter pieces move"
				severity: "recommended"
				appliesTo: ["legacy cleanup"]
				statement: "workflows/frame may be pruned once useful adapter pieces have been moved into the active Cuerail surface."
			},
			{
				id:       "confirm-no-active-frame-references"
				title:    "Confirm no active frame references before pruning"
				severity: "required"
				appliesTo: ["legacy cleanup"]
				statement: "Before pruning, confirm no active docs or scripts require repo-frame, #ContextFrame, or workflows/frame skills."
			},
		]
	}
}
