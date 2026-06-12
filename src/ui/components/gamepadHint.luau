local UserInputService = game:GetService("UserInputService")

local colorSpring = require("../../core/utils/colorSpring")
local px = require("../../core/utils/px")
local theme = require("../theme")
local vide = require("../../../vide")

local create = vide.create

local GAMEPAD_HINT_HEIGHT = 40
local GAMEPAD_HINT_PADDING = 12
local GAMEPAD_HINT_IMAGE_SIZE = 30

type Props = {
	keyCode: Enum.KeyCode,
	text: string,
}

local function gamepadHint(props: Props)
	return create("Frame")({
		Name = "HintFrame",
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = px.offset(0, GAMEPAD_HINT_HEIGHT),

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = px.udim(0, GAMEPAD_HINT_PADDING),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		create("ImageLabel")({
			Name = "HintImage",
			BackgroundTransparency = 1,
			Image = UserInputService:GetImageForKeyCode(props.keyCode),
			Size = px.offset(GAMEPAD_HINT_IMAGE_SIZE, GAMEPAD_HINT_IMAGE_SIZE),
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

return gamepadHint
