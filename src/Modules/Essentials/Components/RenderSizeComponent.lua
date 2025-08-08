local RenderSizeComponent = require(game.ReplicatedStorage.Source.Component).extend()

RenderSizeComponent.name = "RenderSizeComponent"

RenderSizeComponent.constructor = function(width: number, height: number)
	return {
		width = width,
		height = height,
	}
end

return RenderSizeComponent