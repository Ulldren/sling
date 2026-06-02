local states = require("../states")
local vide = require("../../vide")

local untrack = vide.untrack

local function findLowestEmptyHotbarSlot(): number?
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)
	for i = 1, slots do
		local entry = currentItems[i]
		if not entry or entry.item == nil then
			return i
		end
	end
	return nil
end

local function findLowestEmptyInventorySlot(): number
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)
	for i = slots + 1, #currentItems do
		local entry = currentItems[i]
		if not entry or entry.item == nil then
			return i
		end
	end
	return #currentItems + 1
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
	for i = invIndex, #items do
		local e = items[i]
		if e and e.item then
			if i > invIndex then
				items[i] = nil
				items[invIndex] = e
			end
			invIndex = invIndex + 1
		else
			items[i] = nil
		end
	end
end

local function swap(idxA: number, idxB: number)
	if not idxA or not idxB then
		return
	end
	local slots = untrack(states.slots)
	local newItems = untrack(states.items)

	local entryA = newItems[idxA] or { item = nil }
	local entryB = newItems[idxB] or { item = nil }

	newItems[idxA], newItems[idxB] = entryB, entryA

	if idxA <= slots and idxB <= slots then
		states.items(newItems)
		return
	end

	closeInventoryGaps(newItems)
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
	local itemToMove = items[idx]
	if not itemToMove or itemToMove.item == nil then
		return
	end
	swap(idx, #items + 1)
end

return {
	findLowestEmptyHotbarSlot = findLowestEmptyHotbarSlot,
	findLowestEmptyInventorySlot = findLowestEmptyInventorySlot,
	findLowestEmptySlot = findLowestEmptySlot,
	closeInventoryGaps = closeInventoryGaps,
	swap = swap,
	moveToHotbar = moveToHotbar,
	moveToInventory = moveToInventory,
}
