
local Interpolation = require(game.ReplicatedStorage.Core.Component).extend()

Interpolation.name = "Interpolation"

Interpolation.constructor = function(x, y)
	return {
		previous = Vector2.new(x, y),
		next = Vector2.new(x, y),
		current = Vector2.new(x, y),
	}
end

return Interpolation