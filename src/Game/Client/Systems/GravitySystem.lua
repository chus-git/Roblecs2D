local GravitySystem = require(game.ReplicatedStorage.Source.System).extend()

local ParticleTagComponent = require(game.ReplicatedStorage.Components.ParticleTagComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

local ChangeGravityEvent = require(game.ReplicatedStorage.Events.ChangeGravityEvent)

function GravitySystem:init()

    self.gravityForce = -9.81

    self:on(ChangeGravityEvent, function(gravity)
        self.gravityForce = gravity * -1
    end)

end

function GravitySystem:update(dt)

    local particles = self:getEntitiesWithComponent(ParticleTagComponent)

    for _, particle in pairs(particles) do
        local accComp = self:getComponent(particle, AccelerationComponent)
        
        -- Solo modificamos la aceleración
        accComp.y = self.gravityForce
    end
end

return GravitySystem