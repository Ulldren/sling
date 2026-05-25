local vide = require("../../vide")
local types = require("../types")

local SEARCH_BORDER_COLOR: Color3 = Color3.new(1, 1, 1)
local SEARCH_BORDER_TRANSPARENCY: number = 0.8
local SEARCH_TEXT_OFFSET: number = 8
local SEARCH_IMAGE_X: string = "rbxasset://textures/ui/InspectMenu/x.png"

local create = vide.create
local changed = vide.changed

type Props = {
	searchText: vide.Source<string>,
	attributes: types.Attributes,
}

local function searchbar(props: Props)
	local searchText = props.searchText

	return create("TextBox")({
		Name = "Search",
		BackgroundColor3 = props.attributes.BackgroundColor3,
		BackgroundTransparency = props.attributes.BackgroundTransparency,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		FontFace = props.attributes.FontFace,
		PlaceholderText = "Search",
		Size = UDim2.new(1, 0, 0, 30),
		Text = searchText,
		TextColor3 = props.attributes.TextColor3,
		TextSize = props.attributes.TextSize,
		TextStrokeColor3 = props.attributes.TextStrokeColor3,
		TextStrokeTransparency = props.attributes.TextStrokeTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,

		changed("Text", function(value: string)
			searchText(value)
		end),

		create("UIPadding")({
			PaddingLeft = UDim.new(0, SEARCH_TEXT_OFFSET),
			PaddingRight = UDim.new(0, SEARCH_TEXT_OFFSET),
			PaddingTop = UDim.new(0, SEARCH_TEXT_OFFSET),
			PaddingBottom = UDim.new(0, SEARCH_TEXT_OFFSET),
		}),
		create("UIStroke")({
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = SEARCH_BORDER_COLOR,
			Transparency = SEARCH_BORDER_TRANSPARENCY,
		}),
		create("UICorner")({
			CornerRadius = props.attributes.SmallCornerRadius,
		}),
		create("ImageButton")({
			Name = "Clear",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			Image = SEARCH_IMAGE_X,
			Visible = function()
				return searchText() ~= ""
			end,

			Activated = function()
				searchText("")
			end,

			create("UIAspectRatioConstraint")({
				AspectRatio = 1,
			}),
		}),
	})
end

return searchbar
