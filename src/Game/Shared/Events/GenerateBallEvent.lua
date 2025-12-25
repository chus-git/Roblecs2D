local GenerateBallEvent = require(game.ReplicatedStorage.Source.Event).extend()

GenerateBallEvent.name = "GenerateBallEvent"

GenerateBallEvent.constructor = function(x: number, y: number)
	return x, y
end

return GenerateBallEvent