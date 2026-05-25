local UserInputService = game:GetService("UserInputService")

local vide = require("../../vide")
local types = require("../types")

local create = vide.create

type Props = {
	keyCode: Enum.KeyCode,
	text: string,
	attributes: types.Attributes,
}

local function inventoryHint(props: Props)
	return create("Frame")({
		Name = "HintFrame",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 40),

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		create("ImageLabel")({
			Name = "HintImage",
			BackgroundTransparency = 1,
			Image = UserInputService:GetImageForKeyCode(props.keyCode),
			Size = UDim2.fromOffset(30, 30),
		}),
		create("TextLabel")({
			Name = "HintText",
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = function()
				return Font.new(props.attributes.FontFace().Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
			end,
			Text = props.text,
			TextColor3 = props.attributes.TextColor3,
			TextSize = props.attributes.TextSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,

			create("UITextSizeConstraint")({
				MaxTextSize = 19,
			}),
		}),
	})
end

return inventoryHint
