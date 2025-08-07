
local State = require(game.ReplicatedStorage.Source.Component).extend()

State.name = "State"

State.constructor = function(currentState, nextState)
	return {
		current = currentState,
        next = nextState
	}
end

return State