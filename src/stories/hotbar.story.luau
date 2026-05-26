--!nonstrict
const hotbar = require("../components/hotbar")
const states = require("../states")
const vide = require("../../vide")

const effect = vide.effect

const controls = {
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
		const item = Instance.new("Tool")
		item.Name = "Tool"
		item.ToolTip = "Tooltip"

		effect(function()
			states.opened(props.controls.opened())
			states.slots(math.floor(props.controls.slots()))
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
