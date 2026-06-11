--!nonstrict
local inventory = require("../components/inventory")
local states = require("../states")
local vide = require("../../vide")

local action = vide.action
local apply = vide.apply
local derive = vide.derive
local effect = vide.effect

local controls = {
	width = 655,
	rows = 4,
	items = 10,
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
			return tool
		end

		local items = derive(function()
			local itemsTbl = {}
			for _ = 1, (props.controls.items() + states.slots()) do
				table.insert(itemsTbl, createSword())
			end
			return itemsTbl
		end)

		effect(function()
			states.width(props.controls.width())
			states.rows(math.floor(props.controls.rows()))
			states.items(items())
		end)

		states.opened(true)

		return {
			action(states.appRef),

			apply(inventory())({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			}),
		}
	end,
}
