--!nonstrict
local hotbar = require("../components/hotbar")
local states = require("../states")
local vide = require("../../vide")

local effect = vide.effect

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

		effect(function()
			states.opened(props.controls.opened())
			states.slots(props.controls.slots())
			states.keyboardHint(props.controls.keyboardHint())
		end)

		states.items({ item })
		states.equippedItem(nil)

		return vide.apply(hotbar())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
