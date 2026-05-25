local vide = require("../../vide")
local types = require("../types")

local create = vide.create

type Props = {
	text: vide.Source<string>,
	attributes: types.Attributes,
}

local function tooltip(props: Props)
	return create("TextLabel")({
		Name = "ToolTip",
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(39, 42, 45),
		Position = UDim2.new(0.5, 0, 0, -10),
		Size = UDim2.new(0, 0, 0, 0),
		FontFace = props.attributes.FontFace,
		Text = props.text,
		TextColor3 = props.attributes.TextColor3,
		TextSize = props.attributes.TextSize,
		TextStrokeColor3 = props.attributes.TextStrokeColor3,
		TextStrokeTransparency = props.attributes.TextStrokeTransparency,

		create("UICorner")({
			CornerRadius = props.attributes.SmallCornerRadius,
		}),

		create("UIPadding")({
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		}),
	})
end

return tooltip
