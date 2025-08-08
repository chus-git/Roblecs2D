local SpriteComponent = require(game.ReplicatedStorage.Source.Component).extend()

SpriteComponent.name = "SpriteComponent"

SpriteComponent.constructor = function(imageId: string)
	return {
		imageId = imageId
	}
end

return SpriteComponent