const states = require("../states")
const vide = require("../../vide")

const untrack = vide.untrack

const function swap(idxA: number, idxB: number)
	if not idxA or not idxB then
		return
	end
	const slots = untrack(states.slots)
	const newItems = table.clone(untrack(states.items))

	const entryA = newItems[idxA] or { item = nil }
	const entryB = newItems[idxB] or { item = nil }

	newItems[idxA], newItems[idxB] = entryB, entryA

	if idxA <= slots and idxB <= slots then
		states.items(newItems)
		return
	end

	-- Shift items down in the inventory to close gaps
	local invIndex = slots + 1
	for i = invIndex, #newItems do
		const e = newItems[i]
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

const function moveToInventory(idx: number)
	if not idx then
		return
	end
	const slots = untrack(states.slots)
	if idx > slots then
		return
	end
	const items = untrack(states.items)
	const itemToMove = items[idx]
	if not itemToMove or itemToMove.item == nil then
		return
	end
	swap(idx, #items + 1)
end

const function moveToHotbar(idx: number)
	if not idx then
		return
	end
	const slots = untrack(states.slots)
	const currentItems = untrack(states.items)
	for i = 1, slots do
		const entry = currentItems[i]
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
