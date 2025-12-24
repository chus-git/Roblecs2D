local DestroyEntityEvent = require(game.ReplicatedStorage.Source.Event).extend()

DestroyEntityEvent.name = "DestroyEntityEvent"

DestroyEntityEvent.constructor = function(id)
	return id
end

return DestroyEntityEvent