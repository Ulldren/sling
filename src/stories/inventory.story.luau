local vide = require("../../vide")
local inventory = require("../components/inventory")
local attributesController = require("../lib/attributesController")

local controls = {
	width = 655,
	rows = 4,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		local itemsTbl = {}
		for _ = 1, 15 do
			local tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			table.insert(itemsTbl, tool)
		end

		return vide.apply(inventory({
			opened = vide.source(true),
			rows = props.controls.rows :: any,
			items = vide.source(itemsTbl),
			equippedItem = vide.source(nil),
			categories = vide.source({}),
			selectedCategory = vide.source(""),
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = function()
				return UDim2.new(0, (props.controls.width :: any)(), 0, 0)
			end,
		})
	end,
}
