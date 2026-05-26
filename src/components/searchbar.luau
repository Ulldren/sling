const px = require("../utils/px")
const states = require("../states")
const usePreferredTransparency = require("../hooks/usePreferredTransparency")
const vide = require("../../vide")

const SEARCH_BORDER_COLOR: Color3 = Color3.new(1, 1, 1)
const SEARCH_BORDER_TRANSPARENCY: number = 0.8
const SEARCH_TEXT_OFFSET: number = 8
const SEARCH_IMAGE_X: string = "rbxasset://textures/ui/InspectMenu/x.png"

const create = vide.create
const changed = vide.changed

type Props = {
	searchText: vide.Source<string>,
}

const function searchbar(props: Props)
	const searchText = props.searchText

	const preferredTransparency = usePreferredTransparency()

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
