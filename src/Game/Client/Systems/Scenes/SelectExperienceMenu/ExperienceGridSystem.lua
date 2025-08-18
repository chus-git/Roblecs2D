local LoadSceneEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.LoadSceneEvent)

local ExperienceGridSystem = require(game.ReplicatedStorage.Source.System).extend()

local MiniGames = {
	{Name = "Demo", Systems = {
		script.Parent.Parent.Demo.MainSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.SpriteManagerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.InterpolationSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.RenderSystem,
	}},
	{Name = "Levels", Systems = {
		script.Parent.Parent.Levels.MainSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.SpriteManagerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.InterpolationSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.RenderSystem,
	}},
	{Name = "Love", Systems = {
		script.Parent.Parent.Love.MainSystem,
		game.ReplicatedStorage.Modules.Physics.Systems.CollisionSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.SpriteManagerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.InterpolationSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.RenderSystem,
	}},
}

local function createMiniGameButton(parent, miniGame, onSelect)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 100, 0, 100)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.BorderSizePixel = 0
	button.Text = miniGame.Name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.Font = Enum.Font.GothamSemibold
	button.Parent = parent

	button.MouseButton1Click:Connect(function()
		onSelect(miniGame)
	end)

	return button
end

function ExperienceGridSystem:load()

	self.scrollingFrame = Instance.new("ScrollingFrame")
	self.scrollingFrame.Name = "MiniGamesScroll"
	self.scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	self.scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	self.scrollingFrame.BackgroundTransparency = 1
	self.scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	self.scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	self.scrollingFrame.ScrollBarThickness = 8
	self.scrollingFrame.Parent = self.screenGui

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
		createMiniGameButton(self.scrollingFrame, miniGame, function(miniGame)
			local modulesList = miniGame.Systems
			self:emit(LoadSceneEvent(modulesList))
		end)
	end

	local function updateLayout()
		local width = self.screenGui.AbsoluteSize.X
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
	self.sizeChangedConn = self.screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
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