local Icon = require("../VideBackpackLoader/VideBackpack/Packages/topbarplus")
local backpack = require("../VideBackpackLoader/VideBackpack")

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
	backpack.setTheme(backpack.themes.default)
end)

local lightTheme = Icon.new()
lightTheme:oneClick(true)
lightTheme:setLabel("Light")
lightTheme:bindEvent("deselected", function()
	backpack.setTheme(backpack.themes.white)
end)

icon:setDropdown({ defaultTheme, lightTheme })
