package cuerail

// cuerail.manifest.cue
//
// Source-owned operational DAG for the Cuerail runtime as it exists today.
//
// This file is intentionally conservative: it describes the current projected
// runtime instead of a future pruning target. Pruning is a no-op until this
// graph is stable and each candidate file can be mapped to a node, edge, gate,
// artifact, or explicit quarantine decision.

#NodeID:
	"source_contract" |
	"project_config" |
	"project_skill" |
	"install_runtime" |
	"session_start_awareness" |
	"user_prompt_manifest" |
	"pretool_awareness" |
	"pretool_gate" |
	"posttool_mcp_manifest" |
	"stop_awareness" |
	"stop_manifest" |
	"agent_read_manifests" |
	"agent_mcp_fallback" |
	"doctor_validate"

#NodeKind:
	"source" |
	"projection" |
	"install" |
	"hook" |
	"mcp_capture" |
	"manifest_write" |
	"gate" |
	"agent_recovery" |
	"doctor"

#Surface:
	"source" |
	"codex_runtime" |
	"hook_runtime" |
	"mcp" |
	"state" |
	"skill" |
	"doctor"

// Active installed hook phases in codex/config.toml.
#Phase:
	"SessionStart" |
	"UserPromptSubmit" |
	"PreToolUse" |
	"PostToolUse" |
	"Stop"

#EdgeKind:
	"projects" |
	"installs" |
	"precedes" |
	"requires" |
	"guards" |
	"writes" |
	"reads" |
	"falls_back_to" |
	"validates"

#ArtifactKind:
	"cue_contract" |
	"config" |
	"skill" |
	"mcp_evidence" |
	"phase_manifest" |
	"doctor_check"

#Artifact: {
	kind:  #ArtifactKind
	path:  string
	owner: #Surface
}

#Node: {
	id:      #NodeID
	kind:    #NodeKind
	surface: #Surface

	// Static topological rank. Edges must point from lower rank to higher rank.
	rank: int & >=0

	phase?: #Phase
	why:    string

	reads?:   [...string]
	writes?:  [...#Artifact]
	forbids?: [...string]
}

#Edge: {
	from:      #NodeID
	to:        #NodeID
	kind:      #EdgeKind
	why:       string
	condition?: string
}

#Gate: {
	id:       =~"^[a-z][a-z0-9_]*$"
	node:     #NodeID
	enforces: [...string]
	denies:  [...string]
}

dag: {
	name:    "cuerail.operational_dag"
	version: "0.1.0"

	invariant: [
		"Hooks collect.",
		"Persisted hook manifests record.",
		"Skill recovers.",
		"MCP observes.",
		"Shell executes.",
	]

	runtimeOwns: [
		"codex/config.toml",
		"codex/skills/cuerail",
		"$CODEX_HOME/tools/cuerail/bin/cuerail-hook",
		"$CODEX_STATE/cuerail",
	]

	runtimeForbids: [
		"codex/skills/.system as Cuerail runtime authority",
		"agent workflow brain",
		"review-packet framework as runtime authority",
		"active cue/agents authority",
		"shell git observation",
		"shell rg observation",
		"repo-git/repo-rg as agent-facing fallback",
	]

	nodes: [ID=#NodeID]: #Node & {
		id: ID
	}

	nodes: {
		source_contract: {
			kind:    "source"
			surface: "source"
			rank:    0
			why:     "Define the source-owned operational graph before pruning or runtime migration."
			reads: [
				"cue/source/cuerail.manifest.cue",
				"cue/runtime/*.cue",
			]
			writes: [{
				kind:  "cue_contract"
				path:  "cue/source/cuerail.manifest.cue"
				owner: "source"
			}]
		}

		project_config: {
			kind:    "projection"
			surface: "source"
			rank:    10
			why:     "Expose Codex hook and MCP wiring through the source-owned config tree."
			reads: [
				"codex/config.toml",
				"cue/runtime/hook_manifest.cue",
				"cue/runtime/capture_policy.cue",
			]
			writes: [{
				kind:  "config"
				path:  "codex/config.toml"
				owner: "codex_runtime"
			}]
		}

		project_skill: {
			kind:    "projection"
			surface: "source"
			rank:    10
			why:     "Expose thin Cuerail recovery guidance."
			reads: [
				"codex/skills/cuerail/SKILL.md",
				"cue/runtime/hook_observation.cue",
			]
			writes: [{
				kind:  "skill"
				path:  "codex/skills/cuerail/SKILL.md"
				owner: "skill"
			}]
			forbids: [
				"plan model",
				"workflow model",
				"review packet model",
				"control inventory authority",
				"shell observation fallback",
			]
		}

		install_runtime: {
			kind:    "install"
			surface: "codex_runtime"
			rank:    20
			why:     "Expose projected config and Cuerail skill through CODEX_HOME symlinks."
			reads: [
				"codex/config.toml",
				"codex/skills/cuerail",
			]
			writes: [
				{
					kind:  "config"
					path:  "$CODEX_HOME/config.toml"
					owner: "codex_runtime"
				},
				{
					kind:  "skill"
					path:  "$CODEX_HOME/skills/cuerail/SKILL.md"
					owner: "skill"
				},
			]
		}

		session_start_awareness: {
			kind:    "mcp_capture"
			surface: "mcp"
			rank:    100
			phase:   "SessionStart"
			why:     "Run the current SessionStart MCP awareness plan; this phase is not persisted by capture policy."
			reads: [
				"Codex SessionStart hook payload",
				"cue/runtime/awareness_plan.cue",
				"git MCP server",
			]
			forbids: [
				"git status via shell",
			]
		}

		user_prompt_manifest: {
			kind:    "manifest_write"
			surface: "state"
			rank:    200
			phase:   "UserPromptSubmit"
			why:     "Persist the submitted prompt hook manifest according to current capture policy."
			reads: [
				"Codex UserPromptSubmit hook payload",
				"cue/runtime/hook_manifest.cue",
				"cue/runtime/capture_policy.cue",
			]
			writes: [{
				kind:  "phase_manifest"
				path:  "$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/events/<seq>-user-prompt-submit.cue"
				owner: "state"
			}]
		}

		pretool_awareness: {
			kind:    "mcp_capture"
			surface: "mcp"
			rank:    300
			phase:   "PreToolUse"
			why:     "Run the current PreToolUse MCP awareness plan before tool execution."
			reads: [
				"Codex PreToolUse hook payload",
				"cue/runtime/awareness_plan.cue",
				"mcp-ripgrep server",
			]
			forbids: [
				"rg via shell",
				"grep via shell",
				"find via shell for repo discovery",
			]
		}

		pretool_gate: {
			kind:    "gate"
			surface: "hook_runtime"
			rank:    310
			phase:   "PreToolUse"
			why:     "Deny shell-based repository observation before shell tools run."
			reads: [
				"Codex PreToolUse hook payload",
				"cue/runtime/capture_policy.cue",
			]
			forbids: [
				"shell git observation",
				"shell rg observation",
				"shell grep/find discovery",
			]
		}

		posttool_mcp_manifest: {
			kind:    "manifest_write"
			surface: "state"
			rank:    400
			phase:   "PostToolUse"
			why:     "Persist MCP tool result manifests for configured git/search MCP servers."
			reads: [
				"Codex PostToolUse hook payload",
				"mcp-ripgrep or git-mcp-server tool result",
				"cue/runtime/hook_manifest.cue",
				"cue/runtime/capture_policy.cue",
			]
			writes: [{
				kind:  "phase_manifest"
				path:  "$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/events/<seq>-post-tool-use.<tool>.cue"
				owner: "state"
			}]
		}

		stop_awareness: {
			kind:    "mcp_capture"
			surface: "mcp"
			rank:    500
			phase:   "Stop"
			why:     "Run the current Stop MCP awareness plan before closeout persistence."
			reads: [
				"Codex Stop hook payload",
				"cue/runtime/awareness_plan.cue",
				"git MCP server",
			]
			forbids: [
				"git status via shell",
				"git diff via shell",
			]
		}

		stop_manifest: {
			kind:    "manifest_write"
			surface: "state"
			rank:    510
			phase:   "Stop"
			why:     "Persist the stop hook manifest with closeout awareness results."
			reads: [
				"Codex Stop hook payload",
				"Stop awareness results",
				"cue/runtime/hook_manifest.cue",
				"cue/runtime/capture_policy.cue",
			]
			writes: [{
				kind:  "phase_manifest"
				path:  "$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/events/<seq>-stop.cue"
				owner: "state"
			}]
		}

		agent_read_manifests: {
			kind:    "agent_recovery"
			surface: "skill"
			rank:    600
			why:     "Agent reads persisted hook manifests before manual observation."
			reads: [
				"$CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/events/*.cue",
				"$CODEX_HOME/skills/cuerail/SKILL.md",
			]
		}

		agent_mcp_fallback: {
			kind:    "agent_recovery"
			surface: "skill"
			rank:    610
			why:     "Manual MCP fallback is allowed only when persisted hook evidence is missing or insufficient."
			reads: [
				"git MCP server",
				"rg/search MCP server",
			]
			forbids: [
				"shell git fallback",
				"shell rg fallback",
				"repo-git fallback as agent observation",
				"repo-rg fallback as agent observation",
			]
		}

		doctor_validate: {
			kind:    "doctor"
			surface: "doctor"
			rank:    700
			why:     "Validate runtime fixtures, generated schemas, persisted manifests, and source/runtime alignment checks."
			reads: [
				"cue/source/cuerail.manifest.cue",
				"codex/config.toml",
				"codex/skills/cuerail/SKILL.md",
				"test/fixtures/hooks/*.json",
				"$CODEX_STATE/cuerail/turns",
			]
			writes: [{
				kind:  "doctor_check"
				path:  "validation status"
				owner: "doctor"
			}]
		}
	}

	edges: [...#Edge]

	edges: [
		{from: "source_contract", to: "project_config", kind: "projects", why: "config wiring is part of the source-owned contract"},
		{from: "source_contract", to: "project_skill", kind: "projects", why: "skill recovery guidance must match the source-owned contract"},
		{from: "project_config", to: "install_runtime", kind: "installs", why: "Codex reads installed config from CODEX_HOME"},
		{from: "project_skill", to: "install_runtime", kind: "installs", why: "agent reads installed skill from CODEX_HOME"},
		{from: "install_runtime", to: "session_start_awareness", kind: "precedes", why: "Codex can only call hooks after runtime wiring exists"},
		{from: "session_start_awareness", to: "user_prompt_manifest", kind: "precedes", why: "prompt persistence occurs after session startup"},
		{from: "user_prompt_manifest", to: "pretool_awareness", kind: "precedes", why: "tool-use awareness follows the prompt manifest"},
		{from: "pretool_awareness", to: "pretool_gate", kind: "guards", why: "the gate can use current awareness and policy"},
		{from: "pretool_gate", to: "posttool_mcp_manifest", kind: "guards", why: "post-tool persistence follows a gated tool attempt", condition: "tool ran and tool_name is configured for persistence"},
		{from: "posttool_mcp_manifest", to: "stop_awareness", kind: "precedes", why: "stop awareness sees the latest persisted MCP tool evidence"},
		{from: "stop_awareness", to: "stop_manifest", kind: "writes", why: "stop awareness results are included in the stop manifest"},
		{from: "stop_manifest", to: "agent_read_manifests", kind: "reads", why: "agent recovery starts from persisted hook evidence"},
		{from: "agent_read_manifests", to: "agent_mcp_fallback", kind: "falls_back_to", why: "manual MCP is fallback only", condition: "persisted hook evidence is missing or insufficient"},
		{from: "source_contract", to: "doctor_validate", kind: "validates", why: "doctor validates source/runtime shape"},
		{from: "install_runtime", to: "doctor_validate", kind: "validates", why: "doctor checks projected runtime files"},
		{from: "stop_manifest", to: "doctor_validate", kind: "validates", why: "doctor checks persisted manifest production"},
	]

	gates: [string]: #Gate

	gates: {
		no_shell_observation: {
			id:   "no_shell_observation"
			node: "pretool_gate"
			enforces: [
				"repo observation uses MCP",
				"persisted evidence is written as hook manifests when capture policy allows it",
				"shell is allowed for execution and validation, not repo-state discovery",
			]
			denies: [
				"git status via shell",
				"git diff via shell",
				"rg via shell for repo discovery",
				"grep/find via shell for repo discovery",
				"repo-git as agent-facing fallback",
				"repo-rg as agent-facing fallback",
			]
		}

		thin_skill: {
			id:   "thin_skill"
			node: "project_skill"
			enforces: [
				"skill reads persisted hook manifests first",
				"skill uses MCP fallback only when hook evidence is insufficient",
				"skill reports fallback use",
			]
			denies: [
				"agent workflow model",
				"plan model",
				"review-packet process",
				"control inventory authority",
				"shell observation fallback",
			]
		}

		no_system_skill_runtime_authority: {
			id:   "no_system_skill_runtime_authority"
			node: "project_skill"
			enforces: [
				"Cuerail runtime authority is limited to codex/skills/cuerail",
				"codex/skills/.system is outside this DAG and must not be used as Cuerail policy authority",
			]
			denies: [
				"codex/skills/.system as Cuerail runtime authority",
				"OpenAI system skills as Cuerail policy source",
				"broad Codex-home ownership",
			]
		}

		pruning_noop_until_mapped: {
			id:   "pruning_noop_until_mapped"
			node: "source_contract"
			enforces: [
				"pruning is disabled until candidate files map to this DAG",
				"delete candidates must be classified as legacy, fixture, scratch, or unmapped",
			]
			denies: [
				"subjective shell cleanup",
				"runtime deletion without DAG mapping",
			]
		}
	}

	// Validation projections: these make edge/node drift fail CUE evaluation.
	edgeRankChecks: [for edge in edges {
		from: edge.from
		to:   edge.to
		ok:   true & (nodes[edge.from].rank < nodes[edge.to].rank)
	}]

	gateNodeChecks: [for _, gate in gates {
		node: gate.node
		ok:   true & (nodes[gate.node].id == gate.node)
	}]

	acceptance: [
		"cue vet -c=false ./cue/...",
		"all edges reference declared nodes",
		"all nodes have a rank",
		"edges point forward by rank",
		"runtime ownership is limited to config.toml, cuerail-hook, state, and skills/cuerail",
		"persisted hook manifests use $CODEX_STATE/cuerail/turns/<session_id>/<turn_id>/events/*.cue",
		"agent fallback is conditional and MCP-only",
		"pruning remains no-op until file candidates map to the DAG",
	]
}
