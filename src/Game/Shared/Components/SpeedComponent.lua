local SpeedComponent = require(game.ReplicatedStorage.Source.Component).extend()

SpeedComponent.name = "SpeedComponent"

SpeedComponent.constructor = function(speed: number)
	return {
		speed = speed
	}
end

return SpeedComponent