local closeInventory = require("./closeInventory")
local isInventoryOpen = require("./isInventoryOpen")
local openInventory = require("./openInventory")
local config = require("../core/config")

local function toggleInventory()
	if config.useCustomInventory then
		return
	end

	if isInventoryOpen() then
		closeInventory()
	else
		openInventory()
	end
end

return toggleInventory
