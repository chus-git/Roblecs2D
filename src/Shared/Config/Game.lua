return {

    FixedUPS = 24,				-- Actualizaciones por segundo fijas (update rate)
	MaxFPS = 240,				-- Máximo frames por segundo (render)
	ShowFPS = true,			-- Mostrar FPS por consola (true/false),
    MaxUPF = 10,				-- Máximo actualizaciones por frame (para evitar sobrecarga en servidor)

    -- Path to the shared components
    ComponentsPath = game.ReplicatedStorage.Shared.Components,

    Client = {
        MainSystem = game.StarterPlayer.StarterPlayerScripts.Client.Systems.MainSystem,
    },

    Server = {
        MainSystem = game.ServerScriptService.Server.Systems.PlayerSystem,
    }

}