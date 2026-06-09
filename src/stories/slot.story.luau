--!nonstrict
local slot = require("../components/slot")
local states = require("../states")
local vide = require("../../vide")

local source = vide.source
local cleanup = vide.cleanup

local controls = {
	name = "Tool",
	textureId = "",
	tooltip = "",
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
		cleanup(item)

		vide.effect(function()
			item.Name = props.controls.name()
			item.TextureId = props.controls.textureId()
			item.ToolTip = props.controls.tooltip()
			states.keyboardHint(props.controls.keyboardHint())
		end)

		return vide.apply(slot({
			item = source(item),
			order = 1,
			inHotbar = true,
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
