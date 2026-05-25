local vide = require("../../vide")
local searchbar = require("../components/searchbar")
local attributesController = require("../lib/attributesController")

local controls = {
	width = 655,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		return vide.apply(searchbar({
			searchText = vide.source(""),
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = function()
				return UDim2.new(0, (props.controls.width :: any)(), 0, 30)
			end,
		})
	end,
}
