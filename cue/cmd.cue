package repo

import "tool/exec"

// Convenience commands. The executable adapters remain the runtime boundary.

command: status: {
	run: exec.Run & {
		cmd: "repo-git status ."
	}
}

command: summary: {
	run: exec.Run & {
		cmd: "repo-git summary ."
	}
}

command: diff: {
	run: exec.Run & {
		cmd: "repo-git diff ."
	}
}

command: staged: {
	run: exec.Run & {
		cmd: "repo-git staged ."
	}
}

command: semantic: {
	run: exec.Run & {
		cmd: "repo-git semantic ."
	}
}
