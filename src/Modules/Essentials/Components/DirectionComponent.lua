local DirectionComponent = require(game.ReplicatedStorage.Source.Component).extend()

DirectionComponent.name = "DirectionComponent"

DirectionComponent.constructor = function(x, y)
	return {
		x = x,
        y = y
	}
end

return DirectionComponent