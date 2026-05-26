const category = require("./category")
const px = require("../utils/px")
const states = require("../states")
const vide = require("../../vide")

const create = vide.create
const indexes = vide.indexes

const function categorybar()
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
