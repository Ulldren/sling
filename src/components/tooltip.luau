local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local px = require("../utils/px")
local theme = require("../theme")
local vide = require("../../vide")

local create = vide.create
local spring = vide.spring
local source = vide.source

type Props = {
	text: vide.Source<string>,
	visible: vide.Source<boolean>?,
}

local function tooltip(props: Props)
	local visible: vide.Source<boolean> = props.visible or source(true)

	return create("TextLabel")({
		Name = "ToolTip",
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = colorSpring(theme.theme.tooltipBackgroundColor),
		BackgroundTransparency = spring(cond.ifelse(visible, theme.theme.tooltipBackgroundTransparency, 1), 0.2),
		Position = spring(cond.ifelse(visible, px.udim2(0.5, 0, 0, -10), px.udim2(0.5, 0, 0, 0)), 0.2),
		FontFace = theme.theme.tooltipFontFace,
		Text = props.text,
		TextColor3 = colorSpring(theme.theme.tooltipTextColor),
		TextSize = px.scale(theme.theme.tooltipTextSize),
		TextTransparency = spring(cond.ifelse(visible, 0, 1), 0.2),
		TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
		TextStrokeTransparency = spring(cond.ifelse(visible, theme.theme.textStrokeTransparency, 1), 0.2),
		ZIndex = 3,

		create("UICorner")({
			CornerRadius = theme.theme.tooltipCornerRadius,
		}),

		create("UIPadding")({
			PaddingTop = px.udim(0, 4),
			PaddingBottom = px.udim(0, 4),
			PaddingLeft = px.udim(0, 4),
			PaddingRight = px.udim(0, 4),
		}),
	})
end

return tooltip
