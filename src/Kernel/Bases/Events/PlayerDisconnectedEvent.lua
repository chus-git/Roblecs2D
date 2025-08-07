local PlayerDisconnectedEvent = require(game.ReplicatedStorage.Source.Event).extend()

PlayerDisconnectedEvent.name = "PlayerDisconnectedEvent"

PlayerDisconnectedEvent.constructor = function(id: number, name: string)
	return id
end

return PlayerDisconnectedEvent