local PositionInterpolationComponent = require(game.ReplicatedStorage.Source.Component).extend()

PositionInterpolationComponent.name = "PositionInterpolationComponent"

PositionInterpolationComponent.constructor = function(previousX, previousY, targetX, targetY)
	return {
		previous = {
            x = previousX,
            y = previousY
        },
        target = {
            x = targetX or previousX,
            y = targetY or previousY
        }
	}
end

return PositionInterpolationComponent