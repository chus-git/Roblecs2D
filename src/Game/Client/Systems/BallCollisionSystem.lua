local BallCollisionSystem = require(game.ReplicatedStorage.Source.System).extend()

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)

local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)

function BallCollisionSystem:init()

    self:onFire(OnCollideEvent, function(entityA, entityB)
        
        local isBallA = self:hasComponent(entityA, BallTagComponent)
        local isBallB = self:hasComponent(entityB, BallTagComponent)

        if isBallA and isBallB then
            local posA = self:getComponent(entityA, PositionComponent)
            local velA = self:getComponent(entityA, VelocityComponent)
            local radiusA = self:getComponent(entityA, CircleColliderComponent).radius

            local posB = self:getComponent(entityB, PositionComponent)
            local velB = self:getComponent(entityB, VelocityComponent)
            local radiusB = self:getComponent(entityB, CircleColliderComponent).radius

            local dx = posB.x - posA.x
            local dy = posB.y - posA.y
            local dist = math.sqrt(dx*dx + dy*dy)

            if dist == 0 then return end

            local nx = dx / dist
            local ny = dy / dist

            local overlap = (radiusA + radiusB) - dist
            if overlap > 0 then
                -- Corrección de posición
                posA.x = posA.x - (nx * (overlap / 2))
                posA.y = posA.y - (ny * (overlap / 2))
                posB.x = posB.x + (nx * (overlap / 2))
                posB.y = posB.y + (ny * (overlap / 2))

                -- Velocidad relativa
                local dvx = velA.x - velB.x
                local dvy = velA.y - velB.y
                
                -- Producto punto de la velocidad relativa sobre la normal
                local dot = (dvx * nx) + (dvy * ny)

                -- Solo rebotar si se están acercando
                if dot > 0 then
                    -- Para colisión elástica de masas iguales:
                    -- El impulso escalar es exactamente el dot product
                    velA.x = velA.x - (dot * nx)
                    velA.y = velA.y - (dot * ny)
                    velB.x = velB.x + (dot * nx)
                    velB.y = velB.y + (dot * ny)
                end
            end
        end
    end)
end

return BallCollisionSystem