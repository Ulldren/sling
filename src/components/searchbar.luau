const px = require("../utils/px")
const vide = require("../../vide")
const theme = require("../theme")
const usePreferredTransparency = require("../hooks/usePreferredTransparency")
const colorSpring = require("../utils/colorSpring")
const cond = require("../utils/cond")

const SEARCH_PADDING: number = 8
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
		BackgroundColor3 = colorSpring(theme.theme.searchBackgroundColor),
		BackgroundTransparency = function()
			return theme.theme.searchBackgroundTransparency() * preferredTransparency()
		end,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		FontFace = theme.theme.searchFontFace,
		PlaceholderText = "Search",
		PlaceholderColor3 = colorSpring(theme.theme.searchPlaceholderColor),
		Size = px.udim2(1, 0, 0, 30),
		Text = searchText,
		TextColor3 = colorSpring(theme.theme.searchTextColor),
		TextSize = px.scale(theme.theme.searchTextSize),
		TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
		TextStrokeTransparency = theme.theme.textStrokeTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,

		changed("Text", function(value: string)
			searchText(value)
		end),

		create("UIPadding")({
			PaddingLeft = px.udim(0, SEARCH_PADDING),
			PaddingRight = px.udim(0, SEARCH_PADDING),
			PaddingTop = px.udim(0, SEARCH_PADDING),
			PaddingBottom = px.udim(0, SEARCH_PADDING),
		}),
		create("UIStroke")({
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = theme.theme.searchStrokeColor,
			Transparency = theme.theme.searchStrokeTransparency,
			Thickness = px.scale(1),
		}),
		create("UICorner")({
			CornerRadius = theme.theme.searchCornerRadius,
		}),
		create("ImageButton")({
			Name = "Clear",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			Image = SEARCH_IMAGE_X,
			ImageColor3 = colorSpring(theme.theme.searchTextColor),
			Visible = cond.neq(searchText, ""),

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
