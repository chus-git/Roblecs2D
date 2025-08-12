local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local ElementManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

function ElementManagerSystem:init()

    self:on("CreateBallEvent", function()
        self:createBall()
    end)

end

---

function ElementManagerSystem:createBall()
    local entityId = self:createEntity()
    self:addComponent(entityId, SpriteComponent("rbxassetid://132488562992832"))
    return entityId
end

return ElementManagerSystem