local wrapComponent = require(game.ReplicatedStorage.Core.Utils).wrapComponent

return wrapComponent(
	"Interpolation",
	function(x: number, y: number)
		return {
			previous = Vector2.new(x, y),
			next = Vector2.new(x, y),
			current = Vector2.new(x, y),
		}
	end
)