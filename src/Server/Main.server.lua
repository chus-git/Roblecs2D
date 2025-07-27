local Config = require(game.ReplicatedStorage.Shared.Config)
local game = require(game.ReplicatedStorage.Core.Game).new(
    require(game.ServerScriptService.Server.Systems.MainSystem),
    Config
)
game:start()