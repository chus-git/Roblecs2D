local CreateCellEvent = require(script.Parent.Parent.Events.CreateCellEvent)

local GenerateMapSystem = require(game.ReplicatedStorage.Core.System).extend()

function GenerateMapSystem:afterLoad()
	for x = -1, 1 do
		for y = -1, 1 do
			self:emit(CreateCellEvent(x, y, false))
		end
	end
end

return GenerateMapSystem