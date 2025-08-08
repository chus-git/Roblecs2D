local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.entities = {}

    for x = -50, 0 do
        for y = -5, 5 do
            local entityId = self:createEntity()
            self:addComponent(entityId, PositionComponent(x * 1, y * 1))
            self:addComponent(entityId, SizeComponent(1, 1))
            self:addComponent(entityId, RotationComponent(0))
            self:addComponent(entityId, SpriteComponent("rbxassetid://132488562992832"))
            self.entities[entityId] = entityId
        end
    end

end

function MainSystem:update(dt)
    for entityId, entity in pairs(self.entities) do
        local positionComponent = self:getComponent(entityId, PositionComponent)
        local rotationComponent = self:getComponent(entityId, RotationComponent)
        positionComponent.x += 5 * dt
        positionComponent.y += 0
        --rotationComponent.angle += dt
    end
end

return MainSystem