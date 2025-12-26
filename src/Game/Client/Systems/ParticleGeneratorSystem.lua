local ParticleGeneratorSystem = require(game.ReplicatedStorage.Source.System).extend()

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

local ParticleTagComponent = require(game.ReplicatedStorage.Components.ParticleTagComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)

local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local GenerateParticleEvent = require(game.ReplicatedStorage.Events.GenerateParticleEvent)

function ParticleGeneratorSystem:init()

    self:on(GenerateParticleEvent, function(x: number, y: number)
        self:generateParticle(Vector2.new(x, y))
    end)

end

function ParticleGeneratorSystem:generateParticle(position: Vector2)
    local particle = self:createEntity()
    self:addComponent(particle, ParticleTagComponent())
    self:addComponent(particle, SpriteComponent(Sprites.BALL))
    self:addComponent(particle, PositionComponent(position.X, position.Y))
    self:addComponent(particle, VelocityComponent(0, 0))
    self:addComponent(particle, AccelerationComponent(0, 0))
    self:addComponent(particle, SizeComponent(0.5, 0.5))
    self:addComponent(particle, CircleColliderComponent(0.25))
end

return ParticleGeneratorSystem