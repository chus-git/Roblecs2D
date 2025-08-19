local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local PlayerComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PlayerComponent)

local CollisionResolverSystem = require(game.ReplicatedStorage.Source.System).extend()

function CollisionResolverSystem:init()
    self:onFire(OnCollideEvent, function(entity1, entity2)
        self:resolveCollision(entity1, entity2)
    end)
end

---

function CollisionResolverSystem:resolveCollision(entity1, entity2)
    
    -- If player collides with a platform
    if self:hasComponent(entity1, PlayerComponent)

end

return CollisionResolverSystem