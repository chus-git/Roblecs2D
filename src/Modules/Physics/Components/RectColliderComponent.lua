local RectColliderComponent = require(game.ReplicatedStorage.Source.Component).extend()

RectColliderComponent.name = "RectColliderComponent"

RectColliderComponent.constructor = function(width: number, height: number)
	return {
		width = width,
		height = height,
	}
end

return RectColliderComponent