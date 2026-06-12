local categorybar = require("./categorybar")
local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local px = require("../../core/utils/px")
local searchbar = require("./searchbar")
local slot = require("./slot")
local states = require("../../core/states")
local theme = require("../theme")
local useInventory = require("../hooks/backpack/useInventory")
local usePreferredInput = require("../hooks/usePreferredInput")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local vide = require("../../../vide")

local derive = vide.derive
local create = vide.create
local indexes = vide.indexes
local show = vide.show

local INVENTORY_SLOT_PADDING = 5
local INVENTORY_SCROLLBAR_THICKNESS = 10

local function inventory(): Frame
	local height = derive(function()
		return states.rows() * (config.slotSize + INVENTORY_SLOT_PADDING)
	end)
	local inventory = useInventory()
	local preferredTransparency = usePreferredTransparency()
	local preferredInput = usePreferredInput()

	return create("Frame")({
		Name = "Inventory",
		Active = true,
		BackgroundColor3 = colorSpring(function()
			return theme.backgroundColor():Lerp(Color3.fromHex("#ffffff"), (1 - preferredTransparency()) * 0.15)
		end),
		BackgroundTransparency = function()
			return theme.backgroundTransparency() * preferredTransparency()
		end,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = function()
			return UDim2.fromOffset(states.width(), 0)
		end,
		Visible = states.opened,

		create("UICorner")({
			CornerRadius = theme.cornerRadius,
		}),

		create("UIListLayout")({}),

		show(cond.gt(cond.len(states.categories), 1), categorybar),

		create("Frame")({
			Name = "TopFrame",
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = px.udim2(1, 0, 0, INVENTORY_SLOT_PADDING),
			BackgroundTransparency = 1,
			LayoutOrder = 1,

			create("UIPadding")({
				PaddingBottom = px.udim(0, INVENTORY_SLOT_PADDING),
				PaddingLeft = px.udim(0, INVENTORY_SLOT_PADDING),
				PaddingRight = px.udim(0, INVENTORY_SLOT_PADDING),
				PaddingTop = px.udim(0, INVENTORY_SLOT_PADDING),
			}),

			show(cond.neq(preferredInput, Enum.PreferredInput.Gamepad), function()
				return searchbar({
					searchText = inventory.searchText,
				})
			end),
		}),

		create("ScrollingFrame")({
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
			ScrollBarThickness = px.scale(INVENTORY_SCROLLBAR_THICKNESS),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Selectable = false,
			Size = px.udim2(1, INVENTORY_SCROLLBAR_THICKNESS, 0, height),
			LayoutOrder = 2,

			create("UIPadding")({
				PaddingBottom = px.udim(0, INVENTORY_SLOT_PADDING),
				PaddingLeft = px.udim(0, INVENTORY_SLOT_PADDING),
				PaddingRight = px.udim(0, INVENTORY_SLOT_PADDING),
			}),

			create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = px.udim(0, INVENTORY_SLOT_PADDING),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Wraps = true,
			}),

			indexes(inventory.items, function(item, order)
				local visible = derive(function()
					return inventory.isVisible(item())
				end)
				return slot({
					item = item,
					order = order,
					visible = visible,
				})
			end),
		}),
	})
end

return inventory
