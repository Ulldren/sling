local backpack = require("./backpack")
local inventoryHint = require("./inventoryHint")
local settings = require("../settings")
local states = require("../states")
local vide = require("../../vide")

local create = vide.create
local show = vide.show

local function app()
	return create("Frame")({
		Name = "App",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		vide.action(states.appRef) :: any,

		create("Frame")({
			Name = "Container",
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = function()
				return UDim2.fromOffset(states.width(), 0)
			end,
			BackgroundTransparency = 1,

			create("UIListLayout")({
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			show(function()
				return states.gamepadHint() and states.opened()
			end, function()
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

					inventoryHint({
						keyCode = settings.gamepadRemoveKey,
						text = "Remove from hotbar",
					}),
					inventoryHint({
						keyCode = settings.gamepadSwapKey,
						text = "Select/Swap",
					}),
					inventoryHint({
						keyCode = settings.gamepadCloseKey,
						text = "Close inventory",
					}),
				})
			end),
			backpack(),
		}),
	})
end

return app
