local OnShootEvent = require(game.ReplicatedStorage.Source.Event).extend()

OnShootEvent.name = "OnShootEvent"

OnShootEvent.constructor = function(position, direction)
	return position, direction
end

return OnShootEvent