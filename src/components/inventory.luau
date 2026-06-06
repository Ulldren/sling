local categorybar = require("./categorybar")
local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local config = require("../constants/config")
local px = require("../utils/px")
local searchbar = require("./searchbar")
local slot = require("./slot")
local states = require("../states")
local theme = require("../theme")
local useInventory = require("../hooks/backpack/useInventory")
local usePreferredInput = require("../hooks/usePreferredInput")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local vide = require("../../vide")

local derive = vide.derive
local create = vide.create
local source = vide.source
local indexes = vide.indexes
local show = vide.show
local action = vide.action

local function inventory(): Frame
	local height = derive(function()
		return states.rows() * (config.slotSize + 5) - 5
	end)
	local inventory = useInventory()
	local preferredTransparency = usePreferredTransparency()
	local preferredInput = usePreferredInput()

	return create("Frame")({
		Name = "Inventory",
		Active = true,
		BackgroundColor3 = colorSpring(theme.theme.backgroundColor),
		BackgroundTransparency = function()
			return theme.theme.backgroundTransparency() * preferredTransparency()
		end,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = function()
			return UDim2.fromOffset(states.width(), 0)
		end,
		Visible = states.opened,

		create("UICorner")({
			CornerRadius = theme.theme.cornerRadius,
		}),

		create("UIListLayout")({}),

		show(cond.gt(cond.len(states.categories), 1), categorybar),

		create("Frame")({
			Name = "InventoryMainFrame",
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,

			create("UIPadding")({
				PaddingBottom = px.udim(0, 5),
				PaddingLeft = px.udim(0, 5),
				PaddingRight = px.udim(0, 5),
				PaddingTop = px.udim(0, 5),
			}),

			create("UIListLayout")({
				Padding = px.udim(0, 5),
			}),

			show(cond.neq(preferredInput, Enum.PreferredInput.Gamepad), function()
				return searchbar({
					searchText = inventory.searchText,
				})
			end),

			create("ScrollingFrame")({
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollBarImageColor3 = Color3.fromRGB(208, 216, 250),
				ScrollBarThickness = 8,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Selectable = false,
				Size = px.udim2(1, 18, 0, height),
				LayoutOrder = 1,

				action(states.inventoryGridRef) :: any,

				create("UIListLayout")({
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = px.udim(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Wraps = true,
				}),

				indexes(inventory.items, function(item, order)
					local visible = derive(function()
						return inventory.isVisible(item())
					end)
					return slot({
						item = item,
						visible = visible,
						order = order,
						unlocked = source(true),
					})
				end),
			}),
		}),
	})
end

return inventory
