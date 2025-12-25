local MovementSystem = require(game.ReplicatedStorage.Source.System).extend()

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)

local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

function MovementSystem:update(dt)
    
    local balls = self:getEntitiesWithComponent(BallTagComponent)

    for _, ball in pairs(balls) do

        -- Move the ball due to its velocity calculated from acceleration
        local positionComponent = self:getComponent(ball, PositionComponent)
        local velocityComponent = self:getComponent(ball, VelocityComponent)
        local accelerationComponent = self:getComponent(ball, AccelerationComponent)

        -- Update velocity based on acceleration
        velocityComponent.x = velocityComponent.x + accelerationComponent.x * dt
        velocityComponent.y = velocityComponent.y + accelerationComponent.y * dt

        -- Update position based on velocity
        positionComponent.x = positionComponent.x + velocityComponent.x * dt
        positionComponent.y = positionComponent.y + velocityComponent.y * dt

    end

end

return MovementSystem
