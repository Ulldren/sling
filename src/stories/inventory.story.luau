--!nonstrict
local inventory = require("../components/inventory")
local states = require("../states")
local vide = require("../../vide")

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

		vide.effect(function()
			states.width(props.controls.width())
			states.rows(props.controls.rows())
		end)

		states.opened(true)
		states.items(itemsTbl)
		states.equippedItem(nil)
		states.categories({})
		states.selectedCategory("")

		return vide.apply(inventory())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
