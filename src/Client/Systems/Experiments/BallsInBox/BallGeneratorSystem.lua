local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local BallGeneratorSystem = Utils.extend(System)

function BallGeneratorSystem:load()
	self.timer = 0
	self.ballsGenerated = 0
end

function BallGeneratorSystem:update(dt)
	self.timer -= dt
	if self.timer < 0 and self.ballsGenerated < 100 then
		self.timer = self.timer + 0.1
		local angle = math.random() * 2 * math.pi
		local radius = math.sqrt(math.random()) * 100
		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius
		self.eventBus:emit("CreateBall", x, y)
		self.ballsGenerated += 1
	end
end

return BallGeneratorSystem
