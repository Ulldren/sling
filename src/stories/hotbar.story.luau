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
		local function createSword()
			local tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			return tool
		end
		local function createTool()
			local tool = Instance.new("Tool")
			return tool
		end

		effect(function()
			states.opened(props.controls.opened())
			states.slots(math.floor(props.controls.slots()))
			states.keyboardHint(props.controls.keyboardHint())
		end)

		states.items({ createSword(), createTool() })
		states.equippedItem(nil)

		return vide.apply(hotbar())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
