local vide = require("../../vide")
local types = require("../types")
local slot = require("./slot")

local create = vide.create
local indexes = vide.indexes
local derive = vide.derive
local show = vide.show
local changed = vide.changed

type Props = {
	opened: vide.Source<boolean>,
	slots: vide.Source<number>,
	items: vide.Source<{ types.InventoryItem }>,
	equippedItem: vide.Source<types.InventoryItem?>,
	keyboardHint: vide.Source<boolean>,
	widthChanged: (number) -> (),
	attributes: types.Attributes,
}

local function hotbar(props: Props): Frame
	local slotData = derive(function()
		local slots = props.slots()
		local items = props.items()
		local data: { { item: types.InventoryItem? } } = table.create(slots)
		for i = 1, slots do
			data[i] = { item = items[i] }
		end
		return data
	end)

	local slotsFrames = indexes(slotData, function(entry, order)
		local item = derive(function()
			return entry().item
		end)
		return show(function()
			return props.opened() or item() ~= nil
		end, function()
			return slot({
				opened = props.opened,
				item = item,
				order = order,
				keyboardHint = props.keyboardHint,
				unlocked = function()
					return props.opened() and item() ~= nil
				end,
				equippedItem = props.equippedItem,
				attributes = props.attributes,
			})
		end)
	end)

	return create("Frame")({
		Name = "Hotbar",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = 1,

		changed("AbsoluteSize", function(size: Vector2)
			props.widthChanged(size.X)
		end) :: any,

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5),
		}),

		create("UIPadding")({
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
		}),

		slotsFrames,
	})
end

return hotbar
