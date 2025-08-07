local CreateCellEvent = require(game.ReplicatedStorage.Source.Event).extend()

CreateCellEvent.name = "CreateCellEvent"

CreateCellEvent.constructor = function(x: number, y: number, alive: boolean)
	return x, y, alive
end

return CreateCellEvent