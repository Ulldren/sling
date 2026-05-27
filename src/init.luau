const closeInventory = require("@self/api/closeInventory")
const createCategory = require("@self/api/createCategory")
const events = require("@self/events")
const getTopbarIcon = require("@self/api/getTopbarIcon")
const isEnabled = require("@self/api/isEnabled")
const isInventoryOpen = require("@self/api/isInventoryOpen")
const openInventory = require("@self/api/openInventory")
const setEnabled = require("@self/api/setEnabled")
const toggleInventory = require("@self/api/toggleInventory")

require("@self/components/render")()
require("@self/topbarIcon")
require("@self/attribution")

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
