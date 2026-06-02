local states = require("../states")
local vide = require("../../vide")

local untrack = vide.untrack

local function getMaxIndex(items: typeof(states.items())?): number
	local currentItems = items or untrack(states.items)
	local maxIndex = 0
	for idx in currentItems do
		if idx > maxIndex then
			maxIndex = idx
		end
	end
	return maxIndex
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
	local maxItems = math.max(getMaxIndex(), initialCount)
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
	local maxItems = math.max(getMaxIndex(items), invIndex)
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

local function swap(idxA: number, idxB: number)
	if not idxA or not idxB then
		return
	end
	local slots = untrack(states.slots)
	local newItems = untrack(states.items)

	newItems[idxA], newItems[idxB] = newItems[idxB], newItems[idxA]

	if idxA > slots or idxB > slots then
		closeInventoryGaps(newItems)
	end
	states.items(newItems)
end

local function moveToHotbar(idx: number)
	if not idx then
		return
	end
	local targetIdx = findLowestEmptyHotbarSlot()
	if not targetIdx then
		return
	end
	swap(idx, targetIdx)
end

local function moveToInventory(idx: number)
	local slots = untrack(states.slots)
	if idx > slots then
		return
	end
	local items = untrack(states.items)
	if not items[idx] then
		return
	end
	local targetIdx = findLowestEmptyInventorySlot()
	swap(idx, targetIdx)
end

local function insertToLowestSlot(item: BackpackItem)
	local index = findLowestEmptySlot()
	local currentItems = untrack(states.items)
	currentItems[index] = item
	states.items(currentItems)
end

local function removeSlot(idx: number)
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)
	currentItems[idx] = nil
	if idx > slots then
		closeInventoryGaps(currentItems)
	end
	states.items(currentItems)
end

return {
	getMaxIndex = getMaxIndex,
	findLowestEmptyHotbarSlot = findLowestEmptyHotbarSlot,
	findLowestEmptyInventorySlot = findLowestEmptyInventorySlot,
	findLowestEmptySlot = findLowestEmptySlot,
	closeInventoryGaps = closeInventoryGaps,
	swap = swap,
	moveToHotbar = moveToHotbar,
	moveToInventory = moveToInventory,
	insertToLowestSlot = insertToLowestSlot,
	removeSlot = removeSlot,
}
