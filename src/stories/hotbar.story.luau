local vide = require("../../vide")
local hotbar = require("../components/hotbar")
local attributesController = require("../lib/attributesController")

local source = vide.source

local controls = {
	opened = true,
	slots = 10,
	keyboardHint = true,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		local item = Instance.new("Tool")
		item.Name = "Tool"
		item.ToolTip = "Tooltip"

		return vide.apply(hotbar({
			opened = props.controls.opened :: any,
			slots = props.controls.slots :: any,
			items = source({ item }),
			equippedItem = vide.source(nil),
			keyboardHint = props.controls.keyboardHint :: any,
			widthChanged = print,
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
