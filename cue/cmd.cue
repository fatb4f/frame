package repo

import "tool/exec"

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
