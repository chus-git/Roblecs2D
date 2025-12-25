local Lighting = game:GetService("Lighting")
local BackgroundSystem = require(game.ReplicatedStorage.Source.System).extend()

function BackgroundSystem:init()
	-- 1. Limpiamos efectos de iluminación global que ensucian el blanco
	Lighting.Brightness = 0
	Lighting.GlobalShadows = false
	Lighting.ExposureCompensation = 1 -- Aumentamos la exposición para forzar el brillo
	
	-- 2. Añadimos un ColorCorrection para forzar el contraste y el brillo
	local colorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
	if not colorCorrection then
		colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Parent = Lighting
	end
	colorCorrection.Brightness = 0.1 -- Un ligero extra de brillo
	colorCorrection.Contrast = 0.2   -- Más contraste ayuda a separar el blanco del gris
	
	-- 3. Creamos el Part de fondo con el SurfaceGui (Blanco absoluto)
	local background = Instance.new("Part")
	background.Name = "GameBackground"
	background.Anchored = true
	background.CanCollide = false
	background.Transparency = 1
	background.Position = Vector3.new(0, 0, 3)
	background.Size = Vector3.new(5000, 5000, 1)
	
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.LightInfluence = 0
	surfaceGui.AlwaysOnTop = true -- Esto hace que el GUI ignore la neblina y la iluminación
	surfaceGui.Parent = background
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.BorderSizePixel = 0
	frame.Parent = surfaceGui
	
	background.Parent = game.Workspace
	self.backgroundPart = background
end

return BackgroundSystem