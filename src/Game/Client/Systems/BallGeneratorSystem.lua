local BallGeneratorSystem = require(game.ReplicatedStorage.Source.System).extend()

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)

local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

function BallGeneratorSystem:generateBall(position: Vector2)
    local ball = self:createEntity()
    self:addComponent(ball, BallTagComponent())
    self:addComponent(ball, SpriteComponent(Sprites.BALL))
    self:addComponent(ball, PositionComponent(position.X, position.Y))
    self:addComponent(ball, VelocityComponent(0, 0))
    self:addComponent(ball, AccelerationComponent(0, 0))
    self:addComponent(ball, SizeComponent(1, 1))
    self:addComponent(ball, CircleColliderComponent(0.5))
end

function BallGeneratorSystem:init()
    
    -- Create invisible plane
    local clickPlane = Instance.new("Part")
    clickPlane.Size = Vector3.new(1000, 1000, 0.1)
    clickPlane.Anchored = true
    clickPlane.CanCollide = false
    clickPlane.Transparency = 1
    clickPlane.Position = Vector3.new(0, 0, -1)
    clickPlane.Parent = Workspace

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            local mouseRay = Camera:ScreenPointToRay(input.Position.X, input.Position.Y)
            local raycastResult = Workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, RaycastParams.new())
            if raycastResult and raycastResult.Instance == clickPlane then
                local hitPos = raycastResult.Position
                self:generateBall(Vector2.new(-hitPos.X, hitPos.Y))
            end
        end
    end)

end

return BallGeneratorSystem