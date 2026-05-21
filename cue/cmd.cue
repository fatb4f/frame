package repo

import "tool/exec"

// Convenience commands. The executable adapters remain the runtime boundary.

command: status: {
	run: exec.Run & {
		cmd: "repo-git status ."
		env: {}
		success: true
	}
}

command: summary: {
	run: exec.Run & {
		cmd: "repo-git summary ."
		env: {}
		success: true
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
		env: {}
		success: true
	}
}

command: semantic: {
	run: exec.Run & {
		cmd: "repo-git semantic ."
		env: {}
		success: true
	}
}
