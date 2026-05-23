package repo

import "tool/exec"

// Convenience commands for the cuerail contract. The installed runtime remains
// the boundary; these commands are validation helpers, not hook execution.

command: doctor: {
	run: exec.Run & {
		cmd: "cuerail-doctor"
		env: {}
		success: true
	}
}

command: vet: {
	run: exec.Run & {
		cmd: "cue vet ./cue"
		env: {}
		success: true
	}
}

command: exampleToolSurface: {
	run: exec.Run & {
		cmd: "cue export ./cue -e '#ExampleCodexToolSurface'"
		env: {}
		success: true
	}
}
