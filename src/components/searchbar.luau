local px = require("../utils/px")
local states = require("../states")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local vide = require("../../vide")

local SEARCH_BORDER_COLOR: Color3 = Color3.new(1, 1, 1)
local SEARCH_BORDER_TRANSPARENCY: number = 0.8
local SEARCH_TEXT_OFFSET: number = 8
local SEARCH_IMAGE_X: string = "rbxasset://textures/ui/InspectMenu/x.png"

local create = vide.create
local changed = vide.changed

type Props = {
	searchText: vide.Source<string>,
}

local function searchbar(props: Props)
	local searchText = props.searchText

	local preferredTransparency = usePreferredTransparency()

	return create("TextBox")({
		Name = "Search",
		BackgroundColor3 = states.attributes.BackgroundColor3,
		BackgroundTransparency = function()
			return (states.attributes.BackgroundTransparency() - 0.1) * preferredTransparency()
		end,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		FontFace = states.attributes.FontFace,
		PlaceholderText = "Search",
		Size = px.udim2(1, 0, 0, 30),
		Text = searchText,
		TextColor3 = states.attributes.TextColor3,
		TextSize = px.scale(states.attributes.TextSize),
		TextStrokeColor3 = states.attributes.TextStrokeColor3,
		TextStrokeTransparency = states.attributes.TextStrokeTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,

		changed("Text", function(value: string)
			searchText(value)
		end),

		create("UIPadding")({
			PaddingLeft = px.udim(0, SEARCH_TEXT_OFFSET),
			PaddingRight = px.udim(0, SEARCH_TEXT_OFFSET),
			PaddingTop = px.udim(0, SEARCH_TEXT_OFFSET),
			PaddingBottom = px.udim(0, SEARCH_TEXT_OFFSET),
		}),
		create("UIStroke")({
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = SEARCH_BORDER_COLOR,
			Transparency = SEARCH_BORDER_TRANSPARENCY,
			Thickness = px.scale(1),
		}),
		create("UICorner")({
			CornerRadius = states.attributes.SmallCornerRadius,
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
