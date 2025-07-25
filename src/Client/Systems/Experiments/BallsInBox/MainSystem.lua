local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local MainSystem = Utils.extend(System)

function MainSystem:load()
	self.balls = {}
end

function MainSystem:afterLoad()
	self:on(Config.Events.CreateBall, function(x, y)
		self:createBall(x, y);
	end)
end

function MainSystem:createBall(x: number, y: number)
	local ball = self:createEntity()
	local ballPosition = self:addComponent(ball, Config.Components.Position, x, y)
	local ballVelocity = self:addComponent(ball, Config.Components.Velocity, 0, 0)
	local allMass = self:addComponent(ball, Config.Components.Mass, 35)
	local ballInterpolation = self:addComponent(ball, Config.Components.Interpolation, x, y)
	self.balls[ball] = self:addComponent(ball, Config.Components.Ball, 4)
	self:emit(Config.Events.BallCreated, ball)
end

function MainSystem:unload()
	for ballId, ball in pairs(self.balls) do
		self:destroyEntity(ballId)
	end
	System.unload(self)
end

return MainSystem
