local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local CollisionSystem = Utils.extend(System)

local HALF_WIDTH = 100
local HALF_HEIGHT = 100

function CollisionSystem:load()
	self.boxes = {}
	self.gridSize = 10
	self.grid = {}
end

function CollisionSystem:afterLoad()
	self:on(Config.Events.BoxCreated, function(boxId)
		table.insert(self.boxes, boxId)
	end)
end

function CollisionSystem:update(dt)
	self.grid = {}
	local OFFSET = 1000

	for _, e in ipairs(self.boxes) do
		local pos = self:getComponent(e, Config.Components.Position)
		local cellX = math.floor((pos.x + OFFSET) / self.gridSize)
		local cellY = math.floor((pos.y + OFFSET) / self.gridSize)
		local key = cellX .. "," .. cellY
		self.grid[key] = self.grid[key] or {}
		table.insert(self.grid[key], e)
	end

	local function getNearbyBoxes(cellX, cellY)
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

	local checkedPairs = {}

	for _, e1 in ipairs(self.boxes) do
		local pos1 = self:getComponent(e1, Config.Components.Position)
		local vel1 = self:getComponent(e1, Config.Components.Velocity)
		local box1 = self:getComponent(e1, Config.Components.Box)

		local cellX = math.floor((pos1.x + OFFSET) / self.gridSize)
		local cellY = math.floor((pos1.y + OFFSET) / self.gridSize)
		local nearbyBoxes = getNearbyBoxes(cellX, cellY)

		for _, e2 in ipairs(nearbyBoxes) do
			if e1 ~= e2 then
				local pairKey = e1 < e2 and (e1 .. "_" .. e2) or (e2 .. "_" .. e1)
				if not checkedPairs[pairKey] then
					checkedPairs[pairKey] = true

					local pos2 = self:getComponent(e2, Config.Components.Position)
					local vel2 = self:getComponent(e2, Config.Components.Velocity)
					local box2 = self:getComponent(e2, Config.Components.Box)

					local left1 = pos1.x - box1.width / 2
					local right1 = pos1.x + box1.width / 2
					local top1 = pos1.y - box1.height / 2
					local bottom1 = pos1.y + box1.height / 2

					local left2 = pos2.x - box2.width / 2
					local right2 = pos2.x + box2.width / 2
					local top2 = pos2.y - box2.height / 2
					local bottom2 = pos2.y + box2.height / 2

					local overlapX = right1 > left2 and left1 < right2
					local overlapY = bottom1 > top2 and top1 < bottom2

					if overlapX and overlapY then
						local dx = pos1.x - pos2.x
						local dy = pos1.y - pos2.y

						local px = (box1.width + box2.width) / 2 - math.abs(dx)
						local py = (box1.height + box2.height) / 2 - math.abs(dy)

						if px < py then
							local shift = px / 2
							local sign = dx >= 0 and 1 or -1
							pos1.x += shift * sign
							pos2.x -= shift * sign

							local tmp = vel1.x
							vel1.x = vel2.x
							vel2.x = tmp
						else
							local shift = py / 2
							local sign = dy >= 0 and 1 or -1
							pos1.y += shift * sign
							pos2.y -= shift * sign

							local tmp = vel1.y
							vel1.y = vel2.y
							vel2.y = tmp
						end
					end

				end
			end
		end

		-- Colisión con paredes
		local left = pos1.x - box1.width / 2
		local right = pos1.x + box1.width / 2
		local top = pos1.y - box1.height / 2
		local bottom = pos1.y + box1.height / 2

		if left < -HALF_WIDTH then
			pos1.x = -HALF_WIDTH + box1.width / 2
			vel1.x = -vel1.x
		elseif right > HALF_WIDTH then
			pos1.x = HALF_WIDTH - box1.width / 2
			vel1.x = -vel1.x
		end

		if top < -HALF_HEIGHT then
			pos1.y = -HALF_HEIGHT + box1.height / 2
			vel1.y = -vel1.y
		elseif bottom > HALF_HEIGHT then
			pos1.y = HALF_HEIGHT - box1.height / 2
			vel1.y = -vel1.y
		end
	end
end

function CollisionSystem:unload()
	System.unload(self)
end

return CollisionSystem
