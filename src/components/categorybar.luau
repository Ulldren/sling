const category = require("./category")
const px = require("../utils/px")
const states = require("../states")
const vide = require("../../vide")

const create = vide.create
const indexes = vide.indexes
const spring = vide.spring
const derive = vide.derive

const function categorybar()
	const selectedCategoryIndex = derive(function()
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
		BackgroundColor3 = states.attributes.BackgroundColor3,
		Size = px.udim2(1, 0, 0, 35),

		create("UICorner")({
			CornerRadius = states.attributes.CornerRadius,
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = states.attributes.BackgroundColor3,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(1, 0.5),
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(0.5, 1),
			Size = px.udim2(1, 0, 0, 1),
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = states.attributes.SelectionColor3,
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
