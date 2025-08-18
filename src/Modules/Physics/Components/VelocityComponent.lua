local VelocityComponent = require(game.ReplicatedStorage.Source.Component).extend()

VelocityComponent.name = "VelocityComponent"

VelocityComponent.constructor = function(x, y)
	return {
		x = x,
        y = y
	}
end

return VelocityComponent