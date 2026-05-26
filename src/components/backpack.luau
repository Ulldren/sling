const hotbar = require("./hotbar")
const inventory = require("./inventory")
const states = require("../states")
const vide = require("../../vide")

const create = vide.create
const effect = vide.effect
const show = vide.show

const function backpack()
	effect(function()
		const categories = states.categories()
		states.selectedCategory(if #categories > 0 then categories[1].category else "")
	end)

	return create("Frame")({
		Name = "Backpack",
		Active = true,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,

		create("UIListLayout")({
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),

		show(states.opened, inventory),
		hotbar(),
	})
end

return backpack
