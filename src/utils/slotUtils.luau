local states = require("../states")
local vide = require("../../vide")

local untrack = vide.untrack

local function swap(idxA: number, idxB: number)
	if not idxA or not idxB then
		return
	end
	local slots = untrack(states.slots)
	local newItems = table.clone(untrack(states.items))

	local entryA = newItems[idxA] or { item = nil }
	local entryB = newItems[idxB] or { item = nil }

	newItems[idxA], newItems[idxB] = entryB, entryA

	if idxA <= slots and idxB <= slots then
		states.items(newItems)
		return
	end

	-- Shift items down in the inventory to close gaps
	local invIndex = slots + 1
	for i = invIndex, #newItems do
		local e = newItems[i]
		if e and e.item then
			if i > invIndex then
				newItems[i] = nil
				newItems[invIndex] = e
			end
			invIndex = invIndex + 1
		else
			newItems[i] = nil
		end
	end
	states.items(newItems)
end

local function moveToInventory(idx: number)
	if not idx then
		return
	end
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

local function moveToHotbar(idx: number)
	if not idx then
		return
	end
	local slots = untrack(states.slots)
	local currentItems = untrack(states.items)
	for i = 1, slots do
		local entry = currentItems[i]
		if not entry or entry.item == nil then
			swap(idx, i)
			return
		end
	end
end

return {
	swap = swap,
	moveToHotbar = moveToHotbar,
	moveToInventory = moveToInventory,
}
