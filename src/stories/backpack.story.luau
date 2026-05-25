local vide = require("../../vide")
local backpack = require("../components/backpack")
local attributesController = require("../lib/attributesController")
local types = require("../types")

local source = vide.source

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

		return vide.apply(backpack({
			opened = props.controls.opened :: any,
			slots = props.controls.slots :: any,
			rows = props.controls.rows :: any,
			items = function()
				return { [(props.controls.toolSlot :: any)()] = tool }
			end,
			equippedItem = source(nil :: types.InventoryItem?),
			keyboardHint = props.controls.keyboardHint :: any,
			categories = source({}),
			selectedCategory = source(""),
			widthChanged = print,
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
