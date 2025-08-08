local UserInputService = game:GetService("UserInputService")
local ToggleCellEvent = require(script.Parent.Parent.Events.ToggleCellEvent)

local InputSystem = require(game.ReplicatedStorage.Source.System).extend()

function InputSystem:init()

	 UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Space then
            self:emit(ToggleCellEvent)
        end
    end)

end

return InputSystem