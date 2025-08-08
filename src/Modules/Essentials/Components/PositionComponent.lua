local PositionComponent = require(game.ReplicatedStorage.Source.Component).extend()

PositionComponent.name = "PositionComponent"

PositionComponent.constructor = function(x, y)
	return {
		x = x,
        y = y
	}
end

return PositionComponent