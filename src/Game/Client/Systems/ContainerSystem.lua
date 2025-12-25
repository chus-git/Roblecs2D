local ContainerSystem = require(game.ReplicatedStorage.Source.System).extend()
local ContainerTagComponent = require(game.ReplicatedStorage.Components.ContainerTagComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function ContainerSystem:init()
    local container = self:createEntity()
    self:addComponent(container, ContainerTagComponent())
    self:addComponent(container, SpriteComponent(Sprites.CONTAINER))
    self:addComponent(container, SizeComponent(18, 18))
    self:addComponent(container, PositionComponent(0, 0))
end

return ContainerSystem
