return {
	
	-- Engine
	
	FixedUPS = 24,				-- Actualizaciones por segundo fijas (update rate)
	MaxUPF = 5,	                -- Límite para evitar spiral of death
	MaxFPS = 240,				-- Máximo frames por segundo (render)
	ShowFPS = false,			-- Mostrar FPS por consola (true/false)
	
	-- Components
	
	ComponentsPath = game.ServerScriptService.ServerGame.Components,
	Components = {
		
	},
	
	-- Systems
	
	MainSystem = nil,
	
	-- Events
	
	Events = {
		CreateBall = "CreateBall"
	}
	
}