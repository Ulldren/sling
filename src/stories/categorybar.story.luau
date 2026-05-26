const categorybar = require("../components/categorybar")
const states = require("../states")
const types = require("../types")
const vide = require("../../vide")

const apply = vide.apply

return {
	vide = vide,
	story = function()
		const function category(name: string): types.Category
			return {
				category = name,
				icon = "rbxasset://textures/ui/TopBar/inventoryOn.png",
				predicate = function()
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
