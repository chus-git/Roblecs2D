local Config = require(game.ReplicatedStorage.Shared.Config)
local game = require(game.ReplicatedStorage.Core.Game).new(
    require(game.StarterPlayer.StarterPlayerScripts.Client.Systems.MainSystem),
    Config
)
game:start()