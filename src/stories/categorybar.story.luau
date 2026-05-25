local vide = require("../../vide")
local categorybar = require("../components/categorybar")
local attributesController = require("../lib/attributesController")
local types = require("../types")

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
		return apply(categorybar({
			categories = vide.source({ category("Tools"), category("Currency"), category("Consumable") }),
			selectedCategory = vide.source("Tools"),
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
