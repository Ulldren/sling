const px = require("../utils/px")
const settings = require("../settings")
const slot = require("./slot")
const states = require("../states")
const useHotbarItems = require("../hooks/useHotbarItems")
const vide = require("../../vide")

const create = vide.create
const indexes = vide.indexes
const derive = vide.derive
const show = vide.show
const changed = vide.changed
const action = vide.action

const HOTBAR_PADDING = 5

const function hotbar(): Frame
	return create("Frame")({
		Name = "Hotbar",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = px.offset(0, settings.slotSize + HOTBAR_PADDING * 2),
		BackgroundTransparency = 1,
		LayoutOrder = 1,

		action(states.hotbarRef) :: any,

		changed("AbsoluteSize", function(size: Vector2)
			states.width(size.X)
		end) :: any,

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = px.udim(0, HOTBAR_PADDING),
		}),

		create("UIPadding")({
			PaddingLeft = px.udim(0, HOTBAR_PADDING),
			PaddingRight = px.udim(0, HOTBAR_PADDING),
			PaddingTop = px.udim(0, HOTBAR_PADDING),
			PaddingBottom = px.udim(0, HOTBAR_PADDING),
		}),

		indexes(useHotbarItems(), function(entry, order)
			const item = derive(function()
				return entry().item
			end)
			return show(function()
				return states.opened() or item() ~= nil
			end, function()
				return slot({
					item = item,
					order = order,
					unlocked = function()
						return states.opened() and item() ~= nil
					end,
					inHotbar = true,
				})
			end)
		end),
	})
end

return hotbar
