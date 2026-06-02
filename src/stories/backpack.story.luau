--!nonstrict
local backpack = require("../components/backpack")
local states = require("../states")
local vide = require("../../vide")

local effect = vide.effect

local controls = {
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
		local function createTool()
			local tool = Instance.new("Tool")
			return tool
		end

		effect(function()
			states.opened(props.controls.opened())
			states.slots(math.floor(props.controls.slots()))
			states.rows(math.floor(props.controls.rows()))
			states.keyboardHint(props.controls.keyboardHint())
			states.items({ createTool() })
		end)

		return vide.apply(backpack())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
