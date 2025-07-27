local Players = game:GetService("Players")
local PlayerConnectedEvent = require(game.ReplicatedStorage.Shared.Events.PlayerConnected)
local PlayerDisconnetedEvent = require(game.ReplicatedStorage.Shared.Events.PlayerDisconnected)

local PlayerSystem = require(game.ReplicatedStorage.Core.System).extend()

function PlayerSystem:load()

	self.players = {}

	self:on(PlayerConnectedEvent, function(playerId, playerName)
		self:addPlayer(playerId, playerName)
	end)

	self:on(PlayerDisconnetedEvent, function(playerId)
		self:removePlayer(playerId)
	end)
	
end

function PlayerSystem:afterLoad()

	Players.PlayerAdded:Connect(function(player)
		self:emit(PlayerConnectedEvent(player.UserId, player.Name))
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:emit(PlayerDisconnetedEvent(player.UserId))
	end)

end

function PlayerSystem:addPlayer(playerId: number, playerName: string)
	self.players[playerId] = {
		id = playerId,
		name = playerName
	}
end

function PlayerSystem:removePlayer(playerId)
	print("[PlayerSystem] Remove player:", playerId)
	self.players[playerId] = nil
end

return PlayerSystem