local app = require("@self/ui/app")
local closeInventory = require("@self/api/closeInventory")
local createCategory = require("@self/api/createCategory")
local events = require("@self/core/events")
local slotManager = require("@self/core/slotManager")
local getTopbarIcon = require("@self/api/getTopbarIcon")
local isEnabled = require("@self/api/isEnabled")
local isInventoryOpen = require("@self/api/isInventoryOpen")
local openInventory = require("@self/api/openInventory")
local _, onSlotRender = require("@self/api/onSlotRender")()
local setEnabled = require("@self/api/setEnabled")
local _, setEquipHandler = require("@self/api/setEquipHandler")()
local setHotbar = require("@self/api/setHotbar")
local setTheme = require("@self/api/setTheme")
local states = require("@self/core/states")
local themes = require("@self/ui/themes")
local toggleInventory = require("@self/api/toggleInventory")
local types = require("@self/core/types")
local config = require("@self/core/config")

export type ThemeConfig = types.ThemeConfig
export type SlotContext = types.SlotContext
export type SlotProperties = types.SlotProperties

local slot = require("@self/ui/components/slot")
export type SlotFrameProps = slot.SlotFrameProps

require("@self/attribution")

return {
	app = app,

	-- expose
	config = config,
	states = states,
	slotManager = slotManager,

	-- API
	openInventory = openInventory,
	closeInventory = closeInventory,
	toggleInventory = toggleInventory,
	isInventoryOpen = isInventoryOpen,
	isEnabled = isEnabled,
	setEnabled = setEnabled,
	createCategory = createCategory,
	setTheme = setTheme,
	setHotbar = setHotbar,
	onSlotRender = onSlotRender,
	setEquipHandler = setEquipHandler,
	getTopbarIcon = getTopbarIcon,

	-- Themes
	themes = themes,

	-- Events
	onInventoryOpened = events.inventoryOpened.on,
	onInventoryClosed = events.inventoryClosed.on,
	onBackpackLoaded = function(callback)
		if states.isBackpackLoaded() then
			task.spawn(callback, states.items())
		end
		return events.backpackLoaded.on(callback)
	end,
	onBackpackItemEquipped = events.backpackItemEquipped.on,
	onBackpackItemUnequipped = events.backpackItemUnequipped.on,
	onBackpackItemAdded = events.backpackItemAdded.on,
	onBackpackItemRemoved = events.backpackItemRemoved.on,
	onBackpackEmpty = events.backpackEmpty.on,
	onHotbarChanged = events.hotbarChanged.on,
}
