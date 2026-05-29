local px = require("../utils/px")
local states = require("../states")
local types = require("../types")
local vide = require("../../vide")
local theme = require("../theme")
local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")

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

	return create("TextButton")({
		BackgroundTransparency = 1,
		FontFace = function()
			return Font.new(theme.theme.fontFace().Family, Enum.FontWeight.Bold)
		end,
		Size = spring(function()
			local sizeX = 1 / #states.categories()
			return UDim2.fromScale(sizeX, 1)
		end, 0.2),
		TextColor3 = colorSpring(theme.theme.textColor),
		TextSize = px.scale(theme.theme.textSize),
		Text = categoryName,
		TextTransparency = spring(cond.ifelse(isSelected, 0, 0.4), 0.2),
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,

		Activated = function()
			states.selectedCategory(categoryName())
		end,

		show(function()
			local categories = states.categories()
			return categories[#categories] ~= category()
		end, function()
			return create("Frame")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = colorSpring(theme.theme.textColor),
				BackgroundTransparency = 0.8,
				Position = UDim2.fromScale(1, 0.5),
				Size = px.udim2(0, 1, 1, -8),
			})
		end),
	})
end

return category
