local tooltip = require("../components/tooltip")
local vide = require("../../../vide")

local create = vide.create

return {
	vide = vide,
	story = function()
		return create("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),

			tooltip({
				text = function()
					return "Hello World"
				end,
			}),
		})
	end,
}
