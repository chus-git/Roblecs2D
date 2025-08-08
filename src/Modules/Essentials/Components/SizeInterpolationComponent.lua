local SizeInterpolationComponent = require(game.ReplicatedStorage.Source.Component).extend()

SizeInterpolationComponent.name = "SizeInterpolationComponent"

SizeInterpolationComponent.constructor = function(width: number, height: number)
	return {
		previous = {
            width = width,
            height = height
        },
        target = {
            width = width,
            height = height
        }
	}
end

return SizeInterpolationComponent