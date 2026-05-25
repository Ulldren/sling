local vide = require("../../vide")
local slot = require("../components/slot")
local attributesController = require("../lib/attributesController")

local source = vide.source
local cleanup = vide.cleanup

return {
	vide = vide,
	story = function()
		local item = Instance.new("Tool")
		item.Name = "Tool"
		item.ToolTip = "Tooltip"

		cleanup(item)

		return vide.apply(slot({
			opened = source(false),
			item = source(item),
			equippedItem = source(nil),
			order = 1,
			keyboardHint = source(true),
			unlocked = source(true),
			attributes = attributesController.generateAttributes(),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
