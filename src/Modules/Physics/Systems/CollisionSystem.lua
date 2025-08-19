local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local RectColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.RectColliderComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)

local CollisionSystem = require(game.ReplicatedStorage.Source.System).extend()

local MAX_ENTITY_SIZE = 1
local cellSize = MAX_ENTITY_SIZE * 1

-- Helpers
local function getCellCoords(x, y)
    return math.floor(x / cellSize), math.floor(y / cellSize)
end

local function insertEntity(entity, collider, pos, rotation, grid)

    local minX, maxX, minY, maxY

    if collider.width then
        minX = pos.x - collider.width / 2
        maxX = pos.x + collider.width / 2
        minY = pos.y - collider.height / 2
        maxY = pos.y + collider.height / 2
    elseif collider.radius then
        minX = pos.x - collider.radius
        maxX = pos.x + collider.radius
        minY = pos.y - collider.radius
        maxY = pos.y + collider.radius
    else
        return
    end

    local minCellX, minCellY = getCellCoords(minX, minY)
    local maxCellX, maxCellY = getCellCoords(maxX, maxY)

    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            local key = cx .. "," .. cy
            grid[key] = grid[key] or {}
            table.insert(grid[key], {
                entity = entity,
                collider = collider,
                pos = pos,
                rotation = rotation
            })
        end
    end
end

-- AABB vs AABB
local function rectVsRect(a, b)
    local ax1 = a.pos.x - a.collider.width/2
    local ax2 = a.pos.x + a.collider.width/2
    local ay1 = a.pos.y - a.collider.height/2
    local ay2 = a.pos.y + a.collider.height/2

    local bx1 = b.pos.x - b.collider.width/2
    local bx2 = b.pos.x + b.collider.width/2
    local by1 = b.pos.y - b.collider.height/2
    local by2 = b.pos.y + b.collider.height/2

    return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

-- Circle vs Circle
local function circleVsCircle(a, b)
    local dx = a.pos.x - b.pos.x
    local dy = a.pos.y - b.pos.y
    local r = a.collider.radius + b.collider.radius
    return dx*dx + dy*dy <= r*r
end

-- Rect vs Circle
local function rectVsCircle(rect, circle)
    local rx1 = rect.pos.x - rect.collider.width/2
    local rx2 = rect.pos.x + rect.collider.width/2
    local ry1 = rect.pos.y - rect.collider.height/2
    local ry2 = rect.pos.y + rect.collider.height/2

    local cx, cy = circle.pos.x, circle.pos.y
    local closestX = math.max(rx1, math.min(cx, rx2))
    local closestY = math.max(ry1, math.min(cy, ry2))

    local dx = cx - closestX
    local dy = cy - closestY
    return (dx*dx + dy*dy) <= circle.collider.radius^2
end

-- Sistema
function CollisionSystem:init()
    self.grid = {}
end

function CollisionSystem:update(dt)
    self.grid = {}

    -- Insert entities
    for _, e in pairs(self:getEntitiesWithComponent(RectColliderComponent)) do
        local pos = self:getComponent(e, PositionComponent)
        local collider = self:getComponent(e, RectColliderComponent)
        local rotation = self:hasComponent(e, RotationComponent) and self:getComponent(e, RotationComponent) or nil
        insertEntity(e, collider, pos, rotation, self.grid)
    end
    
    for _, e in pairs(self:getEntitiesWithComponent(CircleColliderComponent)) do
        local pos = self:getComponent(e, PositionComponent)
        local collider = self:getComponent(e, CircleColliderComponent)
        insertEntity(e, collider, pos, nil, self.grid)
    end

    -- Check collisions per cell
    for _, cell in pairs(self.grid) do
        for i = 1, #cell do
            for j = i+1, #cell do
                local a, b = cell[i], cell[j]
                local collided = false
                if a.collider.width and b.collider.width then
                    collided = rectVsRect(a, b)
                elseif a.collider.radius and b.collider.radius then
                    collided = circleVsCircle(a, b)
                else
                    if a.collider.width then
                        collided = rectVsCircle(a, b)
                    else
                        collided = rectVsCircle(b, a)
                    end
                end
                if collided then
                    self:emit(OnCollideEvent(a.entity, b.entity))
                    self:fire(OnCollideEvent(a.entity, b.entity))
                end
            end
        end
    end
end

return CollisionSystem
