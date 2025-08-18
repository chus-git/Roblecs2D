local CircleColliderComponent = require(game.ReplicatedStorage.Source.Component).extend()

CircleColliderComponent.name = "CircleColliderComponent"

CircleColliderComponent.constructor = function(radius: number)
	return {
		radius = radius
	}
end

return CircleColliderComponent