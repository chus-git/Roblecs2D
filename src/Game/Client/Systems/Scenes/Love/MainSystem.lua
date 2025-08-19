local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local RectColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.RectColliderComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local MassComponent = require(game.ReplicatedStorage.Modules.Physics.Components.MassComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.boy = self:createEntity()
    local boyPosition = self:addComponent(self.boy, PositionComponent(0, 5))
    local boySize = self:addComponent(self.boy, SizeComponent(1, 1))
    self:addComponent(self.boy, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.boy, CircleColliderComponent(0.5))
    self:addComponent(self.boy, MassComponent(1))

    self.girl = self:createEntity()
    local girlPosition = self:addComponent(self.girl, PositionComponent(0, 10))
    local girlSize = self:addComponent(self.girl, SizeComponent(1, 1))
    self:addComponent(self.girl, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.girl, CircleColliderComponent(0.5))
    self:addComponent(self.girl, MassComponent(1))

    self.girl2 = self:createEntity()
    self:addComponent(self.girl2, PositionComponent(0, 15))
    self:addComponent(self.girl2, SizeComponent(1, 1))
    self:addComponent(self.girl2, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.girl2, CircleColliderComponent(0.5))
    self:addComponent(self.girl2, MassComponent(1))

    self.girl3 = self:createEntity()
    self:addComponent(self.girl3, PositionComponent(0, 20))
    self:addComponent(self.girl3, SizeComponent(1, 1))
    self:addComponent(self.girl3, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.girl3, CircleColliderComponent(0.5))
    self:addComponent(self.girl3, MassComponent(1))

    self.girl4 = self:createEntity()
    self:addComponent(self.girl4, PositionComponent(0, 25))
    self:addComponent(self.girl4, SizeComponent(1, 1))
    self:addComponent(self.girl4, SpriteComponent("rbxassetid://132488562992832"))
    self:addComponent(self.girl4, CircleColliderComponent(0.5))
    self:addComponent(self.girl4, MassComponent(1))

    self.platform = self:createEntity()
    self:addComponent(self.platform, PositionComponent(0, 0))
    local platformSize = self:addComponent(self.platform, SizeComponent(5, 1))
    self:addComponent(self.platform, RectColliderComponent(5, 1))
    self:addComponent(self.platform, SpriteComponent("rbxassetid://132488562992832"))

    local UserInputService = game:GetService("UserInputService")

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        local vel = self:getComponent(self.boy, VelocityComponent)
        if input.KeyCode == Enum.KeyCode.Space then
            vel.y = 10 -- salto
        elseif input.KeyCode == Enum.KeyCode.A then
            vel.x = -5
        elseif input.KeyCode == Enum.KeyCode.D then
            vel.x = 5
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local vel = self:getComponent(self.boy, VelocityComponent)
        if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
            -- Si la velocidad actual coincide con la tecla que se soltó, la ponemos a 0
            if (input.KeyCode == Enum.KeyCode.A and vel.x < 0) or (input.KeyCode == Enum.KeyCode.D and vel.x > 0) then
                vel.x = 0
            end
        end
    end)


end

function MainSystem:update(dt)
    
end

---

function MainSystem:loadLevel()
    
end

return MainSystem