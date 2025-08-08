local PositionInterpolationComponent = require(game.ReplicatedStorage.Source.Component).extend()

PositionInterpolationComponent.name = "PositionInterpolationComponent"

PositionInterpolationComponent.constructor = function(x, y)
	return {
		previous = {
            x = x,
            y = y
        },
        target = {
            x = x,
            y = y
        }
	}
end

return PositionInterpolationComponent