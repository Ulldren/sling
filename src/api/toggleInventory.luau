const closeInventory = require("./closeInventory")
const isInventoryOpen = require("./isInventoryOpen")
const openInventory = require("./openInventory")

const function toggleInventory()
	if isInventoryOpen() then
		closeInventory()
	else
		openInventory()
	end
end

return toggleInventory
