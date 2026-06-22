local events = require("@self/core/events")
local render = require("@self/ui/components/render")
local states = require("@self/core/states")
local themes = require("@self/ui/themes")
local types = require("@self/core/types")

export type ThemeConfig = types.ThemeConfig
export type SlotContext = types.SlotContext
export type SlotProperties = types.SlotProperties

require("@self/attribution")
require("@self/core/topbarIcon")

render()

return {
	-- API
	openInventory = require("@self/api/openInventory"),
	closeInventory = require("@self/api/closeInventory"),
	toggleInventory = require("@self/api/toggleInventory"),
	isInventoryOpen = require("@self/api/isInventoryOpen"),
	isEnabled = require("@self/api/isEnabled"),
	setEnabled = require("@self/api/setEnabled"),
	createCategory = require("@self/api/createCategory"),
	setTheme = require("@self/api/setTheme"),
	setHotbar = require("@self/api/setHotbar"),
	getTopbarIcon = require("@self/api/getTopbarIcon"),

	-- Themes
	themes = themes,

	-- Callbacks

	--- Sets a callback function that runs whenever a slot is rendered.
	onSlotRender = function(callback: (context: SlotContext) -> SlotProperties)
		if states.onSlotRender().callback then
			error("[Sling] onSlotRender can only be set once.", 0)
		end
		states.onSlotRender({ callback = callback })
	end,

	-- Events

	--- Fires whenever the player's inventory interface is opened.
	onInventoryOpened = events.inventoryOpened.on,
	--- Fires whenever the player's inventory interface is closed.
	onInventoryClosed = events.inventoryClosed.on,
	--- Fires whenever the backpack is initially loaded.
	onBackpackLoaded = function(callback)
		if states.isBackpackLoaded() then
			task.spawn(callback, states.items())
		end
		return events.backpackLoaded.on(callback)
	end,
	--- Fires when the player equips an item on character.
	onBackpackItemEquipped = events.backpackItemEquipped.on,
	--- Fires when the player unequips their currently active item.
	onBackpackItemUnequipped = events.backpackItemUnequipped.on,
	--- Fires when an item is added to the player's backpack.
	onBackpackItemAdded = events.backpackItemAdded.on,
	--- Fires when an item is removed entirely from the player's backpack.
	onBackpackItemRemoved = events.backpackItemRemoved.on,
	--- Fires when the backpack becomes entirely empty (contains no items).
	onBackpackEmpty = events.backpackEmpty.on,
	--- Fires whenever the hotbar layout changes manually.
	onHotbarChanged = events.hotbarChanged.on,
}
