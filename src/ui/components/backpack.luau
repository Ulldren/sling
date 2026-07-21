local cond = require("../../core/utils/cond")
local gamepadHints = require("./gamepadHints")
local hotbar = require("./hotbar")
local inventory = require("./inventory")
local states = require("../../core/states")
local vide = require("../../../vide")

local create = vide.create
local show = vide.show

local function backpack()
	return create "Frame" {
		Name = "Backpack",
		Active = true,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = function()
			return UDim2.fromOffset(states.width(), 0)
		end,
		BackgroundTransparency = 1,

		create "UIListLayout" {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		},

		show(cond.all(states.gamepadHint, states.opened), gamepadHints),
		inventory(),
		hotbar(),
	}
end

return backpack
