package agents

#ControlRole:
	"authority" |
	"controller" |
	"actuator" |
	"adapter" |
	"gate"

#ControlOwner:
	"cue" |
	"shell" |
	"mcp" |
	"markdown" |
	"generated" |
	"codex-native" |
	"external"

#ControlSurface: {
	id:      string
	role:    #ControlRole
	owner:   #ControlOwner
	purpose: string

	paths?: [...string]
	commands?: [...string]
	cueRefs?: [...string]

	mayDecide?: [...string]
	mustNotDecide?: [...string]

	mayWrite?: [...string]
	mustNotWrite?: [...string]

	evidenceProduced?: [...string]
	gatesFed?: [...string]
}

#GateMechanism: {
	id:    string
	owner: #ControlOwner

	command?: string
	cueRef?:  string

	validates: [...string]
	inputs: [...string]
	outputs: [...string]

	failureMeaning: string
}

#ControlInventory: {
	authority: [...#ControlSurface]
	controllers: [...#ControlSurface]
	actuators: [...#ControlSurface]
	adapters: [...#ControlSurface]
	gates: [...#GateMechanism]
	invariants: [...string]
}

#ControlInventory: {
	authority: [
		{
			id:      "agent-contract"
			role:    "authority"
			owner:   "cue"
			purpose: "Migration artifact for the former repo-local agent contract; active policy lives in the Cuerail skill."
			paths: ["cue/agents/agents.cue"]
			cueRefs: ["#AgentContract"]
			mayDecide: ["historical projection shape", "migration validation shape"]
			mustNotDecide: ["active agent policy", "agent constraints", "project constraints", "observation policy"]
		},
		{
			id:      "hook-manifest"
			role:    "authority"
			owner:   "cue"
			purpose: "Hook input, output, awareness, and capture manifest shape."
			paths: ["cue/runtime/hook_manifest.cue"]
			cueRefs: ["#HookManifest"]
			mayDecide: ["hook manifest shape", "hook output projection binding", "capture decision binding"]
		},
		{
			id:      "capture-policy"
			role:    "authority"
			owner:   "cue"
			purpose: "Capture policy and capture decision projection."
			paths: ["cue/runtime/capture_policy.cue"]
			cueRefs: ["#CapturePolicy", "#CaptureDecisionForInput"]
			mayDecide: ["capture policy", "capture persistence", "capture file stem projection"]
		},
		{
			id:      "awareness-plan"
			role:    "authority"
			owner:   "cue"
			purpose: "Read-only awareness plan shape and per-hook planned read projections."
			paths: ["cue/runtime/awareness_plan.cue"]
			cueRefs: ["#AwarenessPlan"]
			mayDecide: ["awareness read plan shape", "planned read selectors"]
		},
		{
			id:      "hook-output-projections"
			role:    "authority"
			owner:   "cue"
			purpose: "Hook output projections against generated Codex hook schemas."
			paths: ["cue/runtime/hook_outputs.cue"]
			mayDecide: ["hook output projection"]
		},
		{
			id:      "schema-sync"
			role:    "authority"
			owner:   "cue"
			purpose: "Schema sync provider selection and expected hook schema set."
			paths: ["cue/sync/schema_sync.cue"]
			cueRefs: ["#SchemaSync", "#ExpectedHookSchemaFiles"]
			mayDecide: ["schema provider ref selection", "expected generated schema files"]
		},
		{
			id:      "schema-lock"
			role:    "authority"
			owner:   "cue"
			purpose: "Schema lock shape for imported upstream hook schemas."
			paths: ["cue/sync/schema_lock.cue"]
			cueRefs: ["#SchemaLock"]
			mayDecide: ["schema lock validation shape"]
		},
		{
			id:      "temporary-shell-adapter-facts"
			role:    "authority"
			owner:   "cue"
			purpose: "Fallback adapter lifecycle and allowed-operation facts."
			paths: ["cue/adapters/temporary_shell.cue"]
			cueRefs: ["#FallbackAdapterFacts", "adapters.temporaryShellAdapters"]
			mayDecide: ["fallback adapter lifecycle facts", "fallback adapter allowed operation facts"]
		},
	]

	controllers: [
		{
			id:      "agent-contract-controller"
			role:    "controller"
			owner:   "cue"
			purpose: "Controls static migration projection for the former repo contract."
			paths: ["cue/agents/agents.cue"]
			cueRefs: ["#AgentContract"]
			mayDecide: ["historical contract projection"]
			mustNotDecide: ["active agent policy"]
		},
		{
			id:      "runtime-hook-controller"
			role:    "controller"
			owner:   "cue"
			purpose: "Controls hook manifest, capture, awareness, and output projections."
			paths: [
				"cue/runtime/hook_manifest.cue",
				"cue/runtime/capture_policy.cue",
				"cue/runtime/awareness_plan.cue",
			]
			cueRefs: ["#HookManifest", "#CapturePolicy", "#AwarenessPlan"]
			mayDecide: ["hook policy and projection"]
		},
		{
			id:      "schema-sync-controller"
			role:    "controller"
			owner:   "cue"
			purpose: "Controls schema sync expectations and lock validation shape."
			paths: ["cue/sync/schema_sync.cue", "cue/sync/schema_lock.cue"]
			cueRefs: ["#SchemaSync", "#SchemaLock"]
			mayDecide: ["schema sync expectations"]
		},
		{
			id:      "adapter-facts-controller"
			role:    "controller"
			owner:   "cue"
			purpose: "Controls fallback adapter lifecycle projection facts."
			paths: ["cue/adapters/*"]
			cueRefs: ["#FallbackAdapterFacts"]
			mayDecide: ["adapter facts projection"]
		},
		{
			id:      "cuerail-hook"
			role:    "controller"
			owner:   "shell"
			purpose: "Sequences hook input wrapping, CUE export, awareness reads, validation, and atomic persistence."
			paths: ["bin/cuerail-hook"]
			commands: ["cuerail-hook"]
			mayDecide: ["filesystem sequencing", "lock acquisition", "atomic publish mechanics"]
			mustNotDecide: ["capture policy", "semantic projection", "hook output policy"]
			gatesFed: ["cuerail-doctor", "cue vet -c=false ./cue/runtime"]
		},
		{
			id:      "cuerail-doctor"
			role:    "controller"
			owner:   "shell"
			purpose: "Sequences source and runtime validation gates."
			paths: ["bin/cuerail-doctor"]
			commands: ["cuerail-doctor", "cuerail-doctor source", "cuerail-doctor runtime"]
			mayDecide: ["gate execution order", "fixture replay mechanics"]
			mustNotDecide: ["schema policy", "capture policy", "adapter lifecycle facts"]
		},
		{
			id:      "cuerail-schema-sync"
			role:    "controller"
			owner:   "shell"
			purpose: "Sequences generated hook schema fetch, import, lock writing, and drift checking."
			paths: ["bin/cuerail-schema-sync"]
			commands: ["cuerail-schema-sync --sync", "cuerail-schema-sync --check"]
			mayDecide: ["download mechanics", "import mechanics", "lock file mechanics"]
			mustNotDecide: ["expected schema set", "schema lock shape", "runtime schema policy"]
		},
		{
			id:      "cuerail-config-schema-sync"
			role:    "controller"
			owner:   "shell"
			purpose: "Sequences Codex config schema fetch, import, lock writing, and drift checking."
			paths: ["bin/cuerail-config-schema-sync"]
			commands: ["cuerail-config-schema-sync --sync", "cuerail-config-schema-sync --check"]
			mayDecide: ["download mechanics", "import mechanics", "lock file mechanics"]
			mustNotDecide: ["config schema URL", "schema lock shape", "runtime config policy"]
		},
	]

	actuators: [
		{
			id:      "cuerail-hook-actuator"
			role:    "actuator"
			owner:   "shell"
			purpose: "Publishes persisted hook manifests approved by CUE."
			paths: ["bin/cuerail-hook"]
			commands: ["cuerail-hook"]
			mayWrite: ["turn event manifests"]
			mustNotWrite: ["CUE source policy", "generated hook schemas"]
		},
		{
			id:      "cuerail-schema-sync-actuator"
			role:    "actuator"
			owner:   "shell"
			purpose: "Writes raw upstream schemas, imported generated CUE schemas, and schema locks during sync."
			paths: ["bin/cuerail-schema-sync"]
			commands: ["cuerail-schema-sync --sync"]
			mayWrite: ["raw hook schemas", "cue/generated/hooks", "schema lock"]
			mustNotWrite: ["runtime behavior", "adapter behavior"]
		},
		{
			id:      "cuerail-config-schema-sync-actuator"
			role:    "actuator"
			owner:   "shell"
			purpose: "Writes raw upstream Codex config schema, imported generated CUE schema, and schema lock during sync."
			paths: ["bin/cuerail-config-schema-sync"]
			commands: ["cuerail-config-schema-sync --sync"]
			mayWrite: ["raw config schema", "cue/generated/config", "config schema lock"]
			mustNotWrite: ["runtime behavior", "adapter behavior"]
		},
		{
			id:      "cuerail-install"
			role:    "actuator"
			owner:   "shell"
			purpose: "Installs or projects Cuerail runtime artifacts."
			paths: ["bin/cuerail-install"]
			commands: ["cuerail-install"]
			mayWrite: ["installation artifacts", "runtime projections"]
		},
		{
			id:      "cuerail-adapter-export"
			role:    "actuator"
			owner:   "shell"
			purpose: "Exports adapter projection artifacts from CUE."
			paths: ["bin/cuerail-adapter-export"]
			commands: ["cuerail-adapter-export"]
			mayWrite: ["adapter projection artifacts"]
			mustNotDecide: ["adapter policy"]
		},
		{
			id:      "cuerail-git-capture"
			role:    "actuator"
			owner:   "shell"
			purpose: "Writes git repository evidence captures."
			paths: ["bin/cuerail-git-capture"]
			commands: ["cuerail-git-capture"]
			mayWrite: ["git evidence captures"]
			evidenceProduced: ["#GitRepoCapture"]
		},
		{
			id:      "cuerail-rg-capture"
			role:    "actuator"
			owner:   "shell"
			purpose: "Writes ripgrep search evidence captures."
			paths: ["bin/cuerail-rg-capture"]
			commands: ["cuerail-rg-capture"]
			mayWrite: ["ripgrep evidence captures"]
			evidenceProduced: ["#RgSearchCapture"]
		},
		{
			id:      "cuerail-mcp-capture"
			role:    "actuator"
			owner:   "shell"
			purpose: "Writes MCP evidence captures."
			paths: ["bin/cuerail-mcp-capture"]
			commands: ["cuerail-mcp-capture"]
			mayWrite: ["MCP evidence captures"]
		},
		{
			id:      "cuerail-review-packet"
			role:    "actuator"
			owner:   "shell"
			purpose: "Emits review packets from available evidence and hook frames."
			paths: ["bin/cuerail-review-packet"]
			commands: ["cuerail-review-packet"]
			evidenceProduced: ["#ReviewPacket"]
		},
		{
			id:      "cuerail-token-usage"
			role:    "actuator"
			owner:   "shell"
			purpose: "Emits token usage evidence."
			paths: ["bin/cuerail-token-usage"]
			commands: ["cuerail-token-usage"]
			evidenceProduced: ["#TokenUsageEvidence"]
		},
		{
			id:      "cuerail-run"
			role:    "actuator"
			owner:   "shell"
			purpose: "Runs Cuerail command surface operations."
			paths: ["bin/cuerail-run"]
			commands: ["cuerail-run"]
		},
		{
			id:      "cuerail-mcp-ripgrep"
			role:    "actuator"
			owner:   "shell"
			purpose: "Launches projected mcp-ripgrep runtime."
			paths: ["bin/cuerail-mcp-ripgrep"]
			commands: ["cuerail-mcp-ripgrep"]
		},
		{
			id:      "cuerail-git-mcp-go"
			role:    "actuator"
			owner:   "shell"
			purpose: "Launches projected git MCP runtime."
			paths: ["bin/cuerail-git-mcp-go"]
			commands: ["cuerail-git-mcp-go"]
		},
		{
			id:      "git-mcp-go-cuerail"
			role:    "actuator"
			owner:   "shell"
			purpose: "Compatibility launch wrapper for projected git MCP runtime."
			paths: ["bin/git-mcp-go-cuerail"]
			commands: ["git-mcp-go-cuerail"]
		},
	]

	adapters: [
		{
			id:      "git-mcp-server"
			role:    "adapter"
			owner:   "mcp"
			purpose: "Only live git adapter for observations and user-requested staging or commits."
			commands: [
				"git-mcp-server.git_status",
				"git-mcp-server.git_diff_staged",
				"git-mcp-server.git_add",
				"git-mcp-server.git_commit",
			]
			cueRefs: ["#GitWorkflowContract"]
			mayWrite: ["git index", "git commits"]
			evidenceProduced: ["raw MCP git observations", "commit result"]
			mustNotWrite: ["repository content outside user-approved staged changes"]
		},
		{
			id:      "mcp-ripgrep"
			role:    "adapter"
			owner:   "mcp"
			purpose: "Only live bounded search adapter."
			commands: ["mcp-ripgrep"]
			evidenceProduced: ["raw MCP ripgrep observations"]
			mustNotWrite: ["repository mutations"]
		},
		{
			id:      "cuerail-mcp-ripgrep-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Wrapper adapter for projected mcp-ripgrep runtime."
			paths: ["bin/cuerail-mcp-ripgrep"]
			commands: ["cuerail-mcp-ripgrep"]
			cueRefs: ["#MCPRipgrepAdapter"]
		},
		{
			id:      "cuerail-git-mcp-go-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Wrapper adapter for projected git MCP runtime."
			paths: ["bin/cuerail-git-mcp-go"]
			commands: ["cuerail-git-mcp-go"]
			cueRefs: ["#GitMCPGoAdapter"]
		},
		{
			id:      "git-mcp-go-cuerail-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Compatibility wrapper adapter for projected git MCP runtime."
			paths: ["bin/git-mcp-go-cuerail"]
			commands: ["git-mcp-go-cuerail"]
			cueRefs: ["#GitMCPGoAdapter"]
		},
		{
			id:      "cuerail-mcp-capture-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Evidence capture adapter for MCP observations."
			paths: ["bin/cuerail-mcp-capture"]
			commands: ["cuerail-mcp-capture"]
			evidenceProduced: ["MCP evidence captures"]
			mustNotDecide: ["evidence schema policy"]
		},
		{
			id:      "cuerail-git-capture-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Evidence capture adapter for git observations."
			paths: ["bin/cuerail-git-capture"]
			commands: ["cuerail-git-capture"]
			evidenceProduced: ["git evidence captures"]
			mustNotDecide: ["evidence schema policy"]
		},
		{
			id:      "cuerail-rg-capture-adapter"
			role:    "adapter"
			owner:   "shell"
			purpose: "Evidence capture adapter for ripgrep observations."
			paths: ["bin/cuerail-rg-capture"]
			commands: ["cuerail-rg-capture"]
			evidenceProduced: ["ripgrep evidence captures"]
			mustNotDecide: ["evidence schema policy"]
		},
		{
			id:      "generated-hook-schemas"
			role:    "adapter"
			owner:   "generated"
			purpose: "Imported upstream Codex hook schemas adapted into CUE."
			paths: ["cue/generated/hooks/*"]
			cueRefs: ["hooks.#SessionStartCommandInput", "hooks.#StopCommandOutput"]
			mayDecide: ["upstream hook shape representation"]
			mustNotDecide: ["Cuerail policy", "capture policy", "agent constraints"]
		},
	]

	gates: [
		{
			id:      "cue-vet-all"
			owner:   "shell"
			command: "cue vet -c=false ./cue/..."
			validates: ["all CUE packages"]
			inputs: ["cue/..."]
			outputs: ["validation status"]
			failureMeaning: "CUE contracts or package constraints are invalid."
		},
		{
			id:      "cue-vet-agents"
			owner:   "shell"
			command: "cue vet -c=false ./cue/agents"
			validates: ["agent contract package", "control inventory package"]
			inputs: ["cue/agents"]
			outputs: ["validation status"]
			failureMeaning: "Agent contract or control inventory constraints are invalid."
		},
		{
			id:      "shell-syntax"
			owner:   "shell"
			command: "sh -n bin/cuerail-* bin/git-mcp-go-cuerail"
			validates: ["shell script syntax"]
			inputs: ["bin/*"]
			outputs: ["validation status"]
			failureMeaning: "At least one shell adapter/controller has invalid shell syntax."
		},
		{
			id:      "schema-sync-check"
			owner:   "shell"
			command: "cuerail-schema-sync --check"
			cueRef:  "#SchemaSync"
			validates: ["generated hook schema availability", "schema lock freshness", "runtime schema package"]
			inputs: ["cue/sync", "cue/runtime", "cue/generated/hooks", "schema lock"]
			outputs: ["validation status"]
			failureMeaning: "Generated hook schemas are missing, stale, or inconsistent with the lock."
		},
		{
			id:      "config-schema-sync-check"
			owner:   "shell"
			command: "cuerail-config-schema-sync --check"
			cueRef:  "#ConfigSchemaSync"
			validates: ["generated config schema availability", "config schema lock freshness"]
			inputs: ["cue/sync", "cue/generated/config", "config schema lock"]
			outputs: ["validation status"]
			failureMeaning: "Generated config schema is missing, stale, or inconsistent with the lock."
		},
		{
			id:      "doctor"
			owner:   "shell"
			command: "cuerail-doctor"
			validates: ["source gates", "fixtures", "evidence projections", "hook manifest persistence"]
			inputs: ["bin", "cue", "test/fixtures"]
			outputs: ["doctor status"]
			failureMeaning: "One or more source validation gates failed."
		},
		{
			id:      "doctor-source"
			owner:   "shell"
			command: "cuerail-doctor source"
			validates: ["source gates", "fixture replay", "CUE exports"]
			inputs: ["bin", "cue", "test/fixtures"]
			outputs: ["doctor source status"]
			failureMeaning: "Source validation failed."
		},
		{
			id:      "doctor-runtime"
			owner:   "shell"
			command: "cuerail-doctor runtime"
			validates: ["runtime wrapper projection", "MCP runtime installation", "Codex MCP config"]
			inputs: ["CODEX_HOME", "CODEX_STATE", "runtime adapter marker"]
			outputs: ["doctor runtime status"]
			failureMeaning: "Runtime installation or MCP configuration is invalid."
		},
		{
			id:      "export-agent-contract"
			owner:   "shell"
			command: "cue export ./cue/agents -e '#AgentContract'"
			cueRef:  "#AgentContract"
			validates: ["agent contract exportability"]
			inputs: ["cue/agents"]
			outputs: ["#AgentContract JSON"]
			failureMeaning: "The agent contract cannot be exported."
		},
		{
			id:      "export-fallback-adapter-facts"
			owner:   "shell"
			command: "cue export ./cue/agents -e '#FallbackAdapterFacts'"
			cueRef:  "#FallbackAdapterFacts"
			validates: ["fallback adapter fact projection exportability"]
			inputs: ["cue/agents", "cue/adapters"]
			outputs: ["#FallbackAdapterFacts JSON"]
			failureMeaning: "Fallback adapter facts cannot be exported."
		},
		{
			id:      "export-control-inventory"
			owner:   "shell"
			command: "cue export ./cue/agents -e '#ControlInventory'"
			cueRef:  "#ControlInventory"
			validates: ["control inventory exportability"]
			inputs: ["cue/agents/control_inventory.cue"]
			outputs: ["#ControlInventory JSON"]
			failureMeaning: "The control inventory cannot be exported."
		},
	]

	invariants: [
		"CUE owns runtime policy, schema, projection, and validation shape.",
		"Active Cuerail agent procedure lives in $CODEX_HOME/skills/cuerail/SKILL.md.",
		"cue/agents is a migration artifact, not active agent authority.",
		"Shell owns mechanics only.",
		"Shell controllers must not decide policy or semantic projection.",
		"MCP is required for repo git and search observations.",
		"git-mcp-server is the only surface for user-requested staging and commits.",
		"repo-git and repo-rg are not agent observation surfaces.",
		"Generated schemas are adapter inputs, not policy authority.",
		"Markdown is a bootstrap pointer only.",
		"Gate runner may be shell-driven, but gate expectations should be CUE-described.",
	]
}
