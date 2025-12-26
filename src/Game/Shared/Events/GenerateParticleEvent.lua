local GenerateParticleEvent = require(game.ReplicatedStorage.Source.Event).extend()

GenerateParticleEvent.name = "GenerateParticleEvent"

GenerateParticleEvent.constructor = function(x: number, y: number)
	return x, y
end

return GenerateParticleEvent