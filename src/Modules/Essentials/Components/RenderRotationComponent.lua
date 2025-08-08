local RenderRotationComponent = require(game.ReplicatedStorage.Source.Component).extend()

RenderRotationComponent.name = "RenderRotationComponent"

RenderRotationComponent.constructor = function(angle)
	return {
		angle = angle,
	}
end

return RenderRotationComponent