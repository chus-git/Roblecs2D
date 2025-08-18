local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local RectColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.RectColliderComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.boy = self:createEntity()
    self:addComponent(self.boy, PositionComponent(0, -2))
    local boySize = self:addComponent(self.boy, SizeComponent(1, 1))
    self:addComponent(self.boy, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.boy, RectColliderComponent(boySize.width, boySize.height))

    self.platform = self:createEntity()
    self:addComponent(self.platform, PositionComponent(0, 0))
    local platformSize = self:addComponent(self.platform, SizeComponent(1, 1))
    self:addComponent(self.platform, RotationComponent(0))
    self:addComponent(self.platform, RectColliderComponent(platformSize.width, platformSize.height))
    self:addComponent(self.platform, SpriteComponent("rbxassetid://132488562992832"))

end

function MainSystem:update(dt)
    self.boyPosition = self:getComponent(self.boy, PositionComponent)
    self.boyPosition.y += 0.2 * dt
end

---

function MainSystem:loadLevel()
    
end

return MainSystem