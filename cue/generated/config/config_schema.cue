// ConfigToml
//
// Base config deserialized from ~/.codex/config.toml.
package config

import "strings"

#ConfigToml: {
	@jsonschema(schema="http://json-schema.org/draft-07/schema#")

	close({
		// Agent-related settings (thread limits, etc.).
		agents?: #AgentsToml

		// Whether the model may request a login shell for shell-based
		// tools. Default to `true`
		//
		// If `true`, the model may request a login shell (`login =
		// true`), and omitting `login` defaults to using a login shell.
		// If `false`, the model can never use a login shell: `login =
		// true` requests are rejected, and omitting `login` defaults to
		// a non-login shell.
		allow_login_shell?: bool

		// When `false`, disables analytics across Codex product surfaces
		// in this machine. Defaults to `true`.
		analytics?: #AnalyticsConfigToml

		// Default approval policy for executing commands.
		approval_policy?: #AskForApproval

		// Configures who approval requests are routed to for review once
		// they have been escalated. This does not disable separate
		// safety checks such as ARC.
		approvals_reviewer?: #ApprovalsReviewer

		// Settings for app-specific controls.
		apps?: #AppsConfigToml

		// Optional product SKU forwarded on host-owned Codex Apps MCP
		// requests.
		apps_mcp_product_sku?: string

		// Machine-local realtime audio device preferences used by
		// realtime voice.
		audio?: #RealtimeAudioToml

		// Optional policy instructions for the guardian auto-reviewer.
		auto_review?: #AutoReviewToml

		// Maximum poll window for background terminal output
		// (`write_stdin`), in milliseconds. Default: `300000` (5
		// minutes).
		background_terminal_max_timeout?: int & >=0.0

		// Base URL for requests to ChatGPT (as opposed to the OpenAI
		// API).
		chatgpt_base_url?: string

		// When `true`, checks for Codex updates on startup and surfaces
		// update prompts. Set to `false` only if your Codex updates are
		// centrally managed. Defaults to `true`.
		check_for_update_on_startup?: bool

		// Preferred backend for storing CLI auth credentials. file
		// (default): Use a file in the Codex home directory. keyring:
		// Use an OS-specific keyring service. auto: Use the keyring if
		// available, otherwise use a file.
		cli_auth_credentials_store?: #AuthCredentialsStoreMode

		// Compact prompt used for history compaction.
		compact_prompt?: string

		// Debugging and reproducibility settings.
		debug?: #DebugToml

		// Default permissions profile to apply. Names starting with `:`
		// refer to built-in profiles; other names are resolved from the
		// `[permissions]` table.
		default_permissions?: string

		// Opaque desktop settings stored alongside the rest of
		// config.toml.
		desktop?: {
			...
		}

		// Developer instructions inserted as a `developer` role message.
		developer_instructions?: string

		// When true, disables burst-paste detection for typed input
		// entirely. All characters are inserted as they are received,
		// and no buffering or placeholder replacement will occur for
		// fast keypress bursts.
		disable_paste_burst?:              bool
		experimental_compact_prompt_file?: #AbsolutePathBuf

		// Experimental / do not use. Replaces the built-in realtime start
		// instructions inserted into developer messages when realtime
		// becomes active.
		experimental_realtime_start_instructions?: string

		// Experimental / do not use. Overrides only the realtime
		// conversation websocket transport instructions (the
		// `Op::RealtimeConversation` `/ws` session.update instructions)
		// without changing normal prompts.
		experimental_realtime_ws_backend_prompt?: string

		// Experimental / do not use. Overrides only the realtime
		// conversation websocket transport base URL (the
		// `Op::RealtimeConversation` `/v1/realtime` connection) without
		// changing normal provider HTTP requests.
		experimental_realtime_ws_base_url?: string

		// Experimental / do not use. Selects the realtime websocket
		// model/snapshot used for the `Op::RealtimeConversation`
		// connection.
		experimental_realtime_ws_model?: string

		// Experimental / do not use. Replaces the synthesized realtime
		// startup context appended to websocket session instructions. An
		// empty string disables startup context injection entirely.
		experimental_realtime_ws_startup_context?: string

		// Experimental / do not use. When set, app-server fetches
		// thread-scoped config from a remote service at this endpoint.
		experimental_thread_config_endpoint?: string

		// Experimental / do not use. Selects the thread store
		// implementation.
		experimental_thread_store?:          #ThreadStoreToml
		experimental_use_unified_exec_tool?: bool

		// Centralized feature flags (new). Prefer this over individual
		// toggles.
		features?: close({
			apply_patch_freeform?:                   bool
			apply_patch_streaming_events?:           bool
			apps?:                                   bool
			apps_mcp_path_override?:                 #FeatureToml_for_AppsMcpPathOverrideConfigToml
			auth_elicitation?:                       bool
			browser_use?:                            bool
			browser_use_external?:                   bool
			child_agents_md?:                        bool
			chronicle?:                              bool
			code_mode?:                              bool
			code_mode_only?:                         bool
			codex_git_commit?:                       bool
			codex_hooks?:                            bool
			collab?:                                 bool
			collaboration_modes?:                    bool
			computer_use?:                           bool
			connectors?:                             bool
			default_mode_request_user_input?:        bool
			elevated_windows_sandbox?:               bool
			enable_experimental_windows_sandbox?:    bool
			enable_fanout?:                          bool
			enable_mcp_apps?:                        bool
			enable_request_compression?:             bool
			exec_permission_approvals?:              bool
			experimental_use_unified_exec_tool?:     bool
			experimental_windows_sandbox?:           bool
			external_migration?:                     bool
			fast_mode?:                              bool
			goals?:                                  bool
			guardian_approval?:                      bool
			hooks?:                                  bool
			image_detail_original?:                  bool
			image_generation?:                       bool
			in_app_browser?:                         bool
			js_repl?:                                bool
			js_repl_tools_only?:                     bool
			memories?:                               bool
			memory_tool?:                            bool
			mentions_v2?:                            bool
			multi_agent?:                            bool
			multi_agent_v2?:                         #FeatureToml_for_MultiAgentV2ConfigToml
			network_proxy?:                          #FeatureToml_for_NetworkProxyConfigToml
			personality?:                            bool
			plugin_hooks?:                           bool
			plugin_sharing?:                         bool
			plugins?:                                bool
			prevent_idle_sleep?:                     bool
			realtime_conversation?:                  bool
			remote_compaction_v2?:                   bool
			remote_control?:                         bool
			remote_models?:                          bool
			remote_plugin?:                          bool
			request_permissions?:                    bool
			request_permissions_tool?:               bool
			request_rule?:                           bool
			responses_websocket_response_processed?: bool
			responses_websockets?:                   bool
			responses_websockets_v2?:                bool
			runtime_metrics?:                        bool
			search_tool?:                            bool
			shell_snapshot?:                         bool
			shell_tool?:                             bool
			shell_zsh_fork?:                         bool
			skill_env_var_dependency_prompt?:        bool
			skill_mcp_dependency_install?:           bool
			sqlite?:                                 bool
			steer?:                                  bool
			telepathy?:                              bool
			terminal_resize_reflow?:                 bool
			tool_call_mcp_elicitation?:              bool
			tool_search?:                            bool
			tool_search_always_defer_mcp_tools?:     bool
			tool_suggest?:                           bool
			tui_app_server?:                         bool
			unavailable_dummy_tools?:                bool
			undo?:                                   bool
			unified_exec?:                           bool
			use_legacy_landlock?:                    bool
			use_linux_sandbox_bwrap?:                bool
			web_search?:                             bool
			web_search_cached?:                      bool
			web_search_request?:                     bool
			workspace_dependencies?:                 bool
			workspace_owner_usage_nudge?:            bool
		})

		// When `false`, disables feedback collection across Codex product
		// surfaces. Defaults to `true`.
		feedback?: #FeedbackConfigToml

		// Optional URI-based file opener. If set, citations to files in
		// the model output will be hyperlinked using the specified URI
		// scheme.
		file_opener?: #UriBasedFileOpener

		// When set, restricts ChatGPT login to one or more workspace
		// identifiers.
		forced_chatgpt_workspace_id?: #ForcedChatgptWorkspaceIds

		// When set, restricts the login mechanism users may use.
		forced_login_method?: #ForcedLoginMethod

		// Compatibility-only settings retained so legacy `ghost_snapshot`
		// config still loads.
		ghost_snapshot?: #GhostSnapshotToml

		// When set to `true`, `AgentReasoning` events will be hidden from
		// the UI/output. Defaults to `false`.
		hide_agent_reasoning?: bool

		// Settings that govern if and what will be written to
		// `~/.codex/history.jsonl`.
		history?: #History

		// Lifecycle hooks configured inline in TOML plus user-level
		// overrides.
		hooks?: #HooksToml

		// Whether to inject the `<apps_instructions>` developer block.
		include_apps_instructions?: bool

		// Whether to inject the `<collaboration_mode>` developer block.
		include_collaboration_mode_instructions?: bool

		// Whether to inject the `<environment_context>` user block.
		include_environment_context?: bool

		// Whether to inject the `<permissions instructions>` developer
		// block.
		include_permissions_instructions?: bool

		// System instructions.
		instructions?: string

		// Directory where Codex writes log files, for example
		// `codex-tui.log`. Defaults to `$CODEX_HOME/log`.
		log_dir?: #AbsolutePathBuf

		// User-level marketplace entries keyed by marketplace name.
		marketplaces?: [string]: #MarketplaceConfig

		// Optional fixed port for the local HTTP callback server used
		// during MCP OAuth login. When unset, Codex will bind to an
		// ephemeral port chosen by the OS.
		mcp_oauth_callback_port?: int & >=0.0

		// Optional redirect URI to use during MCP OAuth login. When set,
		// this URI is used in the OAuth authorization request instead of
		// the local listener address. The local callback listener still
		// binds to 127.0.0.1 (using `mcp_oauth_callback_port` when
		// provided).
		mcp_oauth_callback_url?: string

		// Preferred backend for storing MCP OAuth credentials. keyring:
		// Use an OS-specific keyring service.
		// https://github.com/openai/codex/blob/main/codex-rs/rmcp-client/src/oauth.rs#L2
		// file: Use a file in the Codex home directory. auto (default):
		// Use the OS-specific keyring service if available, otherwise
		// use a file.
		mcp_oauth_credentials_store?: #OAuthCredentialsStoreMode

		// Definition for MCP servers that Codex can reach out to for tool
		// calls.
		mcp_servers?: [string]: #RawMcpServerConfig

		// Memories subsystem settings.
		memories?: #MemoriesToml

		// Optional override of model selection.
		model?: string

		// Token usage threshold triggering auto-compaction of
		// conversation history.
		model_auto_compact_token_limit?: int

		// Controls whether the auto-compaction limit applies to the full
		// context or only to tokens after the carried prefix in the
		// current compaction window.
		model_auto_compact_token_limit_scope?: #AutoCompactTokenLimitScope

		// Optional path to a JSON model catalog (applied on startup
		// only). Per-thread `config` overrides are accepted but do not
		// reapply this (no-ops).
		model_catalog_json?: #AbsolutePathBuf

		// Size of the context window for the model, in tokens.
		model_context_window?: int

		// Optional path to a file containing model instructions that will
		// override the built-in instructions for the selected model.
		// Users are STRONGLY DISCOURAGED from using this field, as
		// deviating from the instructions sanctioned by Codex will
		// likely degrade model performance.
		model_instructions_file?: #AbsolutePathBuf

		// Provider to use from the model_providers map.
		model_provider?: string

		// User-defined provider entries that extend the built-in list.
		// Built-in IDs cannot be overridden.
		model_providers?: [string]: #ModelProviderInfo
		model_reasoning_effort?:  #ReasoningEffort
		model_reasoning_summary?: #ReasoningSummary

		// Override to force-enable reasoning summaries for the configured
		// model.
		model_supports_reasoning_summaries?: bool

		// Optional verbosity control for GPT-5 models (Responses API
		// `text.verbosity`).
		model_verbosity?: #Verbosity

		// Collection of in-product notices (different from notifications)
		// See [`crate::types::Notice`] for more details
		notice?: #Notice

		// Optional external command to spawn for end-user notifications.
		notify?: [...string]

		// Base URL override for the built-in `openai` model provider.
		openai_base_url?: string

		// Preferred OSS provider for local models, e.g. "lmstudio" or
		// "ollama".
		oss_provider?: string

		// OTEL configuration.
		otel?: #OtelConfigToml

		// Named permissions profiles.
		permissions?: #PermissionsToml

		// Optionally specify a personality for the model
		personality?:                #Personality
		plan_mode_reasoning_effort?: #ReasoningEffort

		// User-level plugin config entries keyed by plugin name.
		plugins?: [string]: #PluginConfig

		// Profile to use from the `profiles` map.
		profile?: string

		// Named profiles to facilitate switching between different
		// configurations.
		profiles?: [string]: #ConfigProfile

		// Ordered list of fallback filenames to look for when AGENTS.md
		// is missing.
		project_doc_fallback_filenames?: [...string]

		// Maximum number of bytes to include from an AGENTS.md project
		// doc file.
		project_doc_max_bytes?: int & >=0.0

		// Markers used to detect the project root when searching parent
		// directories for `.codex` folders. Defaults to [".git"] when
		// unset.
		project_root_markers?: [...string]
		projects?: [string]: #ProjectConfig

		// Experimental / do not use. Realtime websocket session
		// selection. `version` controls v1/v2 and `type` controls
		// conversational/transcription.
		realtime?: #RealtimeToml

		// Review model override used by the `/review` feature.
		review_model?: string

		// Sandbox mode to use.
		sandbox_mode?: #SandboxMode

		// Sandbox configuration to apply if `sandbox` is
		// `WorkspaceWrite`.
		sandbox_workspace_write?: #SandboxWorkspaceWrite

		// Optional explicit service tier request id for new turns (for
		// example `default`, `priority`, or `flex`; legacy `fast` also
		// works).
		service_tier?:             string
		shell_environment_policy?: #ShellEnvironmentPolicyToml

		// When set to `true`, `AgentReasoningRawContentEvent` events will
		// be shown in the UI/output. Defaults to `false`.
		show_raw_agent_reasoning?: bool

		// User-level skill config entries keyed by SKILL.md path.
		skills?: #SkillsConfig

		// Directory where Codex stores the SQLite state DB. Defaults to
		// `$CODEX_SQLITE_HOME` when set. Otherwise uses `$CODEX_HOME`.
		sqlite_home?: #AbsolutePathBuf

		// Suppress warnings about unstable (under development) features.
		suppress_unstable_features_warning?: bool

		// Token budget applied when storing tool/function outputs in the
		// context manager.
		tool_output_token_limit?: int & >=0.0

		// Additional discoverable tools that can be suggested for
		// installation.
		tool_suggest?: #ToolSuggestConfig

		// Nested tools section for feature toggles
		tools?: #ToolsToml

		// Collection of settings that are specific to the TUI.
		tui?: #Tui

		// Controls the web search tool mode: disabled, cached, or live.
		web_search?: #WebSearchMode

		// Windows-specific configuration.
		windows?: #WindowsToml

		// Optional absolute path to patched zsh used by
		// zsh-exec-bridge-backed shell execution.
		zsh_path?: #AbsolutePathBuf
	})

	// A path that is guaranteed to be absolute and normalized (though
	// it is not guaranteed to be canonicalized or exist on the
	// filesystem).
	//
	// IMPORTANT: When deserializing an `AbsolutePathBuf`, a base path
	// must be set using [AbsolutePathBufGuard::new]. If no base path
	// is set, the deserialization will fail unless the path being
	// deserialized is already absolute.
	#AbsolutePathBuf: string

	#AgentRoleToml: close({
		// Path to a role-specific config layer. Relative paths are
		// resolved relative to the `config.toml` that defines them.
		config_file?: #AbsolutePathBuf

		// Human-facing role documentation used in spawn tool guidance.
		// Required unless supplied by the referenced agent role file.
		description?: string

		// Candidate nicknames for agents spawned with this role.
		nickname_candidates?: [...string]
	})

	#AgentsToml: {
		// Whether to record a model-visible message when an agent turn is
		// interrupted. Defaults to true.
		interrupt_message?: bool

		// Default maximum runtime in seconds for agent job workers.
		job_max_runtime_seconds?: int & >=1.0

		// Maximum nesting depth allowed for spawned agent threads. Root
		// sessions start at depth 0.
		max_depth?: int & >=1.0

		// Maximum number of agent threads that can be open concurrently.
		// When unset, no limit is enforced.
		max_threads?: int & >=1.0
		{[!~"^(interrupt_message|job_max_runtime_seconds|max_depth|max_threads)$"]: #AgentRoleToml}
	}

	// Controls whether the TUI uses the terminal's alternate screen
	// buffer.
	//
	// - `auto` (default): Use alternate screen mode. - `always`:
	// Always use alternate screen mode. - `never`: Never use
	// alternate screen mode. Runs in inline mode, preserving
	// scrollback.
	//
	// The CLI flag `--no-alt-screen` can override this setting at
	// runtime.
	#AltScreenMode: matchN(1, ["auto", "always", "never"])

	// Analytics settings loaded from config.toml. Fields are optional
	// so we can apply defaults.
	#AnalyticsConfigToml: close({
		// When `false`, disables analytics across Codex product surfaces
		// in this profile.
		enabled?: bool
	})

	// Config values for a single app/connector.
	#AppConfig: close({
		// Approval mode for tools in this app unless a tool override
		// exists.
		default_tools_approval_mode?: #AppToolApproval

		// Whether tools are enabled by default for this app.
		default_tools_enabled?: bool

		// Whether tools with `destructive_hint = true` are allowed for
		// this app.
		destructive_enabled?: bool

		// When `false`, Codex does not surface this app.
		enabled?: bool

		// Whether tools with `open_world_hint = true` are allowed for
		// this app.
		open_world_enabled?: bool

		// Per-tool settings for this app.
		tools?: #AppToolsConfig
	})

	#AppToolApproval: "auto" | "prompt" | "approve"

	// Per-tool settings for a single app tool.
	#AppToolConfig: close({
		// Approval mode for this tool.
		approval_mode?: #AppToolApproval

		// Whether this tool is enabled. `Some(true)` explicitly allows
		// this tool.
		enabled?: bool
	})

	// Tool settings for a single app.
	#AppToolsConfig: [string]: #AppToolConfig

	// Configures who approval requests are routed to for review.
	// Examples include sandbox escapes, blocked network access, MCP
	// approval prompts, and ARC escalations. Defaults to `user`.
	// `auto_review` uses a carefully prompted subagent to gather
	// relevant context and apply a risk-based decision framework
	// before approving or denying the request. The legacy value
	// `guardian_subagent` is accepted for compatibility.
	#ApprovalsReviewer: "user" | "auto_review" | "guardian_subagent"

	// App/connector settings loaded from `config.toml`.
	#AppsConfigToml: {
		// Default settings for all apps.
		"_default"?: #AppsDefaultConfig
		{[!~"^(_default)$"]: #AppConfig}
	}

	// Default settings that apply to all apps.
	#AppsDefaultConfig: close({
		// Whether tools with `destructive_hint = true` are allowed by
		// default.
		destructive_enabled?: bool

		// When `false`, apps are disabled unless overridden by per-app
		// settings.
		enabled?: bool

		// Whether tools with `open_world_hint = true` are allowed by
		// default.
		open_world_enabled?: bool
	})

	#AppsMcpPathOverrideConfigToml: close({
		enabled?: bool
		path?:    string
	})

	// Determines the conditions under which the user is consulted to
	// approve running the command proposed by Codex.
	#AskForApproval: matchN(1, ["untrusted", "on-failure", "on-request", close({
		granular!: #GranularApprovalConfig
	}), "never"])

	// Determine where Codex should store CLI auth credentials.
	#AuthCredentialsStoreMode: matchN(1, ["file", "keyring", "auto", "ephemeral"])

	// Selects which part of the active context is charged against
	// `model_auto_compact_token_limit`.
	#AutoCompactTokenLimitScope: matchN(1, ["total", "body_after_prefix"])

	#AutoReviewToml: {
		// Additional policy instructions inserted into the guardian
		// prompt.
		policy?: string
		...
	}

	#BundledSkillsConfig: close({
		enabled?: bool
	})

	// Collection of common configuration options that a user can
	// define as a unit in `config.toml`.
	#ConfigProfile: close({
		analytics?:                          #AnalyticsConfigToml
		approval_policy?:                    #AskForApproval
		approvals_reviewer?:                 #ApprovalsReviewer
		chatgpt_base_url?:                   string
		experimental_compact_prompt_file?:   #AbsolutePathBuf
		experimental_use_unified_exec_tool?: bool

		// Optional feature toggles scoped to this profile.
		features?: close({
			apply_patch_freeform?:                   bool
			apply_patch_streaming_events?:           bool
			apps?:                                   bool
			apps_mcp_path_override?:                 #FeatureToml_for_AppsMcpPathOverrideConfigToml
			auth_elicitation?:                       bool
			browser_use?:                            bool
			browser_use_external?:                   bool
			child_agents_md?:                        bool
			chronicle?:                              bool
			code_mode?:                              bool
			code_mode_only?:                         bool
			codex_git_commit?:                       bool
			codex_hooks?:                            bool
			collab?:                                 bool
			collaboration_modes?:                    bool
			computer_use?:                           bool
			connectors?:                             bool
			default_mode_request_user_input?:        bool
			elevated_windows_sandbox?:               bool
			enable_experimental_windows_sandbox?:    bool
			enable_fanout?:                          bool
			enable_mcp_apps?:                        bool
			enable_request_compression?:             bool
			exec_permission_approvals?:              bool
			experimental_use_unified_exec_tool?:     bool
			experimental_windows_sandbox?:           bool
			external_migration?:                     bool
			fast_mode?:                              bool
			goals?:                                  bool
			guardian_approval?:                      bool
			hooks?:                                  bool
			image_detail_original?:                  bool
			image_generation?:                       bool
			in_app_browser?:                         bool
			js_repl?:                                bool
			js_repl_tools_only?:                     bool
			memories?:                               bool
			memory_tool?:                            bool
			mentions_v2?:                            bool
			multi_agent?:                            bool
			multi_agent_v2?:                         #FeatureToml_for_MultiAgentV2ConfigToml
			network_proxy?:                          #FeatureToml_for_NetworkProxyConfigToml
			personality?:                            bool
			plugin_hooks?:                           bool
			plugin_sharing?:                         bool
			plugins?:                                bool
			prevent_idle_sleep?:                     bool
			realtime_conversation?:                  bool
			remote_compaction_v2?:                   bool
			remote_control?:                         bool
			remote_models?:                          bool
			remote_plugin?:                          bool
			request_permissions?:                    bool
			request_permissions_tool?:               bool
			request_rule?:                           bool
			responses_websocket_response_processed?: bool
			responses_websockets?:                   bool
			responses_websockets_v2?:                bool
			runtime_metrics?:                        bool
			search_tool?:                            bool
			shell_snapshot?:                         bool
			shell_tool?:                             bool
			shell_zsh_fork?:                         bool
			skill_env_var_dependency_prompt?:        bool
			skill_mcp_dependency_install?:           bool
			sqlite?:                                 bool
			steer?:                                  bool
			telepathy?:                              bool
			terminal_resize_reflow?:                 bool
			tool_call_mcp_elicitation?:              bool
			tool_search?:                            bool
			tool_search_always_defer_mcp_tools?:     bool
			tool_suggest?:                           bool
			tui_app_server?:                         bool
			unavailable_dummy_tools?:                bool
			undo?:                                   bool
			unified_exec?:                           bool
			use_legacy_landlock?:                    bool
			use_linux_sandbox_bwrap?:                bool
			web_search?:                             bool
			web_search_cached?:                      bool
			web_search_request?:                     bool
			workspace_dependencies?:                 bool
			workspace_owner_usage_nudge?:            bool
		})
		include_apps_instructions?:               bool
		include_collaboration_mode_instructions?: bool
		include_environment_context?:             bool
		include_permissions_instructions?:        bool
		model?:                                   string

		// Optional path to a JSON model catalog (applied on startup
		// only).
		model_catalog_json?: #AbsolutePathBuf

		// Optional path to a file containing model instructions.
		model_instructions_file?: #AbsolutePathBuf

		// The key in the `model_providers` map identifying the
		// [`ModelProviderInfo`] to use.
		model_provider?:             string
		model_reasoning_effort?:     #ReasoningEffort
		model_reasoning_summary?:    #ReasoningSummary
		model_verbosity?:            #Verbosity
		oss_provider?:               string
		personality?:                #Personality
		plan_mode_reasoning_effort?: #ReasoningEffort
		sandbox_mode?:               #SandboxMode

		// Optional explicit service tier request id for new turns (for
		// example `default`, `priority`, or `flex`; legacy `fast` also
		// works).
		service_tier?: string
		tools?:        #ToolsToml

		// TUI settings scoped to this profile.
		tui?:        #ProfileTui
		web_search?: #WebSearchMode
		windows?:    #WindowsToml

		// Optional absolute path to patched zsh used by
		// zsh-exec-bridge-backed shell execution.
		zsh_path?: #AbsolutePathBuf
	})

	#DebugConfigLockToml: close({
		// Allow replaying a lock generated by a different Codex version.
		allow_codex_version_mismatch?: bool

		// Directory where Codex writes effective session config lock
		// files.
		export_dir?: #AbsolutePathBuf

		// Lockfile to replay as the authoritative effective config.
		load_path?: #AbsolutePathBuf

		// Save fields resolved from the model catalog/session
		// configuration.
		save_fields_resolved_from_model_catalog?: bool
	})

	#DebugToml: close({
		config_lockfile?: #DebugConfigLockToml
	})

	// Settings for notices we display to users via the tui and
	// app-server clients (primarily the Codex IDE extension). NOTE:
	// these are different from notifications - notices are warnings,
	// NUX screens, acknowledgements, etc.
	#ExternalConfigMigrationPrompts: close({
		// Tracks whether home-level external config migration prompts are
		// hidden.
		home?: bool

		// Tracks the last time the home-level external config migration
		// prompt was shown.
		home_last_prompted_at?: int

		// Tracks the last time a project-level external config migration
		// prompt was shown.
		project_last_prompted_at?: [string]: int

		// Tracks which project paths have opted out of external config
		// migration prompts.
		projects?: [string]: bool
	})

	#FeatureToml_for_AppsMcpPathOverrideConfigToml: matchN(>=1, [bool, #AppsMcpPathOverrideConfigToml])

	#FeatureToml_for_MultiAgentV2ConfigToml: matchN(>=1, [bool, #MultiAgentV2ConfigToml])

	#FeatureToml_for_NetworkProxyConfigToml: matchN(>=1, [bool, #NetworkProxyConfigToml])

	#FeedbackConfigToml: close({
		// When `false`, disables the feedback flow across Codex product
		// surfaces.
		enabled?: bool
	})

	// Access mode for a filesystem entry.
	//
	// When two equally specific entries target the same path, we
	// compare these by conflict precedence rather than by capability
	// breadth: `deny` beats `write`, and `write` beats `read`.
	#FileSystemAccessMode: matchN(1, ["read" | "write", "deny"])

	#FilesystemPermissionToml: matchN(>=1, [#FileSystemAccessMode, {
		[string]: #FileSystemAccessMode
	}])

	#FilesystemPermissionsToml: {
		// Optional maximum depth for expanding unreadable glob patterns
		// on platforms that snapshot glob matches before sandbox
		// startup.
		glob_scan_max_depth?: int & >=1.0
		...
	}

	// Backward-compatible shape for ChatGPT workspace login
	// restrictions in config.toml.
	#ForcedChatgptWorkspaceIds: matchN(>=1, [string, [...string]])

	#ForcedLoginMethod: "chatgpt" | "api"

	#GhostSnapshotToml: close({
		// Legacy no-op setting retained for compatibility.
		disable_warnings?: bool

		// Legacy no-op setting retained for compatibility.
		ignore_large_untracked_dirs?: int

		// Legacy no-op setting retained for compatibility.
		ignore_large_untracked_files?: int
	})

	#GranularApprovalConfig: {
		// Whether to allow MCP elicitation prompts.
		mcp_elicitations!: bool

		// Whether to allow prompts triggered by the `request_permissions`
		// tool.
		request_permissions?: bool

		// Whether to allow prompts triggered by execpolicy `prompt`
		// rules.
		rules!: bool

		// Whether to allow shell command approval requests, including
		// inline `with_additional_permissions` and `require_escalated`
		// requests.
		sandbox_approval!: bool

		// Whether to allow approval prompts triggered by skill script
		// execution.
		skill_approval?: bool
		...
	}

	// Settings that govern if and what will be written to
	// `~/.codex/history.jsonl`.
	#History: close({
		// If set, the maximum size of the history file in bytes. The
		// oldest entries are dropped once the file exceeds this limit.
		max_bytes?: int & >=0.0

		// If true, history entries will not be written to disk.
		persistence?: #HistoryPersistence
	})

	#HistoryPersistence: matchN(1, ["save-all", "none"])

	#HookHandlerConfig: matchN(1, [{
		async?:          bool
		command!:        string
		commandWindows?: string
		statusMessage?:  string
		timeout?:        int & >=0.0
		type!:           "command"
		...
	}, {
		type!: "prompt"
		...
	}, {
		type!: "agent"
		...
	}])

	#HookStateToml: {
		enabled?:      bool
		trusted_hash?: string
		...
	}

	#HooksToml: {
		PermissionRequest?: [...#MatcherGroup]
		PostCompact?: [...#MatcherGroup]
		PostToolUse?: [...#MatcherGroup]
		PreCompact?: [...#MatcherGroup]
		PreToolUse?: [...#MatcherGroup]
		SessionStart?: [...#MatcherGroup]
		Stop?: [...#MatcherGroup]
		SubagentStart?: [...#MatcherGroup]
		SubagentStop?: [...#MatcherGroup]
		UserPromptSubmit?: [...#MatcherGroup]
		state?: [string]: #HookStateToml
		...
	}

	// One action binding value in config.
	//
	// This accepts either:
	//
	// 1. A single key spec string (`"ctrl-a"`). 2. A list of key spec
	// strings (`["ctrl-a", "alt-a"]`).
	//
	// An empty list explicitly unbinds the action in that scope.
	// Because an explicit empty list is still a configured value,
	// runtime resolution must not fall through to global or built-in
	// defaults for that action.
	#KeybindingsSpec: matchN(>=1, [string, [...string]])

	#MarketplaceConfig: close({
		// Git revision Codex last successfully activated for this
		// marketplace.
		last_revision?: string

		// Last time Codex successfully added or refreshed this
		// marketplace.
		last_updated?: string

		// Git ref to check out when `source_type` is `git`.
		ref?: string

		// Source location used when the marketplace was added.
		source?: string

		// Source kind used to install this marketplace.
		source_type?: #MarketplaceSourceType

		// Sparse checkout paths used when `source_type` is `git`.
		sparse_paths?: [...string]
	})

	#MarketplaceSourceType: "git" | "local"

	#MatcherGroup: {
		hooks?: [...#HookHandlerConfig]
		matcher?: string
		...
	}

	#McpServerEnvVar: matchN(>=1, [string, close({
		name!:   string
		source?: string
	})])

	// OAuth client settings used when Codex launches an MCP OAuth
	// flow.
	#McpServerOAuthConfig: close({
		// Explicit OAuth client identifier to present during
		// authorization and token exchange.
		client_id?: string
	})

	// Per-tool approval settings for a single MCP server tool.
	#McpServerToolConfig: close({
		// Approval mode for this tool.
		approval_mode?: #AppToolApproval
	})

	// Memories settings loaded from config.toml.
	#MemoriesToml: close({
		// Model used for memory consolidation.
		consolidation_model?: string

		// When `true`, external context sources mark the thread
		// `memory_mode` as `"polluted"`.
		disable_on_external_context?: bool

		// Model used for thread summarisation.
		extract_model?: string

		// When `false`, newly created threads are stored with
		// `memory_mode = "disabled"` in the state DB.
		generate_memories?: bool

		// Maximum number of recent raw memories retained for global
		// consolidation.
		max_raw_memories_for_consolidation?: int & <=4096.0 & >=1.0

		// Maximum age of the threads used for memories.
		max_rollout_age_days?: int

		// Maximum number of rollout candidates processed per pass.
		max_rollouts_per_startup?: int & <=128.0 & >=1.0

		// Maximum number of days since a memory was last used before it
		// becomes ineligible for phase 2 selection.
		max_unused_days?: int

		// Minimum remaining percentage required in Codex rate-limit
		// windows before memory startup runs.
		min_rate_limit_remaining_percent?: int & <=100.0 & >=0.0

		// Minimum idle time between last thread activity and memory
		// creation (hours). > 12h recommended.
		min_rollout_idle_hours?: int

		// When `false`, skip injecting memory usage instructions into
		// developer prompts.
		use_memories?: bool
	})

	#ModelAvailabilityNuxConfig: [string]: int & >=0.0

	// Configuration for obtaining a provider bearer token from a
	// command.
	#ModelProviderAuthInfo: close({
		// Command arguments.
		args?: [...string]

		// Command to execute. Bare names are resolved via `PATH`; paths
		// are resolved against `cwd`.
		command!: string

		// Working directory used when running the token command.
		cwd?: #AbsolutePathBuf

		// Maximum age for the cached token before rerunning the command.
		// Set to `0` to disable proactive refresh and only rerun after a
		// 401 retry path.
		refresh_interval_ms?: int & >=0.0

		// Maximum time to wait for the token command to exit
		// successfully.
		timeout_ms?: int & >=1.0
	})

	// AWS SigV4 auth configuration for a model provider.
	#ModelProviderAwsAuthInfo: close({
		// AWS profile name to use. When unset, the AWS SDK default chain
		// decides.
		profile?: string

		// AWS region to use for provider-specific endpoints.
		region?: string
	})

	// Serializable representation of a provider definition.
	#ModelProviderInfo: close({
		// Command-backed bearer-token configuration for this provider.
		auth?: #ModelProviderAuthInfo

		// AWS SigV4 auth configuration for this provider.
		aws?: #ModelProviderAwsAuthInfo

		// Base URL for the provider's OpenAI-compatible API.
		base_url?: string

		// Optional HTTP headers to include in requests to this provider
		// where the (key, value) pairs are the header name and
		// _environment variable_ whose value should be used. If the
		// environment variable is not set, or the value is empty, the
		// header will not be included in the request.
		env_http_headers?: [string]: string

		// Environment variable that stores the user's API key for this
		// provider.
		env_key?: string

		// Optional instructions to help the user get a valid value for
		// the variable and set it.
		env_key_instructions?: string

		// Value to use with `Authorization: Bearer <token>` header. Use
		// of this config is discouraged in favor of `env_key` for
		// security reasons, but this may be necessary when using this
		// programmatically.
		experimental_bearer_token?: string

		// Additional HTTP headers to include in requests to this provider
		// where the (key, value) pairs are the header name and value.
		http_headers?: [string]: string

		// Friendly display name.
		name?: string

		// Optional query parameters to append to the base URL.
		query_params?: [string]: string

		// Maximum number of times to retry a failed HTTP request to this
		// provider.
		request_max_retries?: int & >=0.0

		// Does this provider require an OpenAI API Key or ChatGPT login
		// token? If true, user is presented with login screen on first
		// run, and login preference and token/key are stored in
		// auth.json. If false (which is the default), login screen is
		// skipped, and API key (if needed) comes from the "env_key"
		// environment variable.
		requires_openai_auth?: bool

		// Idle timeout (in milliseconds) to wait for activity on a
		// streaming response before treating the connection as lost.
		stream_idle_timeout_ms?: int & >=0.0

		// Number of times to retry reconnecting a dropped streaming
		// response before failing.
		stream_max_retries?: int & >=0.0

		// Whether this provider supports the Responses API WebSocket
		// transport.
		supports_websockets?: bool

		// Maximum time (in milliseconds) to wait for a websocket
		// connection attempt before treating it as failed.
		websocket_connect_timeout_ms?: int & >=0.0

		// Which wire protocol this provider expects.
		wire_api?: #WireApi
	})

	#MultiAgentV2ConfigToml: close({
		default_wait_timeout_ms?:            int & <=3600000.0 & >=0.0
		enabled?:                            bool
		hide_spawn_agent_metadata?:          bool
		max_concurrent_threads_per_session?: int & >=1.0
		max_wait_timeout_ms?:                int & <=3600000.0 & >=0.0
		min_wait_timeout_ms?:                int & <=3600000.0 & >=0.0
		non_code_mode_only?:                 bool
		root_agent_usage_hint_text?:         string
		subagent_usage_hint_text?:           string
		tool_namespace?:                     strings.MaxRunes(64) & strings.MinRunes(1) & =~"^[a-zA-Z0-9_-]+$"
		usage_hint_enabled?:                 bool
		usage_hint_text?:                    string
	})

	#NetworkDomainPermissionToml: "allow" | "deny"

	#NetworkDomainPermissionsToml: {
		...
	}

	#NetworkMitmActionToml: {
		inject_request_headers?: [...#NetworkMitmInjectedHeaderToml]
		strip_request_headers?: [...string]
		...
	}

	#NetworkMitmHookToml: close({
		action!: [...string]
		body?: _
		headers?: [string]: [...string]
		host!: string
		methods!: [...string]
		path_prefixes!: [...string]
		query?: [string]: [...string]
	})

	#NetworkMitmInjectedHeaderToml: {
		name?:           string
		prefix?:         string
		secret_env_var?: string
		secret_file?:    string
		...
	}

	#NetworkMitmToml: close({
		actions?: [string]: #NetworkMitmActionToml
		hooks?: [string]:   #NetworkMitmHookToml
	})

	#NetworkModeSchema: "limited" | "full"

	#NetworkProxyConfigToml: close({
		allow_local_binding?:                  bool
		allow_upstream_proxy?:                 bool
		dangerously_allow_all_unix_sockets?:   bool
		dangerously_allow_non_loopback_proxy?: bool
		domains?: [string]: #NetworkProxyDomainPermissionToml
		enable_socks5?:     bool
		enable_socks5_udp?: bool
		enabled?:           bool
		mode?:              #NetworkProxyModeToml
		proxy_url?:         string
		socks_url?:         string
		unix_sockets?: [string]: #NetworkProxyUnixSocketPermissionToml
	})

	#NetworkProxyDomainPermissionToml: "allow" | "deny"

	#NetworkProxyModeToml: "limited" | "full"

	#NetworkProxyUnixSocketPermissionToml: "allow" | "none"

	#NetworkToml: close({
		allow_local_binding?:                  bool
		allow_upstream_proxy?:                 bool
		dangerously_allow_all_unix_sockets?:   bool
		dangerously_allow_non_loopback_proxy?: bool
		domains?:                              #NetworkDomainPermissionsToml
		enable_socks5?:                        bool
		enable_socks5_udp?:                    bool
		enabled?:                              bool
		mitm?:                                 #NetworkMitmToml
		mode?:                                 #NetworkModeSchema
		proxy_url?:                            string
		socks_url?:                            string
		unix_sockets?:                         #NetworkUnixSocketPermissionsToml
	})

	#NetworkUnixSocketPermissionToml: "allow" | "none"

	#NetworkUnixSocketPermissionsToml: {
		...
	}

	#Notice: close({
		// Tracks scopes where external config migration prompts should be
		// suppressed.
		external_config_migration_prompts?: #ExternalConfigMigrationPrompts

		// Tracks whether the user opted out of Codex-managed fast
		// defaults.
		fast_default_opt_out?: bool

		// Tracks whether the user has acknowledged the full access
		// warning prompt.
		hide_full_access_warning?: bool

		// Tracks whether the user has seen the gpt-5.1-codex-max
		// migration prompt
		"hide_gpt-5.1-codex-max_migration_prompt"?: bool

		// Tracks whether the user has seen the model migration prompt
		hide_gpt5_1_migration_prompt?: bool

		// Tracks whether the user opted out of the rate limit model
		// switch reminder.
		hide_rate_limit_model_nudge?: bool

		// Tracks whether the user has acknowledged the Windows
		// world-writable directories warning.
		hide_world_writable_warning?: bool

		// Tracks acknowledged model migrations as old->new model slug
		// mappings.
		model_migrations?: [string]: string
	})

	#NotificationCondition: matchN(1, ["unfocused", "always"])

	#NotificationMethod: "auto" | "osc9" | "bel"

	#Notifications: matchN(>=1, [bool, [...string]])

	// Determine where Codex should store and read MCP credentials.
	#OAuthCredentialsStoreMode: matchN(1, ["auto", "file", "keyring"])

	// OTEL settings loaded from config.toml. Fields are optional so
	// we can apply defaults.
	#OtelConfigToml: close({
		// Mark traces with environment (dev, staging, prod, test).
		// Defaults to dev.
		environment?: string

		// Optional log exporter
		exporter?: #OtelExporterKind

		// Log user prompt in traces
		log_user_prompt?: bool

		// Optional metrics exporter
		metrics_exporter?: #OtelExporterKind

		// Attributes to add to every exported trace span.
		span_attributes?: [string]: string

		// Optional trace exporter
		trace_exporter?: #OtelExporterKind

		// Semicolon-separated `key:value` fields to upsert into W3C
		// tracestate members.
		tracestate?: [string]: [string]: string
	})

	// Which OTEL exporter to use.
	#OtelExporterKind: matchN(1, ["none" | "statsig", close({
		"otlp-http"!: close({
			endpoint!: string
			headers?: [string]: string
			protocol!: #OtelHttpProtocol
			tls?:      #OtelTlsConfig
		})
	}), close({
		"otlp-grpc"!: close({
			endpoint!: string
			headers?: [string]: string
			tls?: #OtelTlsConfig
		})
	})])

	#OtelHttpProtocol: matchN(1, ["binary", "json"])

	#OtelTlsConfig: close({
		"ca-certificate"?:     #AbsolutePathBuf
		"client-certificate"?: #AbsolutePathBuf
		"client-private-key"?: #AbsolutePathBuf
	})

	#PermissionProfileToml: close({
		description?:     string
		extends?:         string
		filesystem?:      #FilesystemPermissionsToml
		network?:         #NetworkToml
		workspace_roots?: #WorkspaceRootsToml
	})

	#PermissionsToml: {
		...
	}

	#Personality: "none" | "friendly" | "pragmatic"

	#PluginConfig: close({
		enabled?: bool

		// Per-MCP-server policy overlays for MCP servers contributed by
		// this plugin.
		mcp_servers?: [string]: #PluginMcpServerConfig
	})

	// Policy settings for a plugin-provided MCP server.
	//
	// This intentionally excludes transport settings: plugin
	// manifests own how the MCP server is launched, while user
	// config owns enablement and tool policy.
	#PluginMcpServerConfig: close({
		// Approval mode for tools in this server unless a tool override
		// exists.
		default_tools_approval_mode?: #AppToolApproval

		// Explicit deny-list of tools. These tools are removed after
		// applying `enabled_tools`.
		disabled_tools?: [...string]

		// When `false`, Codex skips initializing this plugin MCP server.
		enabled?: bool

		// Explicit allow-list of tools exposed from this server.
		enabled_tools?: [...string]

		// Per-tool approval settings keyed by tool name.
		tools?: [string]: #McpServerToolConfig
	})

	// TUI settings supported inside a named profile.
	#ProfileTui: close({
		// Preferred layout for resume/fork session picker results.
		session_picker_view?: #SessionPickerViewMode
	})

	#ProjectConfig: close({
		trust_level?: #TrustLevel
	})

	// Raw MCP config shape used for deserialization and
	// supported-field JSON Schema generation.
	//
	// Fields that are accepted only to produce targeted validation
	// errors should be skipped in the generated schema.
	//
	// Keep `TryFrom<RawMcpServerConfig> for McpServerConfig`
	// exhaustively destructuring this struct so new TOML fields
	// cannot be added here without updating the validation/mapping
	// logic that produces [`McpServerConfig`].
	#RawMcpServerConfig: close({
		args?: [...string]
		bearer_token_env_var?:        string
		command?:                     string
		cwd?:                         string
		default_tools_approval_mode?: #AppToolApproval
		disabled_tools?: [...string]
		enabled?: bool
		enabled_tools?: [...string]
		env?: [string]:              string
		env_http_headers?: [string]: string
		env_vars?: [...#McpServerEnvVar]
		experimental_environment?: string
		http_headers?: [string]: string

		// Legacy display-name field accepted for backward compatibility.
		name?:           string
		oauth?:          #McpServerOAuthConfig
		oauth_resource?: string
		required?:       bool
		scopes?: [...string]
		startup_timeout_ms?:           int & >=0.0
		startup_timeout_sec?:          number
		supports_parallel_tool_calls?: bool
		tool_timeout_sec?:             number
		tools?: [string]: #McpServerToolConfig
		url?: string
	})

	#RealtimeAudioToml: close({
		microphone?: string
		speaker?:    string
	})

	#RealtimeConversationVersion: "v1" | "v2"

	#RealtimeToml: close({
		transport?: #RealtimeTransport
		type?:      #RealtimeWsMode
		version?:   #RealtimeConversationVersion
		voice?:     #RealtimeVoice
	})

	#RealtimeTransport: "webrtc" | "websocket"

	#RealtimeVoice: "alloy" | "arbor" | "ash" | "ballad" | "breeze" | "cedar" | "coral" | "cove" | "echo" | "ember" | "juniper" | "maple" | "marin" | "sage" | "shimmer" | "sol" | "spruce" | "vale" | "verse"

	#RealtimeWsMode: "conversational" | "transcription"

	// See
	// https://platform.openai.com/docs/guides/reasoning?api-mode=responses#get-started-with-reasoning
	#ReasoningEffort: "none" | "minimal" | "low" | "medium" | "high" | "xhigh"

	// A summary of the reasoning performed by the model. This can be
	// useful for debugging and understanding the model's reasoning
	// process. See
	// https://platform.openai.com/docs/guides/reasoning?api-mode=responses#reasoning-summaries
	#ReasoningSummary: matchN(1, ["auto" | "concise" | "detailed", "none"])

	#SandboxMode: "read-only" | "workspace-write" | "danger-full-access"

	#SandboxWorkspaceWrite: close({
		exclude_slash_tmp?:      bool
		exclude_tmpdir_env_var?: bool
		network_access?:         bool
		writable_roots?: [...#AbsolutePathBuf]
	})

	// Preferred layout for the resume/fork session picker.
	#SessionPickerViewMode: "comfortable" | "dense"

	#ShellEnvironmentPolicyInherit: matchN(1, ["core", "all", "none"])

	// Policy for building the `env` when spawning a process via
	// shell-like tools.
	#ShellEnvironmentPolicyToml: close({
		// List of regular expressions.
		exclude?: [...string]
		experimental_use_profile?: bool
		ignore_default_excludes?:  bool

		// List of regular expressions.
		include_only?: [...string]
		inherit?: #ShellEnvironmentPolicyInherit
		set?: [string]: string
	})

	#SkillConfig: close({
		enabled!: bool

		// Name-based selector.
		name?: string

		// Path-based selector.
		path?: #AbsolutePathBuf
	})

	#SkillsConfig: close({
		bundled?: #BundledSkillsConfig
		config?: [...#SkillConfig]

		// Whether turns receive the automatic skills instructions block.
		include_instructions?: bool
	})

	#ThreadStoreToml: {
		type!: "local"
		...
	}

	#ToolSuggestConfig: close({
		disabled_tools?: [...#ToolSuggestDisabledTool]
		discoverables?: [...#ToolSuggestDiscoverable]
	})

	#ToolSuggestDisabledTool: close({
		id!:   string
		type!: #ToolSuggestDiscoverableType
	})

	#ToolSuggestDiscoverable: close({
		id!:   string
		type!: #ToolSuggestDiscoverableType
	})

	#ToolSuggestDiscoverableType: "connector" | "plugin"

	#ToolsToml: close({
		web_search?: #WebSearchToolConfig
	})

	// Represents the trust level for a project directory. This
	// determines the approval policy and sandbox mode applied.
	#TrustLevel: "trusted" | "untrusted"

	// Collection of settings that are specific to the TUI.
	#Tui: close({
		// Controls whether the TUI uses the terminal's alternate screen
		// buffer.
		//
		// - `auto` (default): Use alternate screen. - `always`: Always
		// use alternate screen. - `never`: Never use alternate screen
		// (inline mode only, preserves scrollback).
		alternate_screen?: #AltScreenMode

		// Enable animations (welcome screen, shimmer effects, spinners).
		// Defaults to `true`.
		animations?: bool

		// Keybinding overrides for the TUI.
		//
		// This supports rebinding selected actions globally and by
		// context. Context bindings take precedence over `global`
		// bindings.
		keymap?: #TuiKeymap

		// Startup tooltip availability NUX state persisted by the TUI.
		model_availability_nux?: #ModelAvailabilityNuxConfig

		// Controls whether TUI notifications are delivered only when the
		// terminal is unfocused or regardless of focus. Defaults to
		// `unfocused`.
		notification_condition?: #NotificationCondition

		// Notification method to use for terminal notifications. Defaults
		// to `auto`.
		notification_method?: #NotificationMethod

		// Enable desktop notifications from the TUI. Defaults to `true`.
		notifications?: #Notifications

		// Pet id to preselect in the terminal pet picker.
		//
		// Custom pet ids resolve against
		// CODEX_HOME/pets/<pet-id>/pet.json.
		pet?: string

		// Where the terminal pet should anchor vertically.
		//
		// Defaults to `composer`, which follows the current TUI composer
		// viewport.
		pet_anchor?: #TuiPetAnchor

		// Start the TUI in raw scrollback mode for copy-friendly
		// transcript output. Defaults to `false`.
		raw_output_mode?: bool

		// Preferred layout for resume/fork session picker results.
		session_picker_view?: #SessionPickerViewMode

		// Show startup tooltips in the TUI welcome screen. Defaults to
		// `true`.
		show_tooltips?: bool

		// Ordered list of status line item identifiers.
		//
		// When set, the TUI renders the selected items as the status
		// line. When unset, the TUI defaults to: `model-with-reasoning`
		// and `current-dir`.
		status_line?: [...string]

		// Color status line items with colors derived from the active
		// syntax theme. Defaults to `true`.
		status_line_use_colors?: bool

		// Trim terminal resize-reflow replay to the most recent rendered
		// terminal rows when the transcript exceeds this cap. Omit to
		// use Codex's terminal-specific default. Set to `0` to keep all
		// rendered rows.
		terminal_resize_reflow_max_rows?: int & >=0.0

		// Ordered list of terminal title item identifiers.
		//
		// When set, the TUI renders the selected items into the terminal
		// window/tab title. When unset, the TUI defaults to: `activity`
		// and `project`. The `activity` item spins while working and
		// shows an action-required message when blocked on the user.
		terminal_title?: [...string]

		// Syntax highlighting theme name (kebab-case).
		//
		// When set, overrides automatic light/dark theme detection. Use
		// `/theme` in the TUI or see `$CODEX_HOME/themes` for custom
		// themes.
		theme?: string

		// Start the composer in Vim mode (`Normal`) by default. Defaults
		// to `false`.
		vim_mode_default?: bool
	})

	// Approval overlay keybindings.
	#TuiApprovalKeymap: close({
		// Approve the primary option.
		approve?: #KeybindingsSpec

		// Approve with exec-policy prefix when that option exists.
		approve_for_prefix?: #KeybindingsSpec

		// Approve for session when that option exists.
		approve_for_session?: #KeybindingsSpec

		// Cancel an elicitation request.
		cancel?: #KeybindingsSpec

		// Decline and provide corrective guidance.
		decline?: #KeybindingsSpec

		// Deny without providing follow-up guidance.
		deny?: #KeybindingsSpec

		// Open the full-screen approval details view.
		open_fullscreen?: #KeybindingsSpec

		// Open the thread that requested approval when shown from another
		// thread.
		open_thread?: #KeybindingsSpec
	})

	// Chat context keybindings.
	#TuiChatKeymap: close({
		// Decrease the active reasoning effort.
		decrease_reasoning_effort?: #KeybindingsSpec

		// Edit the most recently queued message.
		edit_queued_message?: #KeybindingsSpec

		// Increase the active reasoning effort.
		increase_reasoning_effort?: #KeybindingsSpec
	})

	// Composer context keybindings. These override corresponding
	// `global` actions.
	#TuiComposerKeymap: close({
		// Move to the next match in reverse history search.
		history_search_next?: #KeybindingsSpec

		// Open reverse history search or move to the previous match.
		history_search_previous?: #KeybindingsSpec

		// Queue the current composer draft while a task is running.
		queue?: #KeybindingsSpec

		// Submit the current composer draft.
		submit?: #KeybindingsSpec

		// Toggle the composer shortcut overlay.
		toggle_shortcuts?: #KeybindingsSpec
	})

	// Editor context keybindings for text editing inside text areas.
	#TuiEditorKeymap: close({
		// Delete one grapheme to the left.
		delete_backward?: #KeybindingsSpec

		// Delete the previous word.
		delete_backward_word?: #KeybindingsSpec

		// Delete one grapheme to the right.
		delete_forward?: #KeybindingsSpec

		// Delete the next word.
		delete_forward_word?: #KeybindingsSpec

		// Insert a newline in the editor.
		insert_newline?: #KeybindingsSpec

		// Kill text from cursor to line end.
		kill_line_end?: #KeybindingsSpec

		// Kill text from cursor to line start.
		kill_line_start?: #KeybindingsSpec

		// Kill the current line.
		kill_whole_line?: #KeybindingsSpec

		// Move cursor down one visual line.
		move_down?: #KeybindingsSpec

		// Move cursor left by one grapheme.
		move_left?: #KeybindingsSpec

		// Move cursor to end of line.
		move_line_end?: #KeybindingsSpec

		// Move cursor to beginning of line.
		move_line_start?: #KeybindingsSpec

		// Move cursor right by one grapheme.
		move_right?: #KeybindingsSpec

		// Move cursor up one visual line.
		move_up?: #KeybindingsSpec

		// Move cursor to beginning of previous word.
		move_word_left?: #KeybindingsSpec

		// Move cursor to end of next word.
		move_word_right?: #KeybindingsSpec

		// Yank the kill buffer.
		yank?: #KeybindingsSpec
	})

	// Global keybindings. These are used when a context does not
	// define an override.
	#TuiGlobalKeymap: close({
		// Clear the terminal UI.
		clear_terminal?: #KeybindingsSpec

		// Copy the last agent response to the clipboard.
		copy?: #KeybindingsSpec

		// Open the external editor for the current draft.
		open_external_editor?: #KeybindingsSpec

		// Open the transcript overlay.
		open_transcript?: #KeybindingsSpec

		// Queue the current composer draft while a task is running.
		queue?: #KeybindingsSpec

		// Submit the current composer draft.
		submit?: #KeybindingsSpec

		// Toggle Fast mode.
		toggle_fast_mode?: #KeybindingsSpec

		// Toggle raw scrollback mode for copy-friendly transcript
		// selection.
		toggle_raw_output?: #KeybindingsSpec

		// Toggle the composer shortcut overlay.
		toggle_shortcuts?: #KeybindingsSpec

		// Toggle Vim mode for the composer input.
		toggle_vim_mode?: #KeybindingsSpec
	})

	// Raw keymap configuration from `[tui.keymap]`.
	//
	// Each context contains action-level overrides. Missing actions
	// inherit from built-in defaults, and selected chat/composer
	// actions can fall back through `global` during runtime
	// resolution.
	//
	// This type is intentionally a persistence shape, not the
	// structure used by input handlers. Runtime consumers should
	// resolve it into `RuntimeKeymap` first so precedence,
	// empty-list unbinding, and duplicate-key validation are applied
	// consistently.
	#TuiKeymap: close({
		approval?:     #TuiApprovalKeymap
		chat?:         #TuiChatKeymap
		composer?:     #TuiComposerKeymap
		editor?:       #TuiEditorKeymap
		global?:       #TuiGlobalKeymap
		list?:         #TuiListKeymap
		pager?:        #TuiPagerKeymap
		vim_normal?:   #TuiVimNormalKeymap
		vim_operator?: #TuiVimOperatorKeymap
	})

	// List selection context keybindings for popup-style selectable
	// lists.
	#TuiListKeymap: close({
		// Accept current selection.
		accept?: #KeybindingsSpec

		// Cancel and close selection view.
		cancel?: #KeybindingsSpec

		// Jump to the last list item.
		jump_bottom?: #KeybindingsSpec

		// Jump to the first list item.
		jump_top?: #KeybindingsSpec

		// Move list selection down.
		move_down?: #KeybindingsSpec

		// Move horizontally left in list pickers that support horizontal
		// actions.
		move_left?: #KeybindingsSpec

		// Move horizontally right in list pickers that support horizontal
		// actions.
		move_right?: #KeybindingsSpec

		// Move list selection up.
		move_up?: #KeybindingsSpec

		// Move list selection down by one page.
		page_down?: #KeybindingsSpec

		// Move list selection up by one page.
		page_up?: #KeybindingsSpec
	})

	// Pager context keybindings for transcript and static overlays.
	#TuiPagerKeymap: close({
		// Close the pager overlay.
		close?: #KeybindingsSpec

		// Close the transcript overlay via its dedicated toggle key.
		close_transcript?: #KeybindingsSpec

		// Scroll down by half a page.
		half_page_down?: #KeybindingsSpec

		// Scroll up by half a page.
		half_page_up?: #KeybindingsSpec

		// Jump to the end.
		jump_bottom?: #KeybindingsSpec

		// Jump to the beginning.
		jump_top?: #KeybindingsSpec

		// Scroll down by one page.
		page_down?: #KeybindingsSpec

		// Scroll up by one page.
		page_up?: #KeybindingsSpec

		// Scroll down by one row.
		scroll_down?: #KeybindingsSpec

		// Scroll up by one row.
		scroll_up?: #KeybindingsSpec
	})

	#TuiPetAnchor: matchN(1, ["composer", "screen-bottom"])

	// Vim normal-mode keybindings for modal editing inside text
	// areas.
	//
	// Actions that use uppercase letters (like `A` for
	// append-line-end) should be specified as `shift-a` in config;
	// the runtime matcher handles cross-terminal shift-reporting
	// differences automatically.
	#TuiVimNormalKeymap: close({
		// Enter insert mode after cursor (`a`).
		append_after_cursor?: #KeybindingsSpec

		// Enter insert mode at end of line (`A`).
		append_line_end?: #KeybindingsSpec

		// Cancel a pending operator and return to normal mode.
		cancel_operator?: #KeybindingsSpec

		// Delete character under cursor (`x`).
		delete_char?: #KeybindingsSpec

		// Delete from cursor to end of line (`D`).
		delete_to_line_end?: #KeybindingsSpec

		// Enter insert mode at cursor (`i`).
		enter_insert?: #KeybindingsSpec

		// Enter insert mode at first non-blank of line (`I`).
		insert_line_start?: #KeybindingsSpec

		// Move cursor down (`j`), or recall newer composer history at
		// history boundaries.
		move_down?: #KeybindingsSpec

		// Move cursor left (`h`).
		move_left?: #KeybindingsSpec

		// Move cursor to end of line (`$`).
		move_line_end?: #KeybindingsSpec

		// Move cursor to start of line (`0`).
		move_line_start?: #KeybindingsSpec

		// Move cursor right (`l`).
		move_right?: #KeybindingsSpec

		// Move cursor up (`k`), or recall older composer history at
		// history boundaries.
		move_up?: #KeybindingsSpec

		// Move cursor to start of previous word (`b`).
		move_word_backward?: #KeybindingsSpec

		// Move cursor to end of current/next word (`e`).
		move_word_end?: #KeybindingsSpec

		// Move cursor to start of next word (`w`).
		move_word_forward?: #KeybindingsSpec

		// Open a new line above and enter insert mode (`O`).
		open_line_above?: #KeybindingsSpec

		// Open a new line below and enter insert mode (`o`).
		open_line_below?: #KeybindingsSpec

		// Paste after cursor (`p`).
		paste_after?: #KeybindingsSpec

		// Begin delete operator; next key selects motion (`d`).
		start_delete_operator?: #KeybindingsSpec

		// Begin yank operator; next key selects motion (`y`).
		start_yank_operator?: #KeybindingsSpec

		// Yank the entire line (`Y`).
		yank_line?: #KeybindingsSpec
	})

	// Vim operator-pending keybindings for modal editing inside text
	// areas.
	//
	// This context is active only while waiting for a motion after
	// `d` or `y`. Repeating the operator key (`dd`, `yy`) targets
	// the entire line. Pressing `Esc` cancels the pending operator
	// and returns to normal mode without modifying text.
	#TuiVimOperatorKeymap: close({
		// Cancel the pending operator and return to normal mode.
		cancel?: #KeybindingsSpec

		// Repeat delete operator to delete the whole line (`dd`).
		delete_line?: #KeybindingsSpec

		// Motion: down one line (`j`).
		motion_down?: #KeybindingsSpec

		// Motion: left (`h`).
		motion_left?: #KeybindingsSpec

		// Motion: to end of line (`$`).
		motion_line_end?: #KeybindingsSpec

		// Motion: to start of line (`0`).
		motion_line_start?: #KeybindingsSpec

		// Motion: right (`l`).
		motion_right?: #KeybindingsSpec

		// Motion: up one line (`k`).
		motion_up?: #KeybindingsSpec

		// Motion: to start of previous word (`b`).
		motion_word_backward?: #KeybindingsSpec

		// Motion: to end of current/next word (`e`).
		motion_word_end?: #KeybindingsSpec

		// Motion: to start of next word (`w`).
		motion_word_forward?: #KeybindingsSpec

		// Repeat yank operator to yank the whole line (`yy`).
		yank_line?: #KeybindingsSpec
	})

	#UriBasedFileOpener: matchN(1, ["vscode" | "vscode-insiders" | "windsurf" | "cursor", "none"])

	// Controls output length/detail on GPT-5 models via the Responses
	// API. Serialized with lowercase values to match the OpenAI API.
	#Verbosity: "low" | "medium" | "high"

	#WebSearchContextSize: "low" | "medium" | "high"

	#WebSearchLocation: close({
		city?:     string
		country?:  string
		region?:   string
		timezone?: string
	})

	#WebSearchMode: "disabled" | "cached" | "live"

	#WebSearchToolConfig: close({
		allowed_domains?: [...string]
		context_size?: #WebSearchContextSize
		location?:     #WebSearchLocation
	})

	#WindowsSandboxModeToml: "elevated" | "unelevated"

	#WindowsToml: close({
		sandbox?: #WindowsSandboxModeToml

		// Defaults to `true`. Set to `false` to launch the final
		// sandboxed child process on `Winsta0\\Default` instead of a
		// private desktop.
		sandbox_private_desktop?: bool
	})

	// Wire protocol that the provider speaks.
	#WireApi: "responses"

	#WorkspaceRootsToml: {
		...
	}
}
