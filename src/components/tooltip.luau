const px = require("../utils/px")
const vide = require("../../vide")
const theme = require("../theme")
const colorSpring = require("../utils/colorSpring")
const cond = require("../utils/cond")

const create = vide.create
const spring = vide.spring
const source = vide.source
const effect = vide.effect

type Props = {
	text: vide.Source<string>,
	visible: vide.Source<boolean>?,
}

const function tooltip(props: Props)
	const visible: vide.Source<boolean> = source(false)

	if props.visible then
		effect(function()
			visible(props.visible())
		end)
	else
		visible(true)
	end

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
