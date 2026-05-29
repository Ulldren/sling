local closeInventory = require("@self/api/closeInventory")
local createCategory = require("@self/api/createCategory")
local events = require("@self/events")
local getTopbarIcon = require("@self/api/getTopbarIcon")
local isEnabled = require("@self/api/isEnabled")
local isInventoryOpen = require("@self/api/isInventoryOpen")
local openInventory = require("@self/api/openInventory")
local setEnabled = require("@self/api/setEnabled")
local toggleInventory = require("@self/api/toggleInventory")
local types = require("@self/types")
local themes = require("@self/themes")
local setTheme = require("@self/api/setTheme")
local render = require("@self/components/render")

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
