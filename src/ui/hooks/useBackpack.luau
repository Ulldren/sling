local Players = game:GetService("Players")

local events = require("../../core/events")
local slotManager = require("../../core/slotManager")
local states = require("../../core/states")
local useCharacter = require("./useCharacter")
local useEventListener = require("./useEventListener")
local vide = require("../../../vide")

local effect = vide.effect
local untrack = vide.untrack
local derive = vide.derive
local cleanup = vide.cleanup

local player = Players.LocalPlayer

local function useBackpack()
	local itemsIndex = derive(function()
		local items = states.items()
		local map = {}
		for i, item in items do
			map[item] = i
		end
		return map
	end)

	local backpack: Backpack = player:FindFirstChildOfClass("Backpack") :: any
	local character = useCharacter()

	local function onItemAdded(item: BackpackItem)
		local char = untrack(character)
		if item.Parent == char and untrack(states.equippedItem) ~= item then
			states.equippedItem(item)
		end

		if untrack(itemsIndex)[item] then
			return
		end
		slotManager.insertToLowestSlot(item)
		events.backpackItemAdded.fire(item)
	end

	local function onItemRemoved(item: BackpackItem)
		local parent = item.Parent
		local char = untrack(character)
		if parent ~= char and untrack(states.equippedItem) == item then
			states.equippedItem(nil)
		end

		if parent == backpack or parent == char then
			return
		end
		local index = untrack(itemsIndex)[item]
		if not index then
			return
		end
		slotManager.removeSlot(index)
		events.backpackItemRemoved.fire(item)

		if table.maxn(untrack(states.items)) == 0 then
			events.backpackEmpty.fire()
		end
	end

	local function onChildAdded(child: Instance)
		if child:IsA("BackpackItem") then
			onItemAdded(child)
		end
	end

	local function onChildRemoved(child: Instance)
		if child:IsA("BackpackItem") then
			onItemRemoved(child)
		end
	end

	local function observeItems(parent: Instance)
		for _, child in parent:GetChildren() do
			onChildAdded(child)
		end
		useEventListener(parent.ChildAdded, onChildAdded)
		useEventListener(parent.ChildRemoved, onChildRemoved)
	end

	effect(function()
		local char = character()
		if not char then
			return
		end

		-- update backpack reference
		backpack = player:FindFirstChildOfClass("Backpack") :: any

		observeItems(char)
		observeItems(backpack)

		states.isBackpackLoaded(true)
		events.backpackLoaded.fire(untrack(states.items))

		cleanup(function()
			states.equippedItem(nil)
			states.items({})
			states.isBackpackLoaded(false)
		end)
	end)

	effect(function()
		local equipped = states.equippedItem()
		local char = untrack(character)
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		if equipped then
			if equipped.Parent == char then
				return
			end

			if equipped:IsA("HopperBin") then -- NOTE: HopperBin
				warn(`[Sling] Cannot select '{equipped.Name}' hopper. HopperBin is deprecated and not supported.`)
				task.defer(function()
					states.equippedItem(nil)
				end)
			else
				humanoid:EquipTool(equipped :: Tool)
			end
		else
			humanoid:UnequipTools()
		end
	end)

	local lastEquipped: BackpackItem? = nil
	effect(function()
		local equipped = states.equippedItem()
		if equipped ~= lastEquipped then
			if lastEquipped then
				events.backpackItemUnequipped.fire(lastEquipped)
			end
			if equipped then
				events.backpackItemEquipped.fire(equipped)
			end
			lastEquipped = equipped
		end
	end)

	return {
		itemsIndex = itemsIndex,
	}
end

return useBackpack
