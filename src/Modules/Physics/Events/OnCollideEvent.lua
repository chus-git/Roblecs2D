local OnCollideEvent = require(game.ReplicatedStorage.Source.Event).extend()

OnCollideEvent.name = "OnCollideEvent"

OnCollideEvent.constructor = function(entity1, entity2)
	return entity1, entity2
end

return OnCollideEvent