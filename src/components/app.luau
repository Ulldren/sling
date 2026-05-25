local vide = require("../../vide")
local types = require("../types")
local backpack = require("./backpack")
local inventoryHint = require("./inventoryHint")

local create = vide.create
local source = vide.source
local show = vide.show

type Props = {
	opened: vide.Source<boolean>,
	slots: vide.Source<number>,
	rows: vide.Source<number>,
	items: vide.Source<{ types.InventoryItem }>,
	equippedItem: vide.Source<types.InventoryItem?>,
	keyboardHint: vide.Source<boolean>,
	gamepadHint: vide.Source<boolean>,
	categories: vide.Source<{ types.Category }>,
	selectedCategory: vide.Source<string>,
	attributes: types.Attributes,
}
local function app(props: Props)
	local width = source(0)

	return create("Frame")({
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = function()
			return UDim2.fromOffset(width(), 0)
		end,
		BackgroundTransparency = 1,

		create("UIListLayout")({
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		show(function()
			return props.gamepadHint() and props.opened()
		end, function()
			return create("Frame")({
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
					keyCode = Enum.KeyCode.ButtonX,
					text = "Remove from hotbar",
					attributes = props.attributes,
				}),
				inventoryHint({
					keyCode = Enum.KeyCode.ButtonA,
					text = "Select/Swap",
					attributes = props.attributes,
				}),
				inventoryHint({
					keyCode = Enum.KeyCode.ButtonB,
					text = "Close inventory",
					attributes = props.attributes,
				}),
			})
		end),
		backpack({
			opened = props.opened,
			slots = props.slots,
			rows = props.rows,
			items = props.items,
			equippedItem = props.equippedItem,
			widthChanged = width,
			keyboardHint = props.keyboardHint,
			categories = props.categories,
			selectedCategory = props.selectedCategory,
			attributes = props.attributes,
		}),
	})
end

return app
