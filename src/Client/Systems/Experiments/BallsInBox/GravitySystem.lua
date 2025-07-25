local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local GravitySystem = Utils.extend(System)

function GravitySystem:load()
	self.balls = {}
	self.gravity = -196
	self.random = math.random()
	
end

function GravitySystem:afterLoad()
	self:on(Config.Events.BallCreated, function(ballId)
		table.insert(self.balls, ballId)
	end)
end

function GravitySystem:update(dt)
	for i, ballId in ipairs(self.balls) do
		local velocity = self:getComponent(ballId, Config.Components.Velocity)
		local mass = self:getComponent(ballId, Config.Components.Mass)
		velocity.y = velocity.y + self.gravity * dt
	end
end

function GravitySystem:unload()
	System.unload(self)
end

return GravitySystem
