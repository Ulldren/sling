local closeInventory = require("@self/api/closeInventory")
local createCategory = require("@self/api/createCategory")
local events = require("@self/events")
local getTopbarIcon = require("@self/api/getTopbarIcon")
local isEnabled = require("@self/api/isEnabled")
local isInventoryOpen = require("@self/api/isInventoryOpen")
local openInventory = require("@self/api/openInventory")
local setEnabled = require("@self/api/setEnabled")
local toggleInventory = require("@self/api/toggleInventory")

require("@self/appRoot")
require("@self/topbarIcon")

return table.freeze({
	-- API
	openInventory = openInventory,
	closeInventory = closeInventory,
	toggleInventory = toggleInventory,
	isInventoryOpen = isInventoryOpen,
	isEnabled = isEnabled,
	setEnabled = setEnabled,
	createCategory = createCategory,
	getTopbarIcon = getTopbarIcon,

	-- Hooks
	onBackpackEmpty = events.backpackEmpty.on,
	onBackpackEquipped = events.backpackEquipped.on,
	onBackpackUnequipped = events.backpackUnequipped.on,
	onBackpackRemoved = events.backpackRemoved.on,
	onInventoryOpened = events.inventoryOpened.on,
	onInventoryClosed = events.inventoryClosed.on,
})
