local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:load()
	
    local spriteId = self:createEntity()
    local position = self:addComponent(spriteId, PositionComponent(0, 0))
    local sprite = self:addComponent(spriteId, SpriteComponent("rbxassetid://101659716364845", 100, 100))

end

return MainSystem