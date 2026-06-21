local states = require("../core/states")
local themes = require("./themes")
local types = require("../core/types")
local vide = require("../../vide")

local read = vide.read

local default = themes.default

local function selectProp<Name>(
	prop: Name | keyof<types.ThemeGetters>,
	secondaryProp: (Name | keyof<types.ThemeGetters>)?
): index<types.ThemeGetters, Name>
	return function()
		local selectedThemeProp = read((states.selectedTheme() :: any)[prop])
		if selectedThemeProp ~= nil then
			return selectedThemeProp
		else
			local defaultThemeProp = read((default :: any)[prop])
			if defaultThemeProp ~= nil then
				return defaultThemeProp
			elseif secondaryProp then
				return (selectProp :: any)(secondaryProp)()
			end
		end
		return nil
	end :: any
end

local theme: types.ThemeGetters = {
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

	categoryTabsBackgroundColor = selectProp("categoryTabsBackgroundColor", "backgroundColor"),
	categoryTabsFontFace = selectProp("categoryTabsFontFace"),
	categoryTabsTextColor = selectProp("categoryTabsTextColor", "textColor"),
	categoryTabsTextSize = selectProp("categoryTabsTextSize", "textSize"),
	categoryTabsIndicatorColor = selectProp("categoryTabsIndicatorColor", "textColor"),

	hintFontFace = selectProp("hintFontFace", "fontFace"),
	hintTextColor = selectProp("hintTextColor", "textColor"),
	hintTextSize = selectProp("hintTextSize", "textSize"),

	slotBackgroundColor = selectProp("slotBackgroundColor", "backgroundColor"),
	slotBackgroundTransparency = selectProp("slotBackgroundTransparency", "backgroundTransparency"),
	slotCornerRadius = selectProp("slotCornerRadius", "cornerRadius"),
	slotEquipStrokeColor = selectProp("slotEquipStrokeColor"),
	slotEquipStrokeThickness = selectProp("slotEquipStrokeThickness"),
	slotEquipStrokeOutline = selectProp("slotEquipStrokeOutline"),
	slotFontFace = selectProp("slotFontFace", "fontFace"),
	slotTextColor = selectProp("slotTextColor", "textColor"),
	slotTextSize = selectProp("slotTextSize", "textSize"),

	tooltipBackgroundColor = selectProp("tooltipBackgroundColor", "backgroundColor"),
	tooltipBackgroundTransparency = selectProp("tooltipBackgroundTransparency", "backgroundTransparency"),
	tooltipCornerRadius = selectProp("tooltipCornerRadius", "smallCornerRadius"),
	tooltipFontFace = selectProp("tooltipFontFace", "fontFace"),
	tooltipTextColor = selectProp("tooltipTextColor", "textColor"),
	tooltipTextSize = selectProp("tooltipTextSize", "smallTextSize"),
}

return theme
