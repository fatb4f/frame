# Codex Repo Contract

This repository's agent and project constraints are defined in CUE.

Authoritative contract:

```txt
cue/agents/agents.cue
```

Related contract surfaces:

```txt
cue/adapters/*
cue/runtime/*
cue/agents/*
```

Inspect:

```sh
cue export ./cue/agents -e '#AgentContract'
cue export ./cue/agents -e '#TurnStartContract'
cue export ./cue/agents -e '#ObservationPolicy'
cue export ./cue/agents -e '#ValidationContract'
cue export ./cue/agents -e '#FallbackAdapterFacts'
```

Validate:

```sh
cue vet -c=false ./cue/...
```

Minimum repo-local PATH for fallback adapters and validation commands:

```sh
PATH="$PWD/bin:$PATH"
```

Do not treat this Markdown file as the policy source. If this file disagrees
with the CUE contract, the CUE contract wins.
