local themes = require("./constants/themes")
local types = require("./types")
local vide = require("../vide")

local source = vide.source
local read = vide.read

local default = themes.default

local selectedTheme: vide.Source<types.ThemeConfig> = source(default :: any)

type Can<T> = types.Can<T>

local function selectProp(prop: string, defaultProp: string?): () -> any
	return function()
		return read(selectedTheme()[prop])
			or read(default[prop])
			or (defaultProp and read(selectedTheme()[defaultProp] or default[defaultProp]))
	end
end

return {
	selected = selectedTheme,

	theme = {
		backgroundColor = selectProp("backgroundColor"),
		backgroundTransparency = selectProp("backgroundTransparency"),
		cornerRadius = selectProp("cornerRadius"),
		smallCornerRadius = selectProp("smallCornerRadius"),
		fontFace = selectProp("fontFace"),
		textColor = selectProp("textColor"),
		textSize = selectProp("textSize"),
		smallTextSize = selectProp("smallTextSize"),
		textStrokeColor = selectProp("textStrokeColor"),
		textStrokeTransparency = selectProp("textStrokeTransparency"),

		searchBackgroundColor = selectProp("searchBackgroundColor", "backgroundColor"),
		searchBackgroundTransparency = selectProp("searchBackgroundTransparency", "backgroundTransparency"),
		searchCornerRadius = selectProp("searchCornerRadius", "smallCornerRadius"),
		searchStrokeColor = selectProp("searchStrokeColor"),
		searchStrokeTransparency = selectProp("searchStrokeTransparency"),
		searchFontFace = selectProp("searchFontFace", "fontFace"),
		searchTextColor = selectProp("searchTextColor", "textColor"),
		searchTextSize = selectProp("searchTextSize", "textSize"),

		hintFontFace = selectProp("hintFontFace", "fontFace"),
		hintTextColor = selectProp("hintTextColor", "textColor"),
		hintTextSize = selectProp("hintTextSize", "textSize"),

		slotBackgroundColor = selectProp("slotBackgroundColor", "backgroundColor"),
		slotBackgroundTransparency = selectProp("slotBackgroundTransparency", "backgroundTransparency"),
		slotCornerRadius = selectProp("slotCornerRadius", "cornerRadius"),
		slotEquipStrokeColor = selectProp("slotEquipStrokeColor"),
		slotEquipStrokeThickness = selectProp("slotEquipStrokeThickness"),
		slotFontFace = selectProp("slotFontFace", "fontFace"),
		slotTextColor = selectProp("slotTextColor", "textColor"),
		slotTextSize = selectProp("slotTextSize", "textSize"),

		tooltipBackgroundColor = selectProp("tooltipBackgroundColor", "backgroundColor"),
		tooltipBackgroundTransparency = selectProp("tooltipBackgroundTransparency", "backgroundTransparency"),
		tooltipCornerRadius = selectProp("tooltipCornerRadius", "smallCornerRadius"),
		tooltipFontFace = selectProp("tooltipFontFace", "fontFace"),
		tooltipTextColor = selectProp("tooltipTextColor", "textColor"),
		tooltipTextSize = selectProp("tooltipTextSize", "smallTextSize"),
	},
}
