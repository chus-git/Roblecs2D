local PlayerConnected = require(game.ReplicatedStorage.Core.Event).extend()

PlayerConnected.name = "PlayerConnected"

PlayerConnected.constructor = function(playerId: number, playerName: string)
	return playerId, playerName
end

return PlayerConnected