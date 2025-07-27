local BallCreated = require(game.ReplicatedStorage.Core.Event).extend()

BallCreated.name = "BallCreated"

BallCreated.constructor = function(ballId: number)
	return ballId
end

return BallCreated