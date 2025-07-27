local wrapComponent = require(game.ReplicatedStorage.Core.Utils).wrapComponent

return wrapComponent(
	"Circle",
	function(radius: number, color: Color3, position: Vector2)
		return {
			radius = radius,
			color = color,
			position = position,
		}
	end
)