local Players = game:GetService("Players")
local PlayerConnectedEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.PlayerConnectedEvent)
local PlayerDisconnetedEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.PlayerDisconnectedEvent)
local PlayerComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PlayerComponent)

local PlayerSystem = require(game.ReplicatedStorage.Source.System).extend()

function PlayerSystem:init()

	self.players = {}

	self:on(PlayerConnectedEvent, function(playerId, playerName)
		self:addPlayer(playerId, playerName)
	end)

	self:on(PlayerDisconnetedEvent, function(playerId)
		self:removePlayer(playerId)
	end)
	
end

function PlayerSystem:load()

	Players.PlayerAdded:Connect(function(player)
		self:emit(PlayerConnectedEvent(player.UserId, player.Name))
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:emit(PlayerDisconnetedEvent(player.UserId))
	end)

end

function PlayerSystem:addPlayer(playerUserId: number, playerName: string)
	local playerId = self:createEntity()
	local playerComponent = self:addComponent(PlayerComponent(playerUserId, playerName))
	self.players[playerId] = playerId
end

function PlayerSystem:removePlayer(playerId)
	self:destroyEntity(playerId)
	self.players[playerId] = nil
end

return PlayerSystem