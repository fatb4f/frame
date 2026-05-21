package repo

import "tool/exec"

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
