local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local BoxGeneratorSystem = Utils.extend(System)

function BoxGeneratorSystem:load()
	self.timer = 0
	self.boxesGenerated = 0
end

function BoxGeneratorSystem:update(dt)
	self.timer -= dt
	if self.timer < 0 and self.boxesGenerated < 100 then
		self.timer += 0.1

		-- Distribución circular aleatoria
		local angle = math.random() * 2 * math.pi
		local radius = math.sqrt(math.random()) * 100
		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius

		-- Velocidad aleatoria de magnitud 50
		local speedAngle = math.random() * 2 * math.pi
		local vx = math.cos(speedAngle) * 50
		local vy = math.sin(speedAngle) * 50
		self.eventBus:emit("CreateBox", x, y, 5, 5, vx, vy)
		self.boxesGenerated += 1
	end

end

return BoxGeneratorSystem
