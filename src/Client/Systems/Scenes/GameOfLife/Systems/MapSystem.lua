local CreateCellEvent = require(script.Parent.Parent.Events.CreateCellEvent)

local MapSystem = require(game.ReplicatedStorage.Core.System).extend()

function MapSystem:load()
	self:on(CreateCellEvent, function(x, y, alive)
		print(string.format("Creating cell at (%d, %d) with state %s", x, y, tostring(alive)))
	end)
end

return MapSystem