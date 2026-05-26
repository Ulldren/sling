local px = require("../utils/px")
local states = require("../states")
local vide = require("../../vide")

local create = vide.create

type Props = {
	text: vide.Source<string>,
}

local function tooltip(props: Props)
	return create("TextLabel")({
		Name = "ToolTip",
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(39, 42, 45),
		Position = px.udim2(0.5, 0, 0, -10),
		FontFace = states.attributes.FontFace,
		Text = props.text,
		TextColor3 = states.attributes.TextColor3,
		TextSize = px.scale(states.attributes.TextSize),
		TextStrokeColor3 = states.attributes.TextStrokeColor3,
		TextStrokeTransparency = states.attributes.TextStrokeTransparency,
		ZIndex = 3,

		create("UICorner")({
			CornerRadius = states.attributes.SmallCornerRadius,
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
