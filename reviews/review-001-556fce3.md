• Findings

  1. High: CUE validation is currently broken.
     cue/constraints.cue:11 fails to parse:
     missing ',' in struct literal at lines 12-13. This breaks the README’s stated cue vet ./cue workflow and undercuts “CUE unifies / Policies validate.”
  2. High: #RepoState and #Views do not unify.
     cue/state.cue:23 embeds #Views, but cue vet cue/state.cue cue/views.cue reports:
     #RepoState.views.agent.root: field not allowed and #RepoState.views.review.root: field not allowed, pointing at cue/views.cue:14. So “Views project” is conceptually right,
     but the model does not currently execute.
  3. Medium: repo-git diff / staged output does not match #GitState.
     bin/repo-git:105 emits a top-level diff field, but cue/state.cue:30 does not allow it. I confirmed cue vet ... -d '#GitState' rejects adapter output with diff: field not
     allowed.
  4. Medium: The concept statement says “Evals judge,” but there is no eval surface in the runtime layout.
     README.md:13 names evals as part of the contract, but the runtime surface and layout only include repo-rg, repo-git, cue, and skills/*. Either add the eval surface or
     remove that line for now.
  5. Low: repo-git status . from the current directory fails because this workspace is not a Git worktree.
     That may be an artifact of how this repo was provided, but it means the README usage at README.md:48 is not reproducible here as-is.

  Concept Review

  The concept is strong and appropriately small: “Adapters observe. CUE unifies. Views project. Policies validate. Agents consume.” That framing matches the file layout and is
  a good anti-sprawl boundary.

  The main issue is execution drift: the CUE authority layer is broken, one adapter emits fields outside the schema, and “Evals judge” is aspirational rather than represented.
  I would fix the CUE model first, then add a tiny fixture-based validation path that vets repo-rg and repo-git outputs against the schemas. That would make the concept
  statements true instead of just clear.

  Checks Run

  cue vet ./cue failed.
  cue vet cue/state.cue cue/views.cue failed.
  repo-rg output validates against #RgResult.
  repo-git diff output does not validate against #GitState.
