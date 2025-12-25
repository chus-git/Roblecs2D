local DestroyEntityEvent = require(game.ReplicatedStorage.Source.Event).extend()

DestroyEntityEvent.name = "DestroyEntityEvent"

DestroyEntityEvent.constructor = function(entityId)
	return entityId
end

return DestroyEntityEvent