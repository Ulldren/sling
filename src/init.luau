const closeInventory = require("@self/api/closeInventory")
const createCategory = require("@self/api/createCategory")
const events = require("@self/events")
const getTopbarIcon = require("@self/api/getTopbarIcon")
const isEnabled = require("@self/api/isEnabled")
const isInventoryOpen = require("@self/api/isInventoryOpen")
const openInventory = require("@self/api/openInventory")
const setEnabled = require("@self/api/setEnabled")
const toggleInventory = require("@self/api/toggleInventory")
const types = require("./vide-backpack/types")
const themes = require("./vide-backpack/themes")
const setTheme = require("@self/api/setTheme")
const render = require("@self/components/render")

export type ThemeConfig = types.ThemeConfig

require("@self/topbarIcon")
require("@self/attribution")

render()

return table.freeze({
	-- API
	openInventory = openInventory,
	closeInventory = closeInventory,
	toggleInventory = toggleInventory,
	isInventoryOpen = isInventoryOpen,
	isEnabled = isEnabled,
	setEnabled = setEnabled,
	createCategory = createCategory,
	setTheme = setTheme,
	getTopbarIcon = getTopbarIcon,

	-- Themes
	themes = themes,

	-- Hooks
	onBackpackEmpty = events.backpackEmpty.on,
	onBackpackEquipped = events.backpackEquipped.on,
	onBackpackUnequipped = events.backpackUnequipped.on,
	onBackpackAdded = events.backpackAdded.on,
	onBackpackRemoved = events.backpackRemoved.on,
	onInventoryOpened = events.inventoryOpened.on,
	onInventoryClosed = events.inventoryClosed.on,
})
