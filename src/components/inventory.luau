local vide = require("../../vide")
local types = require("../types")
local categorybar = require("./categorybar")
local searchbar = require("./searchbar")
local slot = require("./slot")

local derive = vide.derive
local create = vide.create
local source = vide.source
local indexes = vide.indexes
local show = vide.show

type Props = {
	opened: vide.Source<boolean>,
	rows: vide.Source<number>,
	items: vide.Source<{ types.InventoryItem }>,
	equippedItem: vide.Source<types.InventoryItem?>,
	categories: vide.Source<{ types.Category }>,
	selectedCategory: vide.Source<string>,
	attributes: types.Attributes,
}

local function inventory(props: Props): Frame
	local height = derive(function()
		return props.rows() * 65 - 5
	end)
	local searchText = source("")

	local selectedIndex = derive(function()
		local selectedCategory = props.selectedCategory()
		local categories = props.categories()
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
		BackgroundColor3 = props.attributes.BackgroundColor3,
		BackgroundTransparency = props.attributes.BackgroundTransparency,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),

		create("UICorner")({
			CornerRadius = props.attributes.CornerRadius,
		}),

		create("UIListLayout")({}),

		show(function()
			return #props.categories() > 1
		end, function()
			return categorybar({
				categories = props.categories,
				selectedCategory = props.selectedCategory,
				attributes = props.attributes,
			})
		end),

		create("Frame")({
			Name = "InventoryMainFrame",
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,

			create("UIPadding")({
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			}),

			create("UIListLayout")({
				Padding = UDim.new(0, 5),
			}),

			searchbar({
				searchText = searchText,
				attributes = props.attributes,
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
				Size = function()
					return UDim2.new(1, 18, 0, height())
				end,

				create("UIListLayout")({
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Wraps = true,
				}),

				indexes(props.items, function(item, order)
					return show(function()
						local currentItem = item()
						if not currentItem then
							return false
						end

						local selectedIdx = selectedIndex()
						local selectedCategory = props.categories()[selectedIdx]
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
							opened = props.opened,
							item = item,
							order = order,
							unlocked = source(true),
							equippedItem = props.equippedItem,
							attributes = props.attributes,
						})
					end)
				end),
			}),
		}),
	})
end

return inventory
