local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local RectColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.RectColliderComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local MassComponent = require(game.ReplicatedStorage.Modules.Physics.Components.MassComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)

local PhysicsSystem = require(game.ReplicatedStorage.Source.System).extend()

local GRAVITY = 9.81 * 2

-- Desplaza en función de si las entidades son "móviles" y frena velocidad si colisiona recto
local function separate(self, e1, e2, pos1, pos2, dx, dy)
    local movable1 = self:hasComponent(e1, VelocityComponent)
    local movable2 = self:hasComponent(e2, VelocityComponent)

    if movable1 and movable2 then
        pos1.x = pos1.x + dx * 0.5
        pos1.y = pos1.y + dy * 0.5
        pos2.x = pos2.x - dx * 0.5
        pos2.y = pos2.y - dy * 0.5
        -- frenar velocidad si colisión recta
        if dx ~= 0 and dy == 0 then
            local v1 = self:getComponent(e1, VelocityComponent)
            local v2 = self:getComponent(e2, VelocityComponent)
            v1.x = 0
            v2.x = 0
        elseif dy ~= 0 and dx == 0 then
            local v1 = self:getComponent(e1, VelocityComponent)
            local v2 = self:getComponent(e2, VelocityComponent)
            v1.y = 0
            v2.y = 0
        end
    elseif movable1 then
        pos1.x = pos1.x + dx
        pos1.y = pos1.y + dy
        local v1 = self:getComponent(e1, VelocityComponent)
        if dx ~= 0 and dy == 0 then v1.x = 0 end
        if dy ~= 0 and dx == 0 then v1.y = 0 end
    elseif movable2 then
        pos2.x = pos2.x - dx
        pos2.y = pos2.y - dy
        local v2 = self:getComponent(e2, VelocityComponent)
        if dx ~= 0 and dy == 0 then v2.x = 0 end
        if dy ~= 0 and dx == 0 then v2.y = 0 end
    end
end

-- rect vs rect
local function resolveRectVsRect(self, e1, p1, c1, e2, p2, c2)
    local ax1, ax2 = p1.x - c1.width/2,  p1.x + c1.width/2
    local ay1, ay2 = p1.y - c1.height/2, p1.y + c1.height/2
    local bx1, bx2 = p2.x - c2.width/2,  p2.x + c2.width/2
    local by1, by2 = p2.y - c2.height/2, p2.y + c2.height/2

    local overlapX = math.min(ax2, bx2) - math.max(ax1, bx1)
    local overlapY = math.min(ay2, by2) - math.max(ay1, by1)

    if overlapX < overlapY then
        local dx = overlapX * (p1.x < p2.x and -1 or 1)
        separate(self, e1, e2, p1, p2, dx, 0)
    else
        local dy = overlapY * (p1.y < p2.y and -1 or 1)
        separate(self, e1, e2, p1, p2, 0, dy)
    end
end

-- circle vs circle
local function resolveCircleVsCircle(self, e1, p1, c1, e2, p2, c2)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local distSq = dx*dx + dy*dy
    local r = c1.radius + c2.radius

    if distSq == 0 then
        separate(self, e1, e2, p1, p2, r, 0)
        return
    end

    local dist = math.sqrt(distSq)
    local overlap = r - dist
    if overlap > 0 then
        local nx, ny = dx/dist, dy/dist
        separate(self, e1, e2, p1, p2, -nx*overlap, -ny*overlap)
    end
end

-- rect vs circle
local function resolveRectVsCircle(self, erect, prect, crect, ecirc, pcirc, ccirc)
    local rx1 = prect.x - crect.width/2
    local rx2 = prect.x + crect.width/2
    local ry1 = prect.y - crect.height/2
    local ry2 = prect.y + crect.height/2

    local cx, cy = pcirc.x, pcirc.y
    local closestX = math.max(rx1, math.min(cx, rx2))
    local closestY = math.max(ry1, math.min(cy, ry2))

    local dx = cx - closestX
    local dy = cy - closestY
    local distSq = dx*dx + dy*dy

    if distSq == 0 then
        if math.abs(cx - prect.x) > math.abs(cy - prect.y) then
            local dir = (cx < prect.x) and -1 or 1
            if self:hasComponent(ecirc, VelocityComponent) then
                pcirc.x = pcirc.x + dir * ccirc.radius
                local v = self:getComponent(ecirc, VelocityComponent)
                v.x = 0
            end
        else
            local dir = (cy < prect.y) and -1 or 1
            if self:hasComponent(ecirc, VelocityComponent) then
                pcirc.y = pcirc.y + dir * ccirc.radius
                local v = self:getComponent(ecirc, VelocityComponent)
                v.y = 0
            end
        end
        return
    end

    local dist = math.sqrt(distSq)
    local overlap = ccirc.radius - dist
    if overlap > 0 then
        local nx, ny = dx/dist, dy/dist
        if self:hasComponent(ecirc, VelocityComponent) then
            pcirc.x = pcirc.x + nx * overlap
            pcirc.y = pcirc.y + ny * overlap
            local v = self:getComponent(ecirc, VelocityComponent)
            if math.abs(nx) > 0 and ny == 0 then v.x = 0 end
            if math.abs(ny) > 0 and nx == 0 then v.y = 0 end
        end
    end
end

------------------------------------------------
-- dentro de tu PhysicsSystem
------------------------------------------------
function PhysicsSystem:resolveCollision(e1, e2)

    local p1 = self:getComponent(e1, PositionComponent)
    local p2 = self:getComponent(e2, PositionComponent)

    local r1 = self:hasComponent(e1, RectColliderComponent) and self:getComponent(e1, RectColliderComponent)
    local r2 = self:hasComponent(e2, RectColliderComponent) and self:getComponent(e2, RectColliderComponent)
    local c1 = self:hasComponent(e1, CircleColliderComponent) and self:getComponent(e1, CircleColliderComponent)
    local c2 = self:hasComponent(e2, CircleColliderComponent) and self:getComponent(e2, CircleColliderComponent)

    if r1 and r2 then
        resolveRectVsRect(self, e1, p1, r1, e2, p2, r2)
    elseif c1 and c2 then
        resolveCircleVsCircle(self, e1, p1, c1, e2, p2, c2)
    elseif r1 and c2 then
        resolveRectVsCircle(self, e1, p1, r1, e2, p2, c2)
    elseif r2 and c1 then
        resolveRectVsCircle(self, e2, p2, r2, e1, p1, c1)
    end
    
end

---

function PhysicsSystem:init()
    self:onFire(OnCollideEvent, function(e1, e2)
        self:resolveCollision(e1, e2)
    end)
end

function PhysicsSystem:update(dt)

    -- Actualizar velocidad de entidades con masa
    local entitiesWithMass = self:getEntitiesWithComponent(MassComponent)
    for _, entity in ipairs(entitiesWithMass) do

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
    for _, entity in ipairs(entitiesWithVelocity) do

        local position = self:getComponent(entity, PositionComponent)
        local velocity = self:getComponent(entity, VelocityComponent)

        -- Actualizar posición según la velocidad
        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt
        
        print(position.y)

    end

end

return PhysicsSystem