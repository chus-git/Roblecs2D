local MovementSystem = require(game.ReplicatedStorage.Source.System).extend()

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)

local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

local ChangeSimulationSpeedEvent = require(game.ReplicatedStorage.Events.ChangeSimulationSpeedEvent)

function MovementSystem:init()

    self.simulationSpeed = 1

    self:on(ChangeSimulationSpeedEvent, function(speed)
        if speed == nil then
            speed = 1
        end
        self.simulationSpeed = speed
    end)

end

function MovementSystem:update(dt)
    
    local realDt = dt * self.simulationSpeed

    local balls = self:getEntitiesWithComponent(BallTagComponent)

    for _, ball in pairs(balls) do

        local positionComponent = self:getComponent(ball, PositionComponent)
        local velocityComponent = self:getComponent(ball, VelocityComponent)
        local accelerationComponent = self:getComponent(ball, AccelerationComponent)

        velocityComponent.x = velocityComponent.x + accelerationComponent.x * realDt
        velocityComponent.y = velocityComponent.y + accelerationComponent.y * realDt

        positionComponent.x = positionComponent.x + velocityComponent.x * realDt
        positionComponent.y = positionComponent.y + velocityComponent.y * realDt

    end

end

return MovementSystem
