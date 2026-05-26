const UserInputService = game:GetService("UserInputService")

const px = require("../utils/px")
const states = require("../states")
const vide = require("../../vide")

const create = vide.create

type Props = {
	keyCode: Enum.KeyCode,
	text: string,
}

const function inventoryHint(props: Props)
	return create("Frame")({
		Name = "HintFrame",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = px.offset(0, 40),

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = px.udim(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		create("ImageLabel")({
			Name = "HintImage",
			BackgroundTransparency = 1,
			Image = UserInputService:GetImageForKeyCode(props.keyCode),
			Size = px.offset(30, 30),
		}),
		create("TextLabel")({
			Name = "HintText",
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = function()
				return Font.new(states.attributes.FontFace().Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
			end,
			Text = props.text,
			TextColor3 = states.attributes.TextColor3,
			TextSize = px.scale(states.attributes.TextSize),
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
	})
end

return inventoryHint
