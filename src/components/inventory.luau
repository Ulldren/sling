const categorybar = require("./categorybar")
const px = require("../utils/px")
const searchbar = require("./searchbar")
const settings = require("../settings")
const slot = require("./slot")
const states = require("../states")
const useInventoryItems = require("../hooks/useInventoryItems")
const vide = require("../../vide")
const theme = require("../theme")
const usePreferredTransparency = require("../hooks/usePreferredTransparency")
const colorSpring = require("../utils/colorSpring")
const cond = require("../utils/cond")

const derive = vide.derive
const create = vide.create
const source = vide.source
const indexes = vide.indexes
const show = vide.show
const action = vide.action

const function inventory(): Frame
	const height = derive(function()
		return states.rows() * (settings.slotSize + 5) - 5
	end)
	const searchText = source("")

	const selectedIndex = derive(function()
		const selectedCategory = states.selectedCategory()
		const categories = states.categories()
		for i, category in categories do
			if category.category == selectedCategory then
				return i
			end
		end
		return 0
	end)

	const searchTokens = derive(function()
		const text = searchText():lower()
		const tokens = {}
		for token in text:gmatch("%S+") do
			table.insert(tokens, token)
		end
		return tokens
	end)

	const preferredTransparency = usePreferredTransparency()

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

				indexes(useInventoryItems(), function(entry, order)
					const visible = derive(function()
						const currentItem = entry().item
						if not currentItem then
							return false
						end

						const selectedIdx = selectedIndex()
						const selectedCategory = states.categories()[selectedIdx]
						if selectedCategory and not selectedCategory.predicate(currentItem) then
							return false
						end

						const tokens = searchTokens()
						if #tokens == 0 then
							return true
						end

						const name = currentItem.Name:lower()
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
					end)
					return slot({
						entry = entry,
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
