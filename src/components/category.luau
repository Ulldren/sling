local px = require("../utils/px")
local states = require("../states")
local types = require("../types")
local vide = require("../../vide")

local create = vide.create
local derive = vide.derive
local show = vide.show
local spring = vide.spring

type Props = {
	category: () -> types.Category,
}

local function category(props: Props)
	local category = props.category

	local categoryName = derive(function()
		return category().category
	end)
	local isSelected = derive(function()
		return categoryName() == states.selectedCategory()
	end)
	local showSeparateLine = derive(function()
		local categories = states.categories()
		return categories[#categories] ~= category()
	end)

	return create("TextButton")({
		BackgroundTransparency = 1,
		FontFace = function()
			return Font.new(states.attributes.FontFace().Family, Enum.FontWeight.Bold)
		end,
		Size = spring(function()
			local sizeX = 1 / #states.categories()
			return UDim2.fromScale(sizeX, 1)
		end, 0.2),
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = px.scale(states.attributes.TextSize),
		Text = categoryName,
		TextTransparency = function()
			return if isSelected() then 0 else 0.4
		end,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,

		Activated = function()
			states.selectedCategory(categoryName())
		end,

		show(isSelected, function()
			return create("Frame")({
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = states.attributes.SelectionColor3,
				Position = UDim2.fromScale(0.5, 1),
				Size = px.udim2(1, 0, 0, 4),
			})
		end),

		show(showSeparateLine, function()
			return create("Frame")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.8,
				Position = UDim2.fromScale(1, 0.5),
				Size = px.udim2(0, 1, 1, -8),
			})
		end),
	})
end

return category
