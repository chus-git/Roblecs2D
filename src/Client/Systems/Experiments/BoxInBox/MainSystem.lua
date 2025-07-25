local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local MainSystem = Utils.extend(System)

function MainSystem:load()
	self:on(Config.Events.CreateBox, function(x, y, width, height, vx, vy)
		self:createBox(x, y, width, height, vx, vy);
	end)
end

function MainSystem:createBox(x: number, y: number, width: number, height: number, vx: number, vy: number)
	self.box = self:createEntity()
	self.boxPosition = self:addComponent(self.box, Config.Components.Position, x, y)
	self.boxVelocity = self:addComponent(self.box, Config.Components.Velocity, vx, vy)
	self.boxInterpolation = self:addComponent(self.box, Config.Components.Interpolation, x, y)
	self:addComponent(self.box, Config.Components.Box, width, height)
	self:emit(Config.Events.BoxCreated, self.box)
end

return MainSystem
