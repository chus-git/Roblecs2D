local PlayerDisconnected = require(game.ReplicatedStorage.Core.Event).extend()

PlayerDisconnected.name = "PlayerDisconnected"

PlayerDisconnected.constructor = function(playerId: number)
	return playerId
end

return PlayerDisconnected