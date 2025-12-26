local ChangeGravityEvent = require(game.ReplicatedStorage.Source.Event).extend()

ChangeGravityEvent.name = "ChangeGravityEvent"

ChangeGravityEvent.constructor = function(gravity)
	return gravity
end

return ChangeGravityEvent