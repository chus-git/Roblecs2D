local MovementSystem = require(game.ReplicatedStorage.Source.System).extend()

local ParticleTagComponent = require(game.ReplicatedStorage.Components.ParticleTagComponent)

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

    local particles = self:getEntitiesWithComponent(ParticleTagComponent)

    for _, particle in pairs(particles) do

        local positionComponent = self:getComponent(particle, PositionComponent)
        local velocityComponent = self:getComponent(particle, VelocityComponent)
        local accelerationComponent = self:getComponent(particle, AccelerationComponent)

        velocityComponent.x = velocityComponent.x + accelerationComponent.x * realDt
        velocityComponent.y = velocityComponent.y + accelerationComponent.y * realDt

        positionComponent.x = positionComponent.x + velocityComponent.x * realDt
        positionComponent.y = positionComponent.y + velocityComponent.y * realDt

    end

end

return MovementSystem
