local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local closeInventory = require("../../api/closeInventory")
local config = require("../../constants/config")
local createCategory = require("../../api/createCategory")
local events = require("../../events")
local setEnabled = require("../../api/setEnabled")
local slotUtils = require("../../utils/slotUtils")
local states = require("../../states")
local useCharacter = require("../useCharacter")
local useEventListener = require("../useEventListener")
local usePreferredInput = require("../usePreferredInput")
local vide = require("../../../vide")

local effect = vide.effect
local untrack = vide.untrack
local derive = vide.derive
local cleanup = vide.cleanup

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local KEY_TO_SLOT = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9,
	[Enum.KeyCode.Zero] = 10,
}

local function useBackpack()
	useEventListener(GuiService.MenuOpened, function()
		setEnabled(false)
	end)
	useEventListener(GuiService.MenuClosed, function()
		setEnabled(true)
	end)

	local function updateBackpackSize()
		local screenOrientation = playerGui.CurrentScreenOrientation
		local viewportSize = GuiService.ViewportDisplaySize

		if screenOrientation == Enum.ScreenOrientation.Portrait then
			states.slots(config.hotbarSlotsPortrait)
			states.rows(config.inventoryRowsPortrait)
		elseif viewportSize == Enum.DisplaySize.Small then
			states.slots(config.hotbarSlotsMini)
			states.rows(config.inventoryRowsMini)
		else
			states.slots(config.hotbarSlotsFull)
			states.rows(config.inventoryRowsFull)
		end
	end

	updateBackpackSize()
	useEventListener(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"), updateBackpackSize)
	useEventListener(playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"), updateBackpackSize)

	local preferredInput = usePreferredInput()
	effect(function()
		states.keyboardHint(preferredInput() == Enum.PreferredInput.KeyboardAndMouse)
		states.gamepadHint(preferredInput() == Enum.PreferredInput.Gamepad)
	end)

	local lastOpened = states.opened()
	effect(function()
		local opened = states.opened()
		if opened ~= lastOpened then
			lastOpened = opened

			if opened then
				events.inventoryOpened.fire()
			else
				states.gamepadSwapIndex(nil)
				events.inventoryClosed.fire()
			end
		end
	end)

	local itemsIndex = derive(function()
		local items = states.items()
		local map = {}
		for i, item in items do
			map[item] = i
		end
		return map
	end)

	local lastChangeToolInput: InputObject? = nil
	local lastChangeToolTime: number? = nil
	local maxEquipDeltaTime = 0.06

	local function hotbarEquip(_actionName: string, state: Enum.UserInputState, input: InputObject)
		if state ~= Enum.UserInputState.Begin then
			return
		end
		if lastChangeToolInput and lastChangeToolTime then
			if
				(lastChangeToolInput.KeyCode == Enum.KeyCode.ButtonR1 and input.KeyCode == Enum.KeyCode.ButtonL1)
				or (lastChangeToolInput.KeyCode == Enum.KeyCode.ButtonL1 and input.KeyCode == Enum.KeyCode.ButtonR1)
			then
				if (tick() - lastChangeToolTime) <= maxEquipDeltaTime then
					states.equippedItem(nil)
					lastChangeToolInput = input
					lastChangeToolTime = tick()
					return
				end
			end
		end

		lastChangeToolInput = input
		lastChangeToolTime = tick()

		task.delay(maxEquipDeltaTime, function()
			if lastChangeToolInput ~= input then
				return
			end

			local moveDirection = if input.KeyCode == Enum.KeyCode.ButtonR1 then 1 else -1
			local slots = untrack(states.slots)
			local items = untrack(states.items)
			local equipped = untrack(states.equippedItem)

			local equippedIndex: number? = nil
			if equipped then
				equippedIndex = untrack(itemsIndex)[equipped]
				if equippedIndex > slots then
					equippedIndex = nil
				end
			end

			if equippedIndex then
				local newPos = equippedIndex
				local hitEdge = false
				for _ = 1, slots do
					newPos += moveDirection
					if newPos > slots then
						newPos = 1
						hitEdge = true
					elseif newPos < 1 then
						newPos = slots
						hitEdge = true
					end
					if items[newPos] then
						break
					end
				end
				states.equippedItem(if hitEdge then nil else items[newPos])
			else
				local startIndex = if moveDirection == 1 then 1 else slots
				local endIndex = if moveDirection == 1 then slots else 1
				for index = startIndex, endIndex, moveDirection do
					local item = items[index]
					if item then
						states.equippedItem(item)
						break
					end
				end
			end
		end)
	end

	local function hotbarRemove(_actionName: string, state: Enum.UserInputState, input: InputObject)
		if state ~= Enum.UserInputState.Begin then
			return
		end
		events.gamepadRemove.fire()
	end

	effect(function()
		if preferredInput() == Enum.PreferredInput.Gamepad then
			ContextActionService:BindAction(
				"BackpackHotbarEquip",
				hotbarEquip,
				false,
				Enum.KeyCode.ButtonL1,
				Enum.KeyCode.ButtonR1
			)

			cleanup(function()
				ContextActionService:UnbindAction("BackpackHotbarEquip")
			end)

			if states.opened() then
				ContextActionService:BindAction(
					"BackpackCloseInventory",
					closeInventory,
					false,
					config.gamepadCloseKey,
					config.gamepadCloseSecondaryKey
				)

				ContextActionService:BindAction("BackpackHotbarRemove", hotbarRemove, false, config.gamepadRemoveKey)

				cleanup(function()
					ContextActionService:UnbindAction("BackpackCloseInventory")
					ContextActionService:UnbindAction("BackpackHotbarRemove")
				end)
			end
		end
	end)

	useEventListener(UserInputService.InputBegan, function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
			return
		end
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
			closeInventory()
		elseif inputType == Enum.UserInputType.Keyboard then
			local slotNum = KEY_TO_SLOT[input.KeyCode]
			if slotNum then
				local slots = untrack(states.slots)
				if slotNum <= slots then
					local items = untrack(states.items)
					local item = items[slotNum]
					if item then
						local equipped = untrack(states.equippedItem)
						states.equippedItem(if item == equipped then nil else item)
					end
				end
			end
		end
	end)

	local backpack: Backpack = player:WaitForChild("Backpack")
	local character = useCharacter()

	local function onItemAdded(item: BackpackItem)
		local char = untrack(character)
		if item.Parent == char and untrack(states.equippedItem) ~= item then
			states.equippedItem(item)
		end

		if untrack(itemsIndex)[item] then
			return
		end
		slotUtils.insertToLowestSlot(item)

		events.backpackAdded.fire(item)
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
		slotUtils.removeSlot(index)

		events.backpackRemoved.fire(item)

		if slotUtils.getMaxIndex() == 0 then
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

		states.equippedItem(nil)
		states.items({})

		-- update backpack reference
		backpack = player:FindFirstChildOfClass("Backpack")

		observeItems(char)
		observeItems(backpack)
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
				warn(`Cannot select '{equipped.Name}' hopper. HopperBin is deprecated and not supported.`)
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
				events.backpackUnequipped.fire(lastEquipped)
			end
			if equipped then
				events.backpackEquipped.fire(equipped)
			end
			lastEquipped = equipped
		end
	end)

	effect(function()
		local categories = states.categories()
		states.selectedCategory(if #categories > 0 then categories[1].category else "")
	end)

	createCategory("All", function()
		return true
	end)
end

return useBackpack
