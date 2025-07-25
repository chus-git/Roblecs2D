return {
	
	-- Engine
	
	FixedUPS = 60,				-- Actualizaciones por segundo fijas (update rate)
	MaxUPF = 5,	-- Límite para evitar spiral of death
	MaxFPS = 240,				-- Máximo frames por segundo (render)
	ShowFPS = true,			-- Mostrar FPS por consola (true/false)
	
	-- Components
	
	ComponentsPath = game.ReplicatedStorage.Shared.Components,
	Components = {
		
		-- Logic
		
		Ball = game.ReplicatedStorage.Shared.Components.Ball.Name,
		Mass = game.ReplicatedStorage.Shared.Components.Mass.Name,
		Position = game.ReplicatedStorage.Shared.Components.Position.Name,
		Velocity = game.ReplicatedStorage.Shared.Components.Velocity.Name,
		Interpolation = game.ReplicatedStorage.Shared.Components.Interpolation.Name,
		Box = game.ReplicatedStorage.Shared.Components.Box.Name,
		
	},
	
	-- Entry point of the engine.
	-- Handles core flow and system orchestration.
	-- Manages scene transitions and dynamic system loading.
	MainSystem = game.StarterPlayer.StarterPlayerScripts.Client.Systems.MainSystem,
	
	-- Events
	
	Events = {
		CreateBall = "CreateBall",
		BallCreated = "BallCreated",
		CreateBox = "CreateBox",
		BoxCreated = "BoxCreated",
	}
	
}
