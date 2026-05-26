local categorybar = require("./categorybar")
local px = require("../utils/px")
local searchbar = require("./searchbar")
local settings = require("../settings")
local slot = require("./slot")
local states = require("../states")
local useBackgroundTransparency = require("../hooks/useBackgroundTransparency")
local useInventoryItems = require("../hooks/useInventoryItems")
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
	local searchText = source("")

	local selectedIndex = derive(function()
		local selectedCategory = states.selectedCategory()
		local categories = states.categories()
		for i, category in categories do
			if category.category == selectedCategory then
				return i
			end
		end
		return 0
	end)

	local searchTokens = derive(function()
		local text = searchText():lower()
		local tokens = {}
		for token in text:gmatch("%S+") do
			table.insert(tokens, token)
		end
		return tokens
	end)

	return create("Frame")({
		Name = "Inventory",
		BackgroundColor3 = states.attributes.BackgroundColor3,
		BackgroundTransparency = useBackgroundTransparency(),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = function()
			return UDim2.fromOffset(states.width(), 0)
		end,

		create("UICorner")({
			CornerRadius = states.attributes.CornerRadius,
		}),

		create("UIListLayout")({}),

		show(function()
			return #states.categories() > 1
		end, categorybar),

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
					return show(function()
						local currentItem = item()
						if not currentItem then
							return false
						end

						local selectedIdx = selectedIndex()
						local selectedCategory = states.categories()[selectedIdx]
						if selectedCategory and not selectedCategory.predicate(currentItem) then
							return false
						end

						local tokens = searchTokens()
						if #tokens == 0 then
							return true
						end

						local name = currentItem.Name:lower()
						local tooltipText = ""
						if currentItem:IsA("Tool") then
							tooltipText = (currentItem :: Tool).ToolTip:lower()
						end

						for _, token in tokens do
							if name:find(token, 1, true) or tooltipText:find(token, 1, true) then
								return true
							end
						end

						return false
					end, function()
						return slot({
							item = item,
							order = order,
							unlocked = source(true),
						})
					end)
				end),
			}),
		}),
	})
end

return inventory
