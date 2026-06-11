local config = require("../../core/config")
local gamepadHint = require("./gamepadHint")
local vide = require("../../../vide")

local create = vide.create

return function()
	return create("Frame")({
		Name = "GamepadHints",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = -1,

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
			Padding = UDim.new(0, 5),
			Wraps = true,
		}),

		gamepadHint({
			keyCode = config.gamepadRemoveKey,
			text = "Remove from hotbar",
		}),
		gamepadHint({
			keyCode = config.gamepadSwapKey,
			text = "Select/Swap",
		}),
		gamepadHint({
			keyCode = config.gamepadCloseKey,
			text = "Close inventory",
		}),
	})
end
