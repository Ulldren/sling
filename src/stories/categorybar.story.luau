local categorybar = require("../components/categorybar")
local states = require("../states")
local types = require("../types")
local vide = require("../../vide")

local apply = vide.apply

return {
	vide = vide,
	story = function()
		local function category(name: string): types.Category
			return {
				category = name,
				icon = "rbxasset://textures/ui/TopBar/inventoryOn.png",
				predicate = function(item)
					return true
				end,
			}
		end
		states.categories({ category("Tools"), category("Currency"), category("Consumable") })
		states.selectedCategory("Tools")

		return apply(categorybar())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
