local SizeComponent = require(game.ReplicatedStorage.Source.Component).extend()

SizeComponent.name = "SizeComponent"

SizeComponent.constructor = function(width: number, height: number)
	return {
		width = width,
        height = height
	}
end

return SizeComponent