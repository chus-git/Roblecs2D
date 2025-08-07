local PlayerConnectedEvent = require(game.ReplicatedStorage.Source.Event).extend()

PlayerConnectedEvent.name = "PlayerConnectedEvent"

PlayerConnectedEvent.constructor = function(id: number, name: string)
	return id, name
end

return PlayerConnectedEvent