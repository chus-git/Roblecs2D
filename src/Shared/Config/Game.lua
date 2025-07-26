return {

    FixedUPS = 24,				-- Actualizaciones por segundo fijas (update rate)
	MaxFPS = 240,				-- Máximo frames por segundo (render)
	ShowFPS = true,			-- Mostrar FPS por consola (true/false)

    -- Path to the shared components
    ComponentsPath = game.ReplicatedStorage.Shared.Components,

    -- Component names to register
    Components = {
        Ball = game.ReplicatedStorage.Shared.Components.Ball.Name,
        Mass = game.ReplicatedStorage.Shared.Components.Mass.Name,
        Position = game.ReplicatedStorage.Shared.Components.Position.Name,
        Velocity = game.ReplicatedStorage.Shared.Components.Velocity.Name,
        Interpolation = game.ReplicatedStorage.Shared.Components.Interpolation.Name,
        Box = game.ReplicatedStorage.Shared.Components.Box.Name,
    },

    Client = {
        MainSystem = game.StarterPlayer.StarterPlayerScripts.Client.Systems.MainSystem,
    },

    Server = {
        
    }

}