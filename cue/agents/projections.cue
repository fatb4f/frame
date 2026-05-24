package agents

import adapters "github.com/fatb4f/cuerail/cue/adapters:cuerail"

#FallbackAdapterFacts: adapters.temporaryShellAdapters

#TurnStartContract: #AgentContract.turnStart

#ObservationPolicy: #AgentContract.observation

#ValidationContract: #AgentContract.validation

#ForbiddenConstraints: [
	for group in [
		#AgentContract.observation.constraints,
		#AgentContract.turnStart.constraints,
		#AgentContract.hookManifest.constraints,
		#AgentContract.validation.constraints,
		#AgentContract.planGate.constraints,
		#AgentContract.skillRouting.constraints,
		#AgentContract.boundaries.constraints,
		#AgentContract.pruning.constraints,
	]
	for c in group if c.severity == "forbidden" {c},
]

#AuthoritySummary: {
	cue: [for b in #AgentContract.authorityBoundaries if b.owner == "cue" {b.owns}][0]
	shell: [for b in #AgentContract.authorityBoundaries if b.owner == "shell" {b.owns}][0]
	markdown: [for b in #AgentContract.authorityBoundaries if b.owner == "markdown" {b.owns}][0]
}
