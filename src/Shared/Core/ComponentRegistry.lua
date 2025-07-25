local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local ComponentRegistry = {}
ComponentRegistry.__index = ComponentRegistry

function ComponentRegistry.new(path)
	local self = setmetatable({}, ComponentRegistry)
	self.components = {}
	
	print("[ComponentRegistry] Loading components...")
	
	self:loadComponents(path)
	
	local componentsFolder = Config.ComponentsPath

	local count = 0
	for _ in pairs(self.components) do
		count = count + 1
	end

	print("[ComponentRegistry] Total components loaded: " .. count)
	
	return self
	
end

function ComponentRegistry:loadComponents(path)
	
	for _, child in ipairs(path:GetChildren()) do
		if child:IsA("ModuleScript") then
			local componentName = child.Name
			local constructor = require(child)
			assert(type(constructor) == "function", componentName .. " must export a function")
			self.components[componentName] = constructor
			print("[ComponentRegistry] Component loaded: " .. componentName)
		elseif child:IsA("Folder") then
			self:loadComponents(child)
		end
	end
end

return ComponentRegistry
