local hotbar = require("./hotbar")
local inventory = require("./inventory")
local states = require("../states")
local vide = require("../../vide")

local create = vide.create
local effect = vide.effect

local function backpack()
	effect(function()
		local categories = states.categories()
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

		inventory(),
		hotbar(),
	})
end

return backpack
