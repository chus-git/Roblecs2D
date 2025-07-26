local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local CollisionSystem = Utils.extend(System)

local REPULSION_STRENGTH = 200
local HALF_WIDTH = 300
local HALF_HEIGHT = 120

function CollisionSystem:load()
	self.balls = {}
	self.gridSize = 10  -- tamaño celda configurable, ajústalo
	self.grid = {}
end

function CollisionSystem:afterLoad()
	self:on(Config.Events.BallCreated, function(ballId)
		table.insert(self.balls, ballId)
	end)
end

function CollisionSystem:update(dt)
	self.grid = {}

	-- Offset para evitar celdas con claves negativas
	local OFFSET = 1000

	-- 1) Insertar bolas en el grid
	for _, e in ipairs(self.balls) do
		local p = self:getComponent(e, Config.Components.Position)
		local r = self:getComponent(e, Config.Components.Ball).radius
		local cellX = math.floor((p.x + OFFSET) / self.gridSize)
		local cellY = math.floor((p.y + OFFSET) / self.gridSize)
		local key = cellX .. "," .. cellY
		self.grid[key] = self.grid[key] or {}
		table.insert(self.grid[key], e)
	end

	local function getNearbyBalls(cellX, cellY)
		local nearby = {}
		for dx = -1, 1 do
			for dy = -1, 1 do
				local key = (cellX + dx) .. "," .. (cellY + dy)
				if self.grid[key] then
					for _, e in ipairs(self.grid[key]) do
						table.insert(nearby, e)
					end
				end
			end
		end
		return nearby
	end

	-- Para evitar doble checkeo, vamos a usar un conjunto para registrar pares ya comprobados
	local checkedPairs = {}

	for _, e1 in ipairs(self.balls) do
		local p1 = self:getComponent(e1, Config.Components.Position)
		local v1 = self:getComponent(e1, Config.Components.Velocity)
		local ball1 = self:getComponent(e1, Config.Components.Ball)
		local r1 = ball1.radius
		local mass1Comp = self:getComponent(e1, Config.Components.Mass)
		local mass1 = mass1Comp and mass1Comp.value or 1

		local cellX = math.floor((p1.x + OFFSET) / self.gridSize)
		local cellY = math.floor((p1.y + OFFSET) / self.gridSize)
		local nearbyBalls = getNearbyBalls(cellX, cellY)

		for _, e2 in ipairs(nearbyBalls) do
			if e1 ~= e2 then
				-- Crear clave ordenada para pares
				local pairKey = e1 < e2 and (e1 .. "_" .. e2) or (e2 .. "_" .. e1)
				if not checkedPairs[pairKey] then
					checkedPairs[pairKey] = true

					local p2 = self:getComponent(e2, Config.Components.Position)
					local v2 = self:getComponent(e2, Config.Components.Velocity)
					local ball2 = self:getComponent(e2, Config.Components.Ball)
					local r2 = ball2.radius
					local mass2Comp = self:getComponent(e2, Config.Components.Mass)
					local mass2 = mass2Comp and mass2Comp.value or 1

					local dx = p2.x - p1.x
					local dy = p2.y - p1.y
					local distSq = dx * dx + dy * dy
					local radiusSum = r1 + r2
					local radiusSumSq = radiusSum * radiusSum

					if distSq < radiusSumSq and distSq > 0 then
						local dist = math.sqrt(distSq)
						local penetration = radiusSum - dist

						local nx = dx / dist
						local ny = dy / dist

						if dist == 0 then
							nx, ny = 1, 0
						end

						local correction = penetration / 2
						p1.x = p1.x - nx * correction
						p1.y = p1.y - ny * correction
						p2.x = p2.x + nx * correction
						p2.y = p2.y + ny * correction

						local v1n = v1.x * nx + v1.y * ny
						local v2n = v2.x * nx + v2.y * ny

						if v1n > v2n then
							local restitution = 0.8
							local v1nAfter = (v1n * (mass1 - mass2) + 2 * mass2 * v2n) / (mass1 + mass2)
							local v2nAfter = (v2n * (mass2 - mass1) + 2 * mass1 * v1n) / (mass1 + mass2)

							v1nAfter = v1nAfter * restitution
							v2nAfter = v2nAfter * restitution

							local v1tX = v1.x - v1n * nx
							local v1tY = v1.y - v1n * ny
							local v2tX = v2.x - v2n * nx
							local v2tY = v2.y - v2n * ny

							v1.x = v1tX + v1nAfter * nx
							v1.y = v1tY + v1nAfter * ny
							v2.x = v2tX + v2nAfter * nx
							v2.y = v2tY + v2nAfter * ny
						end
					end
				end
			end
		end

		-- Colisión con paredes (rectángulo 500x300)
		if p1.x - r1 < -HALF_WIDTH then
			p1.x = -HALF_WIDTH + r1
			v1.x = -v1.x
		end
		if p1.x + r1 > HALF_WIDTH then
			p1.x = HALF_WIDTH - r1
			v1.x = -v1.x
		end
		if p1.y - r1 < -HALF_HEIGHT then
			p1.y = -HALF_HEIGHT + r1
			v1.y = -v1.y
		end
		if p1.y + r1 > HALF_HEIGHT then
			p1.y = HALF_HEIGHT - r1
			v1.y = -v1.y
		end
	end
end

function CollisionSystem:unload()
	System.unload(self)
end

return CollisionSystem