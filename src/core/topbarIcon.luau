local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local closeInventory = require("../api/closeInventory")
local events = require("./events")
local openInventory = require("../api/openInventory")
local config = require("./config")
if config.useCustomInventory or not RunService:IsRunning() then
	return nil :: Icon?
end


local topbarplus = require(ReplicatedStorage.Shared.Packages.topbarplus)

local icon = topbarplus.new()
icon:setName("Sling")
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

events.inventoryOpened.on(function()
	icon:select()
end)
events.inventoryClosed.on(function()
	icon:deselect()
end)

icon.toggled:Connect(function(isSelected, fromSource)
	if fromSource == "User" then
		if isSelected then
			openInventory()
		else
			closeInventory()
		end
	end
end)

type Icon = typeof(icon)

return icon :: Icon?
