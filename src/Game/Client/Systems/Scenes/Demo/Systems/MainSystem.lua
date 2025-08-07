local CreateSpriteEvent = require(game.ReplicatedStorage.Events.CreateSpriteEvent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:afterLoad()
	
	self:emit(CreateSpriteEvent("rbxassetid://101659716364845", 0, 0, 10, 10))
	
end

return MainSystem