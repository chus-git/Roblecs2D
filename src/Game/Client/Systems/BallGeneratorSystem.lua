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

local GenerateBallEvent = require(game.ReplicatedStorage.Events.GenerateBallEvent)

function BallGeneratorSystem:init()
    self:on(GenerateBallEvent, function(x: number, y: number)
        self:generateBall(Vector2.new(x, y))
    end)
    self:generateBall(Vector2.new(1, 5))
end

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

return BallGeneratorSystem