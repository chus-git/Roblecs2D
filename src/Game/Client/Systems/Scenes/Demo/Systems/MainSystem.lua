local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.entities = {}

    self.accumultatedTime = 0

end


function MainSystem:render(dt, alpha)
    
    self.accumultatedTime += dt

    if self.accumultatedTime > 0.5 then
        
        self.accumultatedTime = 0
        local entityId = self:createEntity()
        local sprite = self:addComponent(entityId, SpriteComponent("rbxassetid://132488562992832"))
        self.entities[entityId] = entityId

    end

end

function MainSystem:afterUpdate(dt)
    for entityId, entity in pairs(self.entities) do
        if not self:hasComponent(entityId, PositionComponent) then
            continue
        end
        local positionComponent = self:getComponent(entityId, PositionComponent)
        local rotationComponent = self:getComponent(entityId, RotationComponent)
        positionComponent.x += 5 * dt
        positionComponent.y += 0
        rotationComponent.angle += dt
    end
end

return MainSystem