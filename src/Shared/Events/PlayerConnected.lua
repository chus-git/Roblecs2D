local wrapEvent = require(game.ReplicatedStorage.Core.Utils).wrapEvent

return wrapEvent("PlayerConnected", function(playerId: number, playerName: string)
	return playerId, playerName
end)