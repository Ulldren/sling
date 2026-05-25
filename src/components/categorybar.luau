local vide = require("../../vide")
local types = require("../types")
local category = require("./category")

local create = vide.create
local indexes = vide.indexes

type Props = {
	categories: vide.Source<{ types.Category }>,
	selectedCategory: vide.Source<string>,
	attributes: types.Attributes,
}

local function categorybar(props: Props)
	return create("Frame")({
		Name = "CategoryBar",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = props.attributes.BackgroundColor3,
		Size = UDim2.new(1, 0, 0, 35),

		create("UICorner")({
			CornerRadius = props.attributes.CornerRadius,
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = props.attributes.BackgroundColor3,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromScale(1, 0.5),
		}),

		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 0, 0, 1),
		}),

		create("Frame")({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),

			create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			indexes(props.categories, function(categorySrc)
				return category({
					categories = props.categories,
					category = categorySrc,
					selectedCategory = props.selectedCategory,
					attributes = props.attributes,
				})
			end),
		}),
	})
end

return categorybar
