local MassComponent = require(game.ReplicatedStorage.Source.Component).extend()

MassComponent.name = "MassComponent"

MassComponent.constructor = function(mass)
	return {
		mass = mass
	}
end

return MassComponent