local categorybar = require("./categorybar")
local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local px = require("../utils/px")
local searchbar = require("./searchbar")
local settings = require("../settings")
local slot = require("./slot")
local states = require("../states")
local theme = require("../theme")
local useInventoryItems = require("../hooks/backpack/useInventoryItems")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local useSearch = require("../hooks/backpack/useSearch")
local vide = require("../../vide")

local derive = vide.derive
local create = vide.create
local source = vide.source
local indexes = vide.indexes
local show = vide.show
local action = vide.action

local function inventory(): Frame
	local height = derive(function()
		return states.rows() * (settings.slotSize + 5) - 5
	end)

	local selectedCategoryIndex = derive(function()
		local selectedCategory = states.selectedCategory()
		local categories = states.categories()
		for i, category in categories do
			if category.category == selectedCategory then
				return i
			end
		end
		return 0
	end)

	local search = useSearch()
	local searchText = search.searchText
	local searchMatches = search.searchMatches

	local preferredTransparency = usePreferredTransparency()

	return create("Frame")({
		Name = "Inventory",
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

			searchbar({
				searchText = searchText,
			}),

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

				indexes(useInventoryItems(), function(item, order)
					local visible = derive(function()
						local currentItem = item()
						if not currentItem then
							return false
						end

						local selectedIdx = selectedCategoryIndex()
						local selectedCategory = states.categories()[selectedIdx]
						if selectedCategory and not selectedCategory.predicate(currentItem) then
							return false
						end
						return searchMatches(currentItem)
					end)
					return slot({
						item = item,
						order = order,
						visible = visible,
						unlocked = source(true),
					})
				end),
			}),
		}),
	})
end

return inventory
