
local Position = require(game.ReplicatedStorage.Core.Component).extend()

Position.name = "Position"

Position.constructor = function(x, y)
	return {
		x = x,
		y = y
	}
end

return Position