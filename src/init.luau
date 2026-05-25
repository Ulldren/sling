local events = require("@self/events")
local mainController = require("@self/lib/mainController")
local appController = require("./inventoryplus/lib/appController")

require("./inventoryplus/lib/topbarIcon")

appController:mount()

return table.freeze({
	-- API
	openInventory = mainController.openInventory,
	closeInventory = mainController.closeInventory,
	toggleInventory = mainController.toggleInventory,
	isInventoryOpen = mainController.isInventoryOpen,
	isEnabled = mainController.isEnabled,
	setEnabled = mainController.setEnabled,
	createCategory = mainController.createCategory,
	getTopbarIcon = mainController.getTopbarIcon,

	-- Hooks
	onBackpackEmpty = events.backpackEmpty.on,
	onBackpackEquipped = events.backpackEquipped.on,
	onBackpackUnequipped = events.backpackUnequipped.on,
	onBackpackRemoved = events.backpackRemoved.on,
	onInventoryOpened = events.inventoryOpened.on,
	onInventoryClosed = events.inventoryClosed.on,
})
