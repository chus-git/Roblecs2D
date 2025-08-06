local CellCreatedEvent = require(game.ReplicatedStorage.Kernel.Event).extend()

CellCreatedEvent.name = "CellCreatedEvent"

CellCreatedEvent.constructor = function(id: number)
	return id
end

return CellCreatedEvent