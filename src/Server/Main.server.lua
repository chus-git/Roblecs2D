local Config = require(game.ReplicatedStorage.Shared.Config.Game)
local game = require(game.ReplicatedStorage.Core.Game).new(
    require(Config.Server.MainSystem),
    Config
)
game:start()