local UserInputService = game:GetService("UserInputService")

local colorSpring = require("../../core/utils/colorSpring")
local px = require("../../core/utils/px")
local theme = require("../theme")
local vide = require("../../../vide")

local create = vide.create

type Props = {
	keyCode: Enum.KeyCode,
	text: string,
}

local function inventoryHint(props: Props)
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
				return Font.new(theme.hintFontFace().Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
			end,
			Text = props.text,
			TextColor3 = colorSpring(theme.hintTextColor),
			TextSize = px.scale(theme.hintTextSize),
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
	})
end

return inventoryHint
