local Players = game:GetService("Players")

local Config = require(game.ServerScriptService.ServerGame.ServerConfig)
local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local PlayerSystem = Utils.extend(System)

function PlayerSystem:load()
	
	self.players = {}

	for _, player in ipairs(Players:GetPlayers()) do
		self:addPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:addPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:removePlayer(player)
	end)
	
end

function PlayerSystem:addPlayer(player)
	
	self.players[player] = {
		id = player.UserId,
		name = player.Name
	}
	print("[PlayerSystem] Jugador conectado:", player.Name)
	
end

function PlayerSystem:removePlayer(player)
	
	self.players[player] = nil
	print("[PlayerSystem] Jugador desconectado:", player.Name)
	
end

return PlayerSystem