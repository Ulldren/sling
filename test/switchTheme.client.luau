local Icon = require("../Sling/Packages/topbarplus")
local Sling = require("../Sling")

local icon = Icon.new()
icon:modifyTheme({
	{ "IconLabelContainer", "TargetWidth", 0 }, -- Force minimum width
	{ "IconLabel", "AutoLocalize", false }, -- Don't translate font icon
})
icon:setLabel("two-arrows-left-right")
icon:align("Right")
icon:setTextSize(24)
icon:setTextFont(
	"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal,
	"Selected"
)
icon:setTextFont(
	"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal,
	"Deselected"
)
icon:autoDeselect(false)
icon:setCaption("Switch Theme")

local defaultTheme = Icon.new()
defaultTheme:oneClick(true)
defaultTheme:setLabel("Dark")
defaultTheme:bindEvent("deselected", function()
	Sling.setTheme(Sling.themes.default)
end)

local lightTheme = Icon.new()
lightTheme:oneClick(true)
lightTheme:setLabel("Light")
lightTheme:bindEvent("deselected", function()
	Sling.setTheme(Sling.themes.light)
end)

local ristretto: Sling.ThemeConfig = {
	backgroundColor = Color3.fromHex("#2c2525"),
	textColor = Color3.fromHex("#e4b9b9"),
	fontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
	slotEquipStrokeColor = Color3.fromHex("#e4b9b9"),
	slotEquipStrokeOutline = false,
	searchStrokeColor = Color3.fromHex("#e4b9b9"),
}

local ristrettoTheme = Icon.new()
ristrettoTheme:oneClick(true)
ristrettoTheme:setLabel("Ristretto")
ristrettoTheme:bindEvent("deselected", function()
	Sling.setTheme(ristretto)
end)

local legacy: Sling.ThemeConfig = {
	backgroundColor = Color3.new(31 / 255, 31 / 255, 31 / 255),
	backgroundTransparency = 0.5,
	fontFace = Font.fromEnum(Enum.Font.SourceSans),
	textStrokeTransparency = 1,
	cornerRadius = UDim.new(),
	smallCornerRadius = UDim.new(),
	slotBackgroundColor = Color3.new(49 / 255, 49 / 255, 49 / 255),
	slotEquipStrokeColor = Color3.new(90 / 255, 142 / 255, 233 / 255),
	slotEquipStrokeOutline = false,
	searchBackgroundColor = Color3.new(49 / 255, 49 / 255, 49 / 255),
	searchBackgroundTransparency = 0.15,
	searchStrokeTransparency = 1,
}

local legacyTheme = Icon.new()
legacyTheme:oneClick(true)
legacyTheme:setLabel("Legacy")
legacyTheme:bindEvent("deselected", function()
	Sling.setTheme(legacy)
end)

icon:setDropdown({ defaultTheme, lightTheme, ristrettoTheme, legacyTheme })
