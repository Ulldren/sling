local states = require("./states")
local vide = require("../../vide")

local untrack = vide.untrack

local function getItemIndex(item: BackpackItem): number?
	local items = untrack(states.items)
	for i, v in items do
		if v == item then
			return i
		end
	end
	return nil
end

local function findLowestEmptyHotbarSlot(): number?
	local slots = untrack(states.slots)
	local items = untrack(states.items)
	for i = 1, slots do
		if not items[i] then
			return i
		end
	end
	return nil
end

local function findLowestEmptyInventorySlot(): number
	local slots = untrack(states.slots)
	local items = untrack(states.items)
	local initialCount = slots + 1
	local maxItems = math.max(table.maxn(items), initialCount)
	for i = initialCount, maxItems do
		if not items[i] then
			return i
		end
	end
	return maxItems + 1
end

local function findLowestEmptySlot(): number
	local hotbarSlot = findLowestEmptyHotbarSlot()
	if hotbarSlot then
		return hotbarSlot
	end
	return findLowestEmptyInventorySlot()
end

local function closeInventoryGaps(items: typeof(states.items()))
	local slots = untrack(states.slots)
	local invIndex = slots + 1
	local maxItems = math.max(table.maxn(items), invIndex)
	for i = invIndex, maxItems do
		local item = items[i]
		if item then
			if i > invIndex then
				items[i], items[invIndex] = nil, item
			end
			invIndex += 1
		end
	end
end

local function swap(indexA: number, indexB: number)
	if (not indexA or not indexB) or indexA == indexB then
		return false
	end
	local slots = untrack(states.slots)
	local newItems = untrack(states.items)

	newItems[indexA], newItems[indexB] = newItems[indexB], newItems[indexA]

	if indexA > slots or indexB > slots then
		closeInventoryGaps(newItems)
	end
	states.items(newItems)
	return true
end

local function moveToHotbar(index: number)
	if not index then
		return false
	end
	local targetIndex = findLowestEmptyHotbarSlot()
	if not targetIndex then
		return false
	end
	swap(index, targetIndex)
	return true
end

local function moveToInventory(index: number)
	local slots = untrack(states.slots)
	if index > slots then
		return false
	end
	local items = untrack(states.items)
	if not items[index] then
		return false
	end
	local targetIndex = findLowestEmptyInventorySlot()
	swap(index, targetIndex)
	return true
end

local function insertToLowestSlot(item: BackpackItem)
	local index = findLowestEmptySlot()
	local currentItems = untrack(states.items)
	currentItems[index] = item
	states.items(currentItems)
	return index
end

local function removeSlot(index: number)
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)
	currentItems[index] = nil
	if index > slots then
		closeInventoryGaps(currentItems)
	end
	states.items(currentItems)
end

local function getHotbarItems()
	local items = untrack(states.items)
	local slots = untrack(states.slots)

	local hotbarItems: { BackpackItem } = {}
	for i = 1, slots do
		hotbarItems[i] = items[i]
	end
	return hotbarItems
end

local function setHotbarItems(items: { BackpackItem }, force: boolean?)
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)

	for i = 1, slots do
		local item = currentItems[i]
		if item and force then
			moveToInventory(i)
		end
		local newItem = items[i]
		if newItem then
			local index = getItemIndex(newItem)
			if index then
				swap(index, i)
			end
		end
	end
end

return {
	getItemIndex = getItemIndex,

	findLowestEmptyHotbarSlot = findLowestEmptyHotbarSlot,
	findLowestEmptyInventorySlot = findLowestEmptyInventorySlot,
	findLowestEmptySlot = findLowestEmptySlot,

	closeInventoryGaps = closeInventoryGaps,
	swap = swap,
	moveToHotbar = moveToHotbar,
	moveToInventory = moveToInventory,

	insertToLowestSlot = insertToLowestSlot,
	removeSlot = removeSlot,

	getHotbarItems = getHotbarItems,
	setHotbarItems = setHotbarItems,
}
