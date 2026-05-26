local closeInventory = require("./closeInventory")
local isInventoryOpen = require("./isInventoryOpen")
local openInventory = require("./openInventory")

local function toggleInventory()
	if isInventoryOpen() then
		closeInventory()
	else
		openInventory()
	end
end

return toggleInventory
