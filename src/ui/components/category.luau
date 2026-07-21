local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local theme = require("../theme")
local types = require("../../core/types")
local vide = require("../../../vide")

local create = vide.create
local derive = vide.derive
local show = vide.show

type Props = {
	category: vide.Source<types.Category>,
	size: vide.SourceRaw<UDim2>,
	inBar: boolean?,
}

local function category(props: Props)
	local category = props.category
	local categoryName = derive(function()
		return category().category
	end)
	local isSelected = cond.eq(states.selectedCategory, categoryName)
	local zIndex = cond.ifelse(props.inBar, 1, 2)

	return create("TextButton") ({
		BackgroundTransparency = 1,
		FontFace = theme.categoryTabsFontFace,
		Size = props.size,
		TextColor3 = colorSpring(theme.categoryTabsTextColor),
		TextSize = px.scale(theme.categoryTabsTextSize),
		Text = categoryName,
		TextTransparency = cond.ifelse(isSelected, 0, 0.4),
		TextStrokeColor3 = colorSpring(theme.textStrokeColor),
		TextStrokeTransparency = theme.textStrokeTransparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = true,
		ZIndex = zIndex,

		Activated = function()
			states.selectedCategory(categoryName())
		end,

		show(isSelected, function()
			return create("Frame")({
				Name = "Indicator",
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = colorSpring(theme.categoryTabsIndicatorColor),
				Position = UDim2.fromScale(0, 1),
				Size = px.udim2(1, 0, 0, 4),
				ZIndex = zIndex,
			})
		end),
		show(function()
			local categories = states.categories()
			return categories[#categories] ~= category()
		end, function()
			return create("Frame")({
				Name = "Divider",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = colorSpring(theme.categoryTabsDividerColor),
				BackgroundTransparency = 0.8,
				Position = cond.ifelse(props.inBar, UDim2.fromScale(1, 0.5), UDim2.fromScale(0.5, 1)),
				Size = cond.ifelse(props.inBar, px.udim2(0, 1, 1, -8), px.udim2(1, 0, 0, 1)),
				ZIndex = zIndex,
			})
		end),
	})
end

return category
