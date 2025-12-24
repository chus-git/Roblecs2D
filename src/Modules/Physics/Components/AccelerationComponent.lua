local AccelerationComponent = require(game.ReplicatedStorage.Source.Component).extend()

AccelerationComponent.name = "AccelerationComponent"

AccelerationComponent.constructor = function(x, y)
	return {
		x = x,
        y = y
	}
end

return AccelerationComponent