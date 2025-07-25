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
