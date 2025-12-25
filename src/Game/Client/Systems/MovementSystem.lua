local MovementSystem = require(game.ReplicatedStorage.Source.System).extend()
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

function MovementSystem:update(dt)

    local entities = self:getEntitiesWithComponent(VelocityComponent)

    local maxSpeed = 100          -- velocidad máxima absoluta
    
    for _, entity in pairs(entities) do
        
        local position = self:getComponent(entity, PositionComponent)
        local velocity = self:getComponent(entity, VelocityComponent)
        local acceleration = self:getComponent(entity, AccelerationComponent)

        -- integrar aceleración → velocidad
        velocity.x = velocity.x + acceleration.x * dt
        velocity.y = velocity.y + acceleration.y * dt

        -- clamp de velocidad
        local speedSq = velocity.x * velocity.x + velocity.y * velocity.y
        local maxSpeedSq = maxSpeed * maxSpeed

        if speedSq > maxSpeedSq then
            local speed = math.sqrt(speedSq)
            velocity.x = velocity.x / speed * maxSpeed
            velocity.y = velocity.y / speed * maxSpeed
        end

        -- integrar velocidad → posición
        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt

        -- limpiar aceleración
        acceleration.x = 0
        acceleration.y = 0

    end
end

return MovementSystem