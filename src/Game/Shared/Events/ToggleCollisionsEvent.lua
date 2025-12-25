local ToggleCollisionsEvent = require(game.ReplicatedStorage.Source.Event).extend()

ToggleCollisionsEvent.name = "ToggleCollisionsEvent"

ToggleCollisionsEvent.constructor = function(enabled)
	return enabled
end

return ToggleCollisionsEvent