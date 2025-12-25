local BoundingSystem = require(game.ReplicatedStorage.Source.System).extend()

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)
local ContainerTagComponent = require(game.ReplicatedStorage.Components.ContainerTagComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)

function BoundingSystem:update(dt)
    local balls = self:getEntitiesWithComponent(BallTagComponent)
    local container = self:getEntityWithComponent(ContainerTagComponent)
    
    if not container then return end

    local cPos = self:getComponent(container, PositionComponent)
    local cSize = self:getComponent(container, SizeComponent)
    local cRadius = cSize.width / 2

    for _, ball in pairs(balls) do
        local bPos = self:getComponent(ball, PositionComponent)
        local bVel = self:getComponent(ball, VelocityComponent)
        local bRadius = self:getComponent(ball, CircleColliderComponent).radius

        local dx = bPos.x - cPos.x
        local dy = bPos.y - cPos.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if (dist + bRadius) >= cRadius then
            local nx = dx / dist
            local ny = dy / dist

            local safeDist = cRadius - bRadius
            bPos.x = cPos.x + (nx * safeDist)
            bPos.y = cPos.y + (ny * safeDist)

            local dot = (bVel.x * nx) + (bVel.y * ny)

            if dot > 0 then
                bVel.x = bVel.x - (2 * dot * nx)
                bVel.y = bVel.y - (2 * dot * ny)
            end
        end
    end
end

return BoundingSystem