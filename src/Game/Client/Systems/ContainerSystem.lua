local ContainerSystem = require(game.ReplicatedStorage.Source.System).extend()

local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Componentes
local ContainerTagComponent = require(game.ReplicatedStorage.Components.ContainerTagComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)

-- Eventos
local GenerateParticleEvent = require(game.ReplicatedStorage.Events.GenerateParticleEvent)

function ContainerSystem:init()
    -- 1. ECS Entity
    local container = self:createEntity()
    self:addComponent(container, ContainerTagComponent())
    self:addComponent(container, SizeComponent(15, 15))
    self:addComponent(container, PositionComponent(0, 0))

    -- 2. Parte Física (Actúa como el plano de click)
    local part = Instance.new("Part")
    part.Name = "ContainerPart"
    part.Anchored = true
    part.CanCollide = false -- Para que no estorbe físicamente
    part.CastShadow = false
    part.Transparency = 1 
    part.Size = Vector3.new(15, 15, 0.1)
    part.Position = Vector3.new(0, 0, 0)
    part.Parent = Workspace

    -- 3. Visualización (SurfaceGui)
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.AlwaysOnTop = true
    surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surfaceGui.PixelsPerStud = 50 
    surfaceGui.Parent = part

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(241, 241, 241)
    frame.BorderSizePixel = 0
    frame.Parent = surfaceGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0) 
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(0, 0, 0)
    uiStroke.Thickness = 10
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Parent = frame

    -- --- LÓGICA DE CLICK POR RAYCAST (Sin Offsets de UI) ---
    
    local camera = Workspace.CurrentCamera

    UserInputService.InputBegan:Connect(function(input, processed)
        -- Si el jugador clickea en el Panel de Control (UI), no generamos bola
        if processed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mouseRay = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
            
            -- Configuramos el Raycast para que SOLO detecte el ContainerPart
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Include
            params.FilterDescendantsInstances = {part}
            
            local raycastResult = Workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, params)
            
            if raycastResult and raycastResult.Instance == part then
                local hitPos = raycastResult.Position
                -- Convertimos la posición 3D de Roblox a tu espacio 2D de simulación
                -- Nota: Usamos hitPos.X y hitPos.Y directamente porque el plano está en Z=0
                self:emit(GenerateParticleEvent(-hitPos.X, hitPos.Y))
            end
        end
    end)
end

return ContainerSystem