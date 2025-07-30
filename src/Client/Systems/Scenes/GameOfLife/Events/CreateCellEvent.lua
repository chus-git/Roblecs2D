local CreateCellEvent = require(game.ReplicatedStorage.Core.Event).extend()

CreateCellEvent.name = "CreateCellEvent"

CreateCellEvent.constructor = function(x: number, y: number, alive: boolean)
	return x, y, alive
end

return CreateCellEvent