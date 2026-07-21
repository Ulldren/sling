local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local px = require("../../core/utils/px")
local slot = require("./slot")
local states = require("../../core/states")
local vide = require("../../../vide")

local create = vide.create
local indexes = vide.indexes
local derive = vide.derive
local show = vide.show
local changed = vide.changed
local action = vide.action

local HOTBAR_PADDING = 5

local function hotbar(): Frame
	local items = derive(function()
		local slots = states.slots()
		local items = states.items()

		local newItems = table.create(slots) :: { { item: BackpackItem? } }
		for i = 1, slots do
			local item = items[i]
			newItems[i] = { item = item }
		end
		return newItems
	end)

	local slots = indexes<<number, { item: BackpackItem? }>>(items, function(entry, order)
		local item = derive(function()
			return entry().item
		end)
		return show(cond.any(states.opened, item), function()
			return slot {
				item = item,
				order = order,
				inHotbar = true,
			}
		end)
	end)

	return create "Frame" {
		Name = "Hotbar",
		Active = states.opened,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = px.offset(0, config.slotSize + HOTBAR_PADDING * 2),
		BackgroundTransparency = 1,
		LayoutOrder = 1,

		action(states.hotbarRef :: any),

		changed("AbsoluteSize", function(size: Vector2)
			states.width(size.X)
		end),

		create "UIListLayout" {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = px.udim(0, HOTBAR_PADDING),
		},

		create "UIPadding" {
			PaddingLeft = px.udim(0, HOTBAR_PADDING),
			PaddingRight = px.udim(0, HOTBAR_PADDING),
			PaddingTop = px.udim(0, HOTBAR_PADDING),
			PaddingBottom = px.udim(0, HOTBAR_PADDING),
		},

		slots
	}
end

return hotbar
