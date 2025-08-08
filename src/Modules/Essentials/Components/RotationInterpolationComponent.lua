local RotationInterpolationComponent = require(game.ReplicatedStorage.Source.Component).extend()

RotationInterpolationComponent.name = "RotationInterpolationComponent"

RotationInterpolationComponent.constructor = function(angle)
	return {
		previous = angle,
        target = angle
	}
end

return RotationInterpolationComponent