local ChangeSimulationSpeedEvent = require(game.ReplicatedStorage.Source.Event).extend()

ChangeSimulationSpeedEvent.name = "ChangeSimulationSpeedEvent"

ChangeSimulationSpeedEvent.constructor = function(speed)
	return speed
end

return ChangeSimulationSpeedEvent