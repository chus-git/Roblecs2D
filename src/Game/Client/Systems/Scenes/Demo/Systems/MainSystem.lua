local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.entities = {}

    for x = -10, 10 do
        for y = -5, 5 do
            local entityId = self:createEntity()
            local entity = self:addComponent(entityId, PositionComponent(x * 2, y * 2))
            local rotation = self:addComponent(entityId, RotationComponent(0))
            self:addComponent(entityId, SpriteComponent("rbxassetid://132488562992832", 2, 2))
            self.entities[entityId] = entity
        end
    end

end

function MainSystem:update(dt)
    for entityId, entity in pairs(self.entities) do
        local positionComponent = self:getComponent(entityId, PositionComponent)
        local rotationComponent = self:getComponent(entityId, RotationComponent)
        positionComponent.x += 5 * dt
        positionComponent.y += 0
        rotationComponent.angle += dt
    end
end

return MainSystem