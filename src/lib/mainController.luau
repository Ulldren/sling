local topbarplus = require("../../topbarplus")
local events = require("../events")
local states = require("../states")
local types = require("../types")

local inventoryOpened = events.inventoryOpened
local inventoryClosed = events.inventoryClosed
local backpackEnabled = events.backpackEnabled
local categoryAdded = events.categoryAdded

local function isInventoryOpen()
	return states.opened()
end

local function openInventory()
	states.opened(true)
	for _, listener in inventoryOpened.callbacks do
		task.spawn(listener)
	end
end

local function closeInventory()
	states.opened(false)
	for _, listener in inventoryClosed.callbacks do
		task.spawn(listener)
	end
end

local function toggleInventory()
	if isInventoryOpen() then
		closeInventory()
	else
		openInventory()
	end
end

local function isEnabled()
	return states.enabled()
end

local function setEnabled(value: boolean)
	states.enabled(value)
	for _, listener in backpackEnabled.callbacks do
		task.spawn(listener, value)
	end
end

--[=[
	Creates a new category for the inventory.
	
	```lua
	createCategory("Weapons", function(item)
		return item:GetAttribute("Weapon") == true
	end)
]=]
local function createCategory(category: string, predicate: types.CategoryPredicate)
	local state = states.categories()
	local newCategory = { category = category, predicate = predicate }
	table.insert(state, newCategory)
	states.categories(state)

	for _, listener in categoryAdded.callbacks do
		task.spawn(listener, newCategory)
	end
end

local function getTopbarIcon()
	return topbarplus.getIcon("InventoryPlus") :: topbarplus.Icon?
end

return {
	isInventoryOpen = isInventoryOpen,
	openInventory = openInventory,
	closeInventory = closeInventory,
	toggleInventory = toggleInventory,
	isEnabled = isEnabled,
	setEnabled = setEnabled,
	getTopbarIcon = getTopbarIcon,
	createCategory = createCategory,
}
