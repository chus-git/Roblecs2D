local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local RectColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.RectColliderComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local MassComponent = require(game.ReplicatedStorage.Modules.Physics.Components.MassComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)

local PhysicsSystem = require(game.ReplicatedStorage.Source.System).extend()

local GRAVITY = 9.81 * 2

function PhysicsSystem:update(dt)

    -- Actualizar velocidad de entidades con masa
    local entitiesWithMass = self:getEntitiesWithComponent(MassComponent)
    for _, entity in pairs(entitiesWithMass) do

        local position = self:getComponent(entity, PositionComponent)
        local mass = self:getComponent(entity, MassComponent)
        
        -- Aplicar gravedad
        local velocityComponent = self:getComponent(entity, VelocityComponent)
        if not velocityComponent then
            velocityComponent = self:addComponent(entity, VelocityComponent(0, 0))
        end
        
        velocityComponent.y = velocityComponent.y - GRAVITY * dt

    end

    -- Actualizar posición de entidades con velocidad
    local entitiesWithVelocity = self:getEntitiesWithComponent(VelocityComponent)
    for _, entity in pairs(entitiesWithVelocity) do

        local position = self:getComponent(entity, PositionComponent)
        local velocity = self:getComponent(entity, VelocityComponent)

        -- Actualizar posición según la velocidad
        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt

    end

end

return PhysicsSystem