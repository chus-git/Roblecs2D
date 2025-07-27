local Circle = require(game.ReplicatedStorage.Core.Component).extend()

Circle.name = "Circle"

Circle.constructor = function(radius: number, color: Color3, position: Vector2)
	return {
		radius = radius,
		color = color,
		position = position,
	}
end

return Circle