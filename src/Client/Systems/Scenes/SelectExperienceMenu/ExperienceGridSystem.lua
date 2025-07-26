local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local ExperienceGridSystem = Utils.extend(System)

local MiniGames = {
	{Name = "Aventura", Image = "rbxassetid://12345678"},
	{Name = "Carreras", Image = "rbxassetid://87654321"},
	{Name = "Puzzle", Image = "rbxassetid://11223344"},
	-- más minijuegos...
}

-- Miniatura como imagen clicable
local function createMiniGameThumbnail(parent, miniGame)
	local button = Instance.new("ImageButton")
	button.Size = UDim2.new(0, 100, 0, 100)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.BorderSizePixel = 0
	button.Image = miniGame.Image
	button.ScaleType = Enum.ScaleType.Crop
	button.Parent = parent

	-- Evento de clic
	button.MouseButton1Click:Connect(function()
		print("Seleccionado:", miniGame.Name)
		-- Aquí podrías hacer: self:emit("MinigameSelected", miniGame)
	end)

	return button
end

function ExperienceGridSystem:load()
	if not self.viewport then return end

	self.scrollingFrame = Instance.new("ScrollingFrame")
	self.scrollingFrame.Name = "MiniGamesScroll"
	self.scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	self.scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	self.scrollingFrame.BackgroundTransparency = 1
	self.scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	self.scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	self.scrollingFrame.ScrollBarThickness = 8
	self.scrollingFrame.Parent = self.viewport

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 20)
	padding.Parent = self.scrollingFrame

	self.gridLayout = Instance.new("UIGridLayout")
	self.gridLayout.CellSize = UDim2.new(0, 100, 0, 100)
	self.gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	self.gridLayout.FillDirection = Enum.FillDirection.Horizontal
	self.gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	self.gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	self.gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	self.gridLayout.Parent = self.scrollingFrame

	for _, miniGame in ipairs(MiniGames) do
		createMiniGameThumbnail(self.scrollingFrame, miniGame)
	end

	local function updateLayout()
		local width = self.viewport.AbsoluteSize.X
		if width > 1000 then
			self.gridLayout.CellSize = UDim2.new(0, 150, 0, 150)
			self.gridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
		elseif width > 600 then
			self.gridLayout.CellSize = UDim2.new(0, 120, 0, 120)
			self.gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
		else
			self.gridLayout.CellSize = UDim2.new(0, 100, 0, 100)
			self.gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
		end
	end

	updateLayout()
	self.sizeChangedConn = self.viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
end

function ExperienceGridSystem:unload()
	if self.sizeChangedConn then
		self.sizeChangedConn:Disconnect()
		self.sizeChangedConn = nil
	end

	if self.scrollingFrame then
		self.scrollingFrame:Destroy()
		self.scrollingFrame = nil
	end

	self.gridLayout = nil
end

return ExperienceGridSystem
