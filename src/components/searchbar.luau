local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local px = require("../utils/px")
local states = require("../states")
local theme = require("../theme")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local vide = require("../../vide")

local SEARCH_TEXT = "Search"
local SEARCH_WIDTH = 190
local SEARCH_IMAGE_X: string = "rbxasset://textures/ui/InspectMenu/x.png"

pcall(function()
	local LocalizationService = game:GetService("LocalizationService")
	local CorescriptLocalization = LocalizationService:GetCorescriptLocalizations()[1] :: any
	SEARCH_TEXT = CorescriptLocalization:GetString(LocalizationService.RobloxLocaleId, "BACKPACK_SEARCH")
end)

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
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		BackgroundColor3 = colorSpring(theme.theme.searchBackgroundColor),
		BackgroundTransparency = function()
			return theme.theme.searchBackgroundTransparency() * preferredTransparency()
		end,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		FontFace = theme.theme.searchFontFace,
		PlaceholderText = SEARCH_TEXT,
		PlaceholderColor3 = colorSpring(theme.theme.searchTextColor),
		Size = cond.ifelse(
			cond.gt(states.width, SEARCH_WIDTH),
			px.udim2(0, SEARCH_WIDTH, 0, 30),
			px.udim2(1, 0, 0, 30)
		),
		Text = searchText,
		TextColor3 = colorSpring(theme.theme.searchTextColor),
		TextTransparency = cond.ifelse(cond.neq(searchText, ""), 0, 0.7),
		TextSize = px.scale(theme.theme.searchTextSize),
		TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
		TextStrokeTransparency = theme.theme.textStrokeTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,

		changed("Text", function(value: string)
			searchText(value)
		end),

		create("UIPadding")({
			PaddingLeft = px.udim(0, 8),
			PaddingRight = px.udim(0, 8),
			PaddingTop = px.udim(0, 8),
			PaddingBottom = px.udim(0, 8),
		}),
		create("UIStroke")({
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = colorSpring(theme.theme.searchStrokeColor),
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
