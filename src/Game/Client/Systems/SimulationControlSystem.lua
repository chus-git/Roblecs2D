local SimulationControlSystem = require(game.ReplicatedStorage.Source.System).extend()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ContainerTagComponent = require(game.ReplicatedStorage.Components.ContainerTagComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)

local ChangeSimulationSpeedEvent = require(game.ReplicatedStorage.Events.ChangeSimulationSpeedEvent)
local ToggleCollisionsEvent = require(game.ReplicatedStorage.Events.ToggleCollisionsEvent)
local DestroyEntityEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.DestroyEntityEvent)

function SimulationControlSystem:init()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SimulationPanel"
	screenGui.Parent = playerGui
	
	-- Panel Principal
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 260, 0, 480) 
	frame.Position = UDim2.new(0, 30, 0.5, -240)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 20)
	padding.PaddingBottom = UDim.new(0, 20)
	padding.PaddingLeft = UDim.new(0, 20)
	padding.PaddingRight = UDim.new(0, 20)
	padding.Parent = frame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 30) -- Más espacio entre secciones
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.Name 
	layout.Parent = frame

	-- 1. Título del Panel
	local title = Instance.new("TextLabel")
	title.Name = "00_Title"
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = "CONTROL PANEL"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Parent = frame

	-- --- GRUPO 1: TAMAÑO ---
	local sizeGroup = self:createControlGroup(frame, "01_SizeGroup")
	self:createLabel(sizeGroup, "CONTAINER SIZE", 14, Color3.fromRGB(150, 150, 150), "01_Header")
	local sizeEvent = self:createSlider(sizeGroup, 5, 15, 15, "02_Slider")
	local sizeValueLabel = self:createLabel(sizeGroup, "Value: 15.0", 14, Color3.fromRGB(200, 200, 200), "03_Value")
	
	sizeEvent:Connect(function(value)
		sizeValueLabel.Text = "Value: " .. string.format("%.1f", value)
		self:updateContainerSize(value)
	end)

	-- --- GRUPO 2: COLISIONES ---
	local collisionGroup = self:createControlGroup(frame, "02_CollisionsGroup")
	self:createLabel(collisionGroup, "BALL COLLISIONS", 14, Color3.fromRGB(150, 150, 150), "01_Header")
	local checkbox = Instance.new("TextButton")
	checkbox.Name = "02_Checkbox"
	checkbox.Size = UDim2.new(1, 0, 0, 35)
	checkbox.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
	checkbox.Font = Enum.Font.GothamBold
	checkbox.TextSize = 16
	checkbox.TextColor3 = Color3.new(1, 1, 1)
	checkbox.Text = "ENABLED"
	checkbox.Parent = collisionGroup
	Instance.new("UICorner", checkbox).CornerRadius = UDim.new(0, 6)

	local collisionsEnabled = true
	checkbox.MouseButton1Click:Connect(function()
		collisionsEnabled = not collisionsEnabled
		checkbox.Text = collisionsEnabled and "ENABLED" or "DISABLED"
		checkbox.BackgroundColor3 = collisionsEnabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(200, 60, 60)
		self:emit(ToggleCollisionsEvent(collisionsEnabled))
	end)

	-- --- GRUPO 3: VELOCIDAD ---
	local speedGroup = self:createControlGroup(frame, "03_SpeedGroup")
	self:createLabel(speedGroup, "SIMULATION SPEED", 14, Color3.fromRGB(150, 150, 150), "01_Header")
	local speedEvent = self:createSlider(speedGroup, 0.1, 4, 1, "02_Slider")
	local speedValueLabel = self:createLabel(speedGroup, "Speed: x1.00", 14, Color3.fromRGB(200, 200, 200), "03_Value")
	
	speedEvent:Connect(function(value)
		speedValueLabel.Text = "Speed: x" .. string.format("%.2f", value)
		self:emit(ChangeSimulationSpeedEvent(value))
	end)

	-- --- BOTÓN CLEAR ---
	local clearButton = Instance.new("TextButton")
	clearButton.Name = "04_ClearButton"
	clearButton.Size = UDim2.new(1, 0, 0, 45)
	clearButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	clearButton.TextColor3 = Color3.fromRGB(30, 30, 30)
	clearButton.Text = "CLEAR ALL BALLS"
	clearButton.Font = Enum.Font.GothamBold
	clearButton.TextSize = 16
	clearButton.Parent = frame
	Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 6)

	clearButton.MouseButton1Click:Connect(function()
		self:clearAllBalls()
	end)
end

function SimulationControlSystem:createControlGroup(parent, name)
	local group = Instance.new("Frame")
	group.Name = name
	group.Size = UDim2.new(1, 0, 0, 85) -- Más alto para acomodar el valor abajo
	group.BackgroundTransparency = 1
	group.Parent = parent
	
	local groupLayout = Instance.new("UIListLayout")
	groupLayout.Padding = UDim.new(0, 6)
	groupLayout.SortOrder = Enum.SortOrder.Name 
	groupLayout.Parent = group
	
	return group
end

function SimulationControlSystem:createLabel(parent, text, size, color, name)
	local label = Instance.new("TextLabel")
	label.Name = name or "Label"
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = size or 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

function SimulationControlSystem:createSlider(parent, min, max, start, name)
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Name = name or "Slider"
	sliderContainer.Size = UDim2.new(1, 0, 0, 25) -- Contenedor un poco más amplio
	sliderContainer.BackgroundTransparency = 1
	sliderContainer.Parent = parent

	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, 0, 0, 6)
	sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
	sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = sliderContainer
	Instance.new("UICorner", sliderBg)
	
	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new((start - min) / (max - min), 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Text = ""
	knob.Parent = sliderBg
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	
	local changedEvent = Instance.new("BindableEvent")
	
	knob.MouseButton1Down:Connect(function()
		local connection
		connection = RunService.RenderStepped:Connect(function()
			local mousePos = UserInputService:GetMouseLocation().X
			local relPos = (mousePos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
			relPos = math.clamp(relPos, 0, 1)
			knob.Position = UDim2.new(relPos, 0, 0.5, 0)
			
			local value = min + (relPos * (max - min))
			changedEvent:Fire(value)
			
			if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				connection:Disconnect()
			end
		end)
	end)
	
	return changedEvent.Event
end

function SimulationControlSystem:clearAllBalls()
	local balls = self:getEntitiesWithComponent(BallTagComponent)
	for entity, _ in pairs(balls) do
		self:destroyEntity(entity)
		self:fire(DestroyEntityEvent(entity))
	end
end

function SimulationControlSystem:updateContainerSize(newSize)
	local containerEntity = self:getEntityWithComponent(ContainerTagComponent)
	if containerEntity then
		local sizeComp = self:getComponent(containerEntity, SizeComponent)
		sizeComp.width = newSize
		sizeComp.height = newSize
		
		local part = game.Workspace:FindFirstChild("ContainerPart")
		if part then
			part.Size = Vector3.new(newSize, newSize, 0.1)
		end
	end
end

return SimulationControlSystem