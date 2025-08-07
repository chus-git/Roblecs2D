local EngineFactory = require(script.Parent.EngineFactory)

local Game = {}
Game.__index = Game

function Game.new()
	local self = setmetatable({}, Game)
	print("[Game] Initializing game...")
	self.engine = EngineFactory.create()
	print("[Game] Game initialized.")
	return self
end

return Game
