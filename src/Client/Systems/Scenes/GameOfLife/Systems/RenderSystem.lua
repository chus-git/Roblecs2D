local CellCreatedEvent = require(script.Parent.Parent.Events.CellCreatedEvent)
local Position = require(game.ReplicatedStorage.Shared.Components.Position)
local State = require(script.Parent.Parent.Components.State)

local RenderSystem = require(game.ReplicatedStorage.Core.System).extend()

local CELL_SIZE = 8
local GAP = 1

function RenderSystem:load()

	self.renderables = {}

	self:on(CellCreatedEvent, function(cellId)
		self:createRenderableCell(cellId)
	end)

end

function RenderSystem:render(dt, alpha)
    for cellId, part in pairs(self.renderables) do
        local state = self:getComponent(cellId, State)
        part.Color = state.current and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    end
end

function RenderSystem:createRenderableCell(cellId)
	local position = self:getComponent(cellId, Position)
	local state = self:getComponent(cellId, State)

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Block
	part.Size = Vector3.new(CELL_SIZE - GAP, CELL_SIZE - GAP, 1)
	part.Position = Vector3.new(position.x * CELL_SIZE, position.y * CELL_SIZE, 0)
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.SmoothPlastic
	part.Name = "Cell"
	part.Color = state.current and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)

	part.Parent = self.viewport
	self.renderables[cellId] = part
end

return RenderSystem