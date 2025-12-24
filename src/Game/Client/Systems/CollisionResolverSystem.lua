local CollisionResolverSystem = require(game.ReplicatedStorage.Source.System).extend()
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)

function CollisionResolverSystem:resolveCollision(entity1, entity2)

    if not self:hasComponent(entity1, EnemyTagComponent) then
        return
    end

    local pos1 = self:getComponent(entity1, PositionComponent)
    local pos2 = self:getComponent(entity2, PositionComponent)

    local acc1 = self:getComponent(entity1, AccelerationComponent)
    local acc2 = self:getComponent(entity2, AccelerationComponent)

    if not (pos1 and pos2 and acc1 and acc2) then
        return
    end

    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y

    local distSq = dx * dx + dy * dy
    if distSq == 0 then
        return
    end

    local dist = math.sqrt(distSq)

    local radius = 16
    local penetration = radius * 2 - dist
    if penetration <= 0 then
        return
    end

    dx /= dist
    dy /= dist

    -- parámetros suaves y controlados
    local stiffness = 2          -- MUY bajo
    local maxForce = 20          -- límite duro

    local force = penetration * stiffness
    if force > maxForce then
        force = maxForce
    end

    acc1.x = acc1.x + dx * force
    acc1.y = acc1.y + dy * force

    acc2.x = acc2.x - dx * force
    acc2.y = acc2.y - dy * force
end

function CollisionResolverSystem:init()
    
    self:on(OnCollideEvent, function(entity1, entity2)
        self:resolveCollision(entity1, entity2)
    end)

end

return CollisionResolverSystem