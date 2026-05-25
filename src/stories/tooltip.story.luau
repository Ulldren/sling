local vide = require("../../vide")
local tooltip = require("../components/tooltip")
local attributesController = require("../lib/attributesController")

local create = vide.create

return {
	vide = vide,
	story = function()
		return create("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),

			tooltip({
				text = function()
					return "Hello World"
				end,
				attributes = attributesController.generateAttributes(),
			}),
		})
	end,
}
