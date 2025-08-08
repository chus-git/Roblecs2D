local RotationComponent = require(game.ReplicatedStorage.Source.Component).extend()

RotationComponent.name = "RotationComponent"

RotationComponent.constructor = function(angle)
	return {
		angle = angle
	}
end

return RotationComponent