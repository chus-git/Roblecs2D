local Players               = game:GetService("Players")
local ContextActionService  = game:GetService("ContextActionService")
local StarterGui            = game:GetService("StarterGui")

local player = Players.LocalPlayer

for _, action in ipairs({
	"jumpAction", "toggleDevConsole", "toggleMenu",
	"mouseLock", "mouseLockSwitch", "shiftLockSwitch"
	}) do
	ContextActionService:UnbindAction(action)
end

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

local function freezeCharacter(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		elseif part:IsA("Decal") then
			part.Transparency = 1
		end
	end

	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.AutoRotate = false
	end

	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.Anchored = true
	end
end

if player.Character then
	freezeCharacter(player.Character)
end

player.CharacterAdded:Connect(freezeCharacter)

local Lighting = game:GetService("Lighting")

Lighting.Ambient = Color3.new(0, 0, 0)           -- Sin luz ambiental para negros puros
Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
Lighting.Brightness = 1
Lighting.ExposureCompensation = 0
Lighting.ColorShift_Top = Color3.new(1, 1, 1)
Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.GlobalShadows = false

Lighting.FogStart = 1e10
Lighting.FogEnd = 1e10
Lighting.FogColor = Color3.new(1, 1, 1)

for _, child in ipairs(Lighting:GetChildren()) do
	if child:IsA("Light") then
		child.Enabled = false
	end
	if child:IsA("PostEffect") then
		child.Enabled = false
	end
end

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if atmosphere then
	atmosphere.Density = 0
	atmosphere.Haze = 0
	atmosphere.Glare = 0
	atmosphere.Offset = 0
	atmosphere.Color = Color3.new(1, 1, 1)
end