local CreateCellEvent = require(script.Parent.Parent.Events.CreateCellEvent)
local CellCreatedEvent = require(script.Parent.Parent.Events.CellCreatedEvent)
local ToggleCellEvent = require(script.Parent.Parent.Events.ToggleCellEvent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local State = require(script.Parent.Parent.Components.State)

local MapSystem = require(game.ReplicatedStorage.Source.System).extend()

local MAP_WIDTH = 51
local MAP_HEIGHT = 51

function MapSystem:init()

	self.map = {}

	self.updateTimer = 0
    self.updateInterval = 0.05

	self:on(CreateCellEvent, function(x, y, alive)
		self:createCell(x, y, alive)
	end)

	self:on(ToggleCellEvent, function()
		
		local alivePositions = {
			{0, 0},
			{1, 0},
			{2, 0},
			{0, -1},
			{1, -2}
		}

		--local alivePositions = {
		--	{1, 1},
		--	{0, 0},
		--	{-1, -1},
		--}

		for _, pos in ipairs(alivePositions) do
			local x, y = pos[1], pos[2]
			local state = self:getComponent(self.map[x][y], State)
			if state then
				state.current = true
			end
		end
	end)

end

function MapSystem:update(dt)

	self.updateTimer = self.updateTimer + dt

    if self.updateTimer < self.updateInterval then
        return -- todavía no toca actualizar
    end
	
	self.updateTimer = 0

	print("[MapSystem] Updating map")

	-- Fase 1: calcular `state.next` de cada celda
	for x, column in pairs(self.map) do
		for y, cellId in pairs(column) do
			local position = self:getComponent(cellId, PositionComponent)
			local state = self:getComponent(cellId, State)
			if position and state then
				self:applyRules(position, state)
			end
		end
	end

	-- Fase 2: aplicar `next` como nuevo `current`
	for x, column in pairs(self.map) do
		for y, cellId in pairs(column) do
			local state = self:getComponent(cellId, State)
			if state then
				state.current = state.next
			end
		end
	end
	
end

function MapSystem:load()
	local function centeredRange(size)
		local half = size / 2
		local start = -half + 0.5
		local result = {}

		for i = 0, size - 1 do
			table.insert(result, start + i)
		end

		return result
	end

	local xPositions = centeredRange(MAP_WIDTH)
	local yPositions = centeredRange(MAP_HEIGHT)

	for _, x in ipairs(xPositions) do
		for _, y in ipairs(yPositions) do
			self:emit(CreateCellEvent(x, y, alive))
		end
	end

end

function MapSystem:clearMap()
	for x, column in pairs(self.map) do
		for y, cellId in pairs(column) do
			self:destroyEntity(cellId)
		end
	end
	self.map = {}
end

function MapSystem:createCell(x, y, alive)

	local cellId = self:createEntity()
	local cellPosition = self:addComponent(cellId, PositionComponent(x, y))
	local cellState = self:addComponent(cellId, State(false, false))

	if not self.map[x] then
		self.map[x] = {}
	end
	self.map[x][y] = cellId

	self:emit(CellCreatedEvent(cellId))
	
end

function MapSystem:applyRules(position, state)
	local x, y = position.x, position.y
	local aliveNeighbors = 0

	-- Contar vecinos vivos
	for dx = -1, 1 do
		for dy = -1, 1 do
			if not (dx == 0 and dy == 0) then
				local nx, ny = x + dx, y + dy
				local column = self.map[nx]
				if column then
					local neighborId = column[ny]
					if neighborId then
						local neighborState = self:getComponent(neighborId, State)
						if neighborState and neighborState.current then
							aliveNeighbors += 1
						end
					end
				end
			end
		end
	end

	if state.current then
		-- Regla 1: Supervivencia si tiene 2 o 3 vecinos vivos
		if aliveNeighbors == 2 or aliveNeighbors == 3 then
			state.next = true  -- Sobrevive
		else
			-- Regla 2 y 3: Muere por soledad (<2) o sobrepoblación (>3)
			state.next = false
		end
	else
		-- Regla 4: Nace si tiene exactamente 3 vecinos vivos
		if aliveNeighbors == 3 then
			state.next = true
		else
			state.next = false
		end
	end
end

return MapSystem