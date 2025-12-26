local SimulationControlSystem = require(game.ReplicatedStorage.Source.System).extend()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ContainerTagComponent = require(game.ReplicatedStorage.Components.ContainerTagComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local ParticleTagComponent = require(game.ReplicatedStorage.Components.ParticleTagComponent)

local ChangeSimulationSpeedEvent = require(game.ReplicatedStorage.Events.ChangeSimulationSpeedEvent)
local ToggleCollisionsEvent = require(game.ReplicatedStorage.Events.ToggleCollisionsEvent)
local DestroyEntityEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.DestroyEntityEvent)
local ChangeGravityEvent = require(game.ReplicatedStorage.Events.ChangeGravityEvent)

function SimulationControlSystem:init()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimulationPanel"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 410) -- Altura reducida
    frame.Position = UDim2.new(0, 20, 0.5, -205)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15) -- Espaciado compacto
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.Name 
    layout.Parent = frame

    local title = Instance.new("TextLabel")
    title.Name = "00_Title"
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Text = "SIMULATOR PRO"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = frame

    -- --- GRUPO 1: TAMAÑO ---
    local sizeGroup = self:createControlGroup(frame, "01_SizeGroup")
    local sizeHeader = self:createLabel(sizeGroup, "CONTAINER SIZE", 12, Color3.fromRGB(150, 150, 150))
    local sizeEvent = self:createSlider(sizeGroup, 5, 15, 15)
    
    sizeEvent:Connect(function(value)
        sizeHeader.Text = "CONTAINER SIZE: " .. string.format("%.1f", value)
        self:updateContainerSize(value)
    end)

    -- --- GRUPO 2: VELOCIDAD ---
    local speedGroup = self:createControlGroup(frame, "02_SpeedGroup")
    local speedHeader = self:createLabel(speedGroup, "SIM speed: x1.0", 12, Color3.fromRGB(150, 150, 150))
    local speedEvent = self:createSlider(speedGroup, 0.1, 4, 1)
    
    speedEvent:Connect(function(value)
        speedHeader.Text = "SIM speed: x" .. string.format("%.1f", value)
        self:emit(ChangeSimulationSpeedEvent(value))
    end)

    -- --- GRUPO 3: GRAVEDAD ---
    local gravGroup = self:createControlGroup(frame, "03_GravityGroup")
    local gravHeader = self:createLabel(gravGroup, "GRAVITY: 10.0", 12, Color3.fromRGB(150, 150, 150))
    local gravEvent = self:createSlider(gravGroup, 0, 100, 10)
    
    gravEvent:Connect(function(value)
        gravHeader.Text = "GRAVITY: " .. string.format("%.1f", value)
        self:emit(ChangeGravityEvent(value))
    end)

    -- --- GRUPO 4: COLISIONES (Toggle compacto) ---
    local collisionGroup = self:createControlGroup(frame, "04_CollisionsGroup")
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(1, 0, 0, 30)
    checkbox.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    checkbox.Font = Enum.Font.GothamBold
    checkbox.TextSize = 14
    checkbox.TextColor3 = Color3.new(1, 1, 1)
    checkbox.Text = "COLLISIONS: ON"
    checkbox.Parent = collisionGroup
    Instance.new("UICorner", checkbox).CornerRadius = UDim.new(0, 4)

    local collisionsEnabled = true
    checkbox.MouseButton1Click:Connect(function()
        collisionsEnabled = not collisionsEnabled
        checkbox.Text = collisionsEnabled and "COLLISIONS: ON" or "COLLISIONS: OFF"
        checkbox.BackgroundColor3 = collisionsEnabled and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(180, 50, 50)
        self:emit(ToggleCollisionsEvent(collisionsEnabled))
    end)

    -- --- BOTÓN CLEAR ---
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "05_Clear"
    clearButton.Size = UDim2.new(1, 0, 0, 35)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    clearButton.TextColor3 = Color3.fromRGB(30, 30, 30)
    clearButton.Text = "CLEAR PARTICLES"
    clearButton.Font = Enum.Font.GothamBold
    clearButton.TextSize = 14
    clearButton.Parent = frame
    Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 4)

    clearButton.MouseButton1Click:Connect(function()
        self:clearAllParticles()
    end)
end

function SimulationControlSystem:createControlGroup(parent, name)
    local group = Instance.new("Frame")
    group.Name = name
    group.Size = UDim2.new(1, 0, 0, 45) -- Altura muy reducida
    group.BackgroundTransparency = 1
    group.Parent = parent
    local groupLayout = Instance.new("UIListLayout")
    groupLayout.Padding = UDim.new(0, 4)
    groupLayout.Parent = group
    return group
end

function SimulationControlSystem:createLabel(parent, text, size, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = size
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

function SimulationControlSystem:createSlider(parent, min, max, start)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(1, 0, 0, 20)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0.5, -2)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderContainer
    Instance.new("UICorner", sliderBg)
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
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
            local relPos = math.clamp((mousePos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(relPos, 0, 0.5, 0)
            changedEvent:Fire(min + (relPos * (max - min)))
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
            end
        end)
    end)
    return changedEvent.Event
end

function SimulationControlSystem:clearAllParticles()
    local particles = self:getEntitiesWithComponent(ParticleTagComponent)
    for entity, _ in pairs(particles) do
        self:destroyEntity(entity)
        self:fire(DestroyEntityEvent(entity))
    end
end

function SimulationControlSystem:updateContainerSize(newSize)
    local containerEntity = self:getEntityWithComponent(ContainerTagComponent)
    if containerEntity then
        local sizeComp = self:getComponent(containerEntity, SizeComponent)
        sizeComp.width, sizeComp.height = newSize, newSize
        local part = game.Workspace:FindFirstChild("ContainerPart")
        if part then part.Size = Vector3.new(newSize, newSize, 0.1) end
    end
end

return SimulationControlSystem