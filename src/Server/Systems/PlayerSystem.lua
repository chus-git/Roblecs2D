local Players = game:GetService("Players")

local System = require(game.ReplicatedStorage.Core.System)


local PlayerSystem = System.extend()

function PlayerSystem:load()

	self.players = {}

	for _, player in ipairs(Players:GetPlayers()) do
		self:addPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:emit("PlayerConnected", player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:emit("PlayerDisconnected", player)
	end)
	
end

function PlayerSystem:afterLoad()

	self:on("PlayerConnected", function(player)
		self:addPlayer(player)
	end)

	self:on("PlayerDisconnected", function(player)
		self:removePlayer(player)
	end)

end

function PlayerSystem:addPlayer(player)
	self.players[player] = {
		id = player.UserId,
		name = player.Name
	}
end

function PlayerSystem:removePlayer(player)
	self.players[player] = nil
end

return PlayerSystem