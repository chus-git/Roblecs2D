local Position = require(game.ReplicatedStorage.Core.Component).extend()

Position.name = "Position"

Position.constructor = function(x: number, y: number)
	return {
		x = x,
		y = y
	}
end

return Position