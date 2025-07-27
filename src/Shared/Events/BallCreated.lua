local wrapEvent = require(game.ReplicatedStorage.Core.Utils).wrapEvent

return wrapEvent("BallCreated", function(ballId: number)
	return ballId
end)