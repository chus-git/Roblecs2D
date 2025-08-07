local SpriteComponent = require(game.ReplicatedStorage.Source.Component).extend()

SpriteComponent.name = "SpriteComponent"

SpriteComponent.constructor = function(imageId: string, width: number, height: number)
	return {
		imageId = imageId,
		width = width,
		height = height
	}
end

return SpriteComponent