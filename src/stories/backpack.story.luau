--!nonstrict
local backpack = require("../components/backpack")
local states = require("../states")
local vide = require("../../vide")

local effect = vide.effect

local controls = {
	toolSlot = 4,
	slots = 10,
	rows = 4,
	opened = true,
	keyboardHint = true,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		local tool = Instance.new("Tool")
		tool.Name = "Sword"
		tool.TextureId = "rbxasset://Textures/Sword128.png"
		tool.ToolTip = "A cool sword"

		vide.cleanup(tool)

		effect(function()
			states.opened(props.controls.opened())
			states.slots(props.controls.slots())
			states.rows(props.controls.rows())
			states.keyboardHint(props.controls.keyboardHint())
			states.items({ [props.controls.toolSlot()] = tool })
		end)

		return vide.apply(backpack())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
