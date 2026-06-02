local hotbar = require("./hotbar")
local inventory = require("./inventory")
local vide = require("../../vide")

local create = vide.create

local function backpack()
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
