local vide = require("../../vide")
local types = require("../types")

local create = vide.create
local derive = vide.derive
local show = vide.show
local spring = vide.spring

type Props = {
	category: () -> types.Category,
	categories: () -> { types.Category },
	selectedCategory: vide.Source<string>,
	attributes: types.Attributes,
}

local function category(props: Props)
	local category = props.category

	local categoryName = derive(function()
		return category().category
	end)
	local isSelected = derive(function()
		return categoryName() == props.selectedCategory()
	end)
	local showSeparateLine = derive(function()
		local categories = props.categories()
		return categories[#categories] ~= category()
	end)

	return create("TextButton")({
		BackgroundTransparency = 1,
		FontFace = function()
			return Font.new(props.attributes.FontFace().Family, Enum.FontWeight.Bold)
		end,
		Size = spring(function()
			local sizeX = 1 / #props.categories()
			return UDim2.fromScale(sizeX, 1)
		end, 0.2),
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = props.attributes.TextSize,
		Text = categoryName,
		TextTransparency = function()
			return if isSelected() then 0 else 0.4
		end,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,

		Activated = function()
			props.selectedCategory(categoryName())
		end,

		show(isSelected, function()
			return create("Frame")({
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = props.attributes.SelectionColor3,
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.new(1, 0, 0, 4),
			})
		end),

		show(showSeparateLine, function()
			return create("Frame")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.8,
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.new(0, 1, 1, -8),
			})
		end),
	})
end

return category
