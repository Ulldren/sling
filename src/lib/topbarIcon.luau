local topbarplus = require("../../topbarplus")
local events = require("../events")
local mainController = require("./mainController")

local icon = topbarplus.new()
icon:setName("InventoryPlus")
icon:modifyTheme({
	{ "IconLabelContainer", "TargetWidth", 0 }, -- Force minimum width
	{ "IconLabel", "AutoLocalize", false }, -- Don't translate font icon
})
icon:setLabel("backpack")
icon:setOrder(-1)
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
icon:bindToggleKey(Enum.KeyCode.Backquote)
icon:autoDeselect(false)
icon:setCaption("Inventory")

icon.toggled:Connect(function(isSelected, fromSource)
	if fromSource == "User" then
		if isSelected then
			mainController.openInventory()
		else
			mainController.closeInventory()
		end
	end
end)

events.inventoryOpened.on(function()
	icon:select()
end)

events.inventoryClosed.on(function()
	icon:deselect()
end)

return icon
