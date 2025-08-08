local RenderPositionComponent = require(game.ReplicatedStorage.Source.Component).extend()

RenderPositionComponent.name = "RenderPositionComponent"

RenderPositionComponent.constructor = function(x, y)
	return {
		x = x,
        y = y
	}
end

return RenderPositionComponent