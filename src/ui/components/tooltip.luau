local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local px = require("../../core/utils/px")
local theme = require("../theme")
local vide = require("../../../vide")

local create = vide.create
local spring = vide.spring

local TOOLTIP_PADDING = 5
local TOOLTIP_OFFSET = -10

type Props = {
	text: () -> string,
	visible: (() -> boolean)?,
}

local function tooltip(props: Props)
	local visible: vide.UsedAs<boolean> = props.visible or true

	return create("TextLabel")({
		Name = "ToolTip",
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = colorSpring(theme.tooltipBackgroundColor),
		BackgroundTransparency = spring(cond.ifelse(visible, theme.tooltipBackgroundTransparency, 1), 0.2),
		Position = spring(cond.ifelse(visible, px.udim2(0.5, 0, 0, TOOLTIP_OFFSET), px.udim2(0.5, 0, 0, 0)), 0.2),
		FontFace = theme.tooltipFontFace,
		Text = props.text,
		TextColor3 = colorSpring(theme.tooltipTextColor),
		TextSize = px.scale(theme.tooltipTextSize),
		TextTransparency = spring(cond.ifelse(visible, 0, 1), 0.2),
		RichText = true,
		TextStrokeColor3 = colorSpring(theme.textStrokeColor),
		TextStrokeTransparency = spring(cond.ifelse(visible, theme.textStrokeTransparency, 1), 0.2),
		ZIndex = 3,

		create("UICorner")({
			CornerRadius = theme.tooltipCornerRadius,
		}),

		create("UIPadding")({
			PaddingTop = px.udim(0, TOOLTIP_PADDING),
			PaddingBottom = px.udim(0, TOOLTIP_PADDING),
			PaddingLeft = px.udim(0, TOOLTIP_PADDING),
			PaddingRight = px.udim(0, TOOLTIP_PADDING),
		}),
	}),
		0.2
end

return tooltip
