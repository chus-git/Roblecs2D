local CreateSpriteEvent = require(game.ReplicatedStorage.Source.Event).extend()

CreateSpriteEvent.name = "CreateSpriteEvent"

CreateSpriteEvent.constructor = function(imageId: string, x: number, y: number, width: number, height: number)
	return imageId, x, y, width, height
end

return CreateSpriteEvent