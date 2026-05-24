package cuerail

#TurnTrace: {
	session_id!: string
	turn_id!:    string
	manifests!: [...{
		input!: {
			hook_event_name!: #CodexHookEvent
			...
		}
		awareness!: {
			plan!:    #AwarenessPlan
			results!: [...#ReadResultEnvelope]
		}
		output!:  _
		capture!: #CaptureDecision
	}]
}
