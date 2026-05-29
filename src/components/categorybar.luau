local category = require("./category")
local px = require("../utils/px")
local states = require("../states")
local vide = require("../../vide")
local theme = require("../theme")
local colorSpring = require("../utils/colorSpring")

local create = vide.create
local indexes = vide.indexes
local spring = vide.spring
local derive = vide.derive

local function categorybar()
	local selectedCategoryIndex = derive(function()
		for index, category in states.categories() do
			if category.category == states.selectedCategory() then
				return index
			end
		end
		return 1
	end)

	return create("Frame")({
		Name = "CategoryBar",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = colorSpring(theme.theme.backgroundColor),
		Size = px.udim2(1, 0, 0, 35),

		create("UICorner")({
			CornerRadius = theme.theme.cornerRadius,
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = colorSpring(theme.theme.backgroundColor),
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(1, 0.5),
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = colorSpring(theme.theme.textColor),
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(0.5, 1),
			Size = px.udim2(1, 0, 0, 1),
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = colorSpring(theme.theme.textColor),
			Position = spring(function()
				return UDim2.fromScale((selectedCategoryIndex() - 1) / #states.categories(), 1)
			end, 0.2),
			Size = spring(function()
				return px.udim2(1 / #states.categories(), 0, 0, 4)()
			end, 0.2),
		}),

		create("Frame")({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),

			create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			indexes(states.categories, function(categorySrc)
				return category({
					category = categorySrc,
				})
			end),
		}),
	})
end

return categorybar
