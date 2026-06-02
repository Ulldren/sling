local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local closeInventory = require("../../api/closeInventory")
local createCategory = require("../../api/createCategory")
local events = require("../../events")
local setEnabled = require("../../api/setEnabled")
local settings = require("../../settings")
local slotUtils = require("../../utils/slotUtils")
local states = require("../../states")
local useEventListener = require("../useEventListener")
local usePreferredInput = require("../usePreferredInput")
local vide = require("../../../vide")

local cleanup = vide.cleanup
local effect = vide.effect
local untrack = vide.untrack
local derive = vide.derive

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

local GAMEPAD_INPUT_TYPES = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
}

local function useBackpack()
	useEventListener(GuiService.MenuOpened, function()
		setEnabled(false)
	end)
	useEventListener(GuiService.MenuClosed, function()
		setEnabled(true)
	end)

	local function handleKeyboardControls(input: InputObject)
		-- Change slot selection
		local slotNum = KEY_TO_SLOT[input.KeyCode]
		local slots = untrack(states.slots)
		if slotNum and slotNum <= slots then
			local items = untrack(states.items)
			local item = items[slotNum]
			if item then
				local equipped = untrack(states.equippedItem)
				states.equippedItem(if item == equipped then nil else item)
			end
		end
	end

	local function handleGamepadControls(input: InputObject)
		-- Change slot selection
		if input.KeyCode == Enum.KeyCode.ButtonR1 or input.KeyCode == Enum.KeyCode.ButtonL1 then
			local moveDirection = if input.KeyCode == Enum.KeyCode.ButtonR1 then 1 else -1
			local slots = untrack(states.slots)
			local items = untrack(states.items)
			local equipped = untrack(states.equippedItem)

			local equippedIdx = nil
			if equipped then
				for idx = 1, slots do
					local item = items[idx]
					if item and item == equipped then
						equippedIdx = idx
						break
					end
				end
			end

			if equippedIdx then
				local newPos = equippedIdx
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
				local startIdx = if moveDirection == 1 then 1 else slots
				local endIdx = if moveDirection == 1 then slots else 1
				for idx = startIdx, endIdx, moveDirection do
					local item = items[idx]
					if item then
						states.equippedItem(item)
						break
					end
				end
			end
			-- Close inventory
		elseif input.KeyCode == settings.gamepadCloseKey or input.KeyCode == settings.gamepadCloseSecondaryKey then
			if states.opened() then
				closeInventory()
			end
		end
	end

	useEventListener(UserInputService.InputBegan, function(input, gameProcessedEvent)
		if not gameProcessedEvent then
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
				closeInventory()
			elseif inputType == Enum.UserInputType.Keyboard then
				handleKeyboardControls(input)
			elseif GAMEPAD_INPUT_TYPES[inputType] then
				handleGamepadControls(input)
			end
		end
	end)

	local function updateBackpackSize()
		local screenOrientation = playerGui.CurrentScreenOrientation
		local viewportSize = GuiService.ViewportDisplaySize

		if screenOrientation == Enum.ScreenOrientation.Portrait then
			states.slots(settings.hotbarSlotsPortrait)
			states.rows(settings.inventoryRowsPortrait)
		elseif viewportSize == Enum.DisplaySize.Small then
			states.slots(settings.hotbarSlotsMini)
			states.rows(settings.inventoryRowsMini)
		else
			states.slots(settings.hotbarSlotsFull)
			states.rows(settings.inventoryRowsFull)
		end
	end

	updateBackpackSize()
	useEventListener(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"), updateBackpackSize)
	useEventListener(playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"), updateBackpackSize)

	do
		--[[local function refreshItems()
		local currentItems = untrack(states.items)
		local activeItems = {}
		local equipped = nil

		-- Find all items in character and backpack
		local character = player.Character
		if character then
			for _, child in character:GetChildren() do
				if isBackpackItem(child) then
					activeItems[child] = true
					equipped = child
				end
			end
		end
		local backpack = player:FindFirstChildOfClass("Backpack")
		if backpack then
			for _, child in backpack:GetChildren() do
				if isBackpackItem(child) then
					activeItems[child] = true
				end
			end
		end

		local newCount = 0
		local newList = {}
		for i, entry in currentItems do
			local item = entry.item
			if item and activeItems[item] then
				newList[i] = entry
				activeItems[item] = nil
				newCount += 1
			else
				if item then
					for _, listener in events.backpackRemoved.callbacks do
						task.spawn(listener, item)
					end
				end
				newList[i] = { item = nil }
			end
		end

		for item in activeItems do
			local targetIdx = nil
			for idx = 1, #newList do
				if newList[idx].item == nil then
					targetIdx = idx
					break
				end
			end
			if not targetIdx then
				targetIdx = #newList + 1
			end
			newList[targetIdx] = { item = item }
			newCount += 1

			for _, listener in events.backpackAdded.callbacks do
				task.spawn(listener, item)
			end
		end

		local slots = untrack(states.slots)
		for i = 1, slots do
			if newList[i] == nil then
				newList[i] = { item = nil }
			end
		end

		local itemsChanged = false
		if #newList ~= #currentItems then
			itemsChanged = true
		else
			for i = 1, #newList do
				if newList[i] ~= currentItems[i] then
					itemsChanged = true
					break
				end
			end
		end

		if newCount == 0 and itemsChanged then
			for _, listener in events.backpackEmpty.callbacks do
				task.spawn(listener)
			end
		end

		states.equippedItem(equipped)
		if itemsChanged then
			states.items(newList)
		end
	end]]

		local itemsIndex = derive(function()
			local items = states.items()
			local map = {}
			for i, item in items do
				map[item] = i
			end
			return map
		end)

		local backpack: Backpack = nil
		local character: Model = nil

		local function isBackpackItem(instance: Instance): boolean
			return instance:IsA("Tool") or instance:IsA("HopperBin")
		end

		local function onItemAdded(item: BackpackItem)
			if item.Parent == character and untrack(states.equippedItem) ~= item then
				states.equippedItem(item)
			end

			if untrack(itemsIndex)[item] then
				return
			end
			slotUtils.insertToLowestSlot(item)

			for _, listener in events.backpackAdded.callbacks do
				task.spawn(listener, item)
			end
		end

		local function onItemRemoved(item: BackpackItem)
			local parent = item.Parent
			if parent ~= character and untrack(states.equippedItem) == item then
				states.equippedItem(nil)
			end

			if parent == backpack or parent == character then
				return
			end
			local index = untrack(itemsIndex)[item]
			if not index then
				return
			end
			slotUtils.removeSlot(index)

			for _, listener in events.backpackRemoved.callbacks do
				task.spawn(listener, item)
			end

			if slotUtils.getMaxIndex() == 0 then
				for _, listener in events.backpackEmpty.callbacks do
					task.spawn(listener)
				end
			end
		end

		local function onChildAdded(child: Instance)
			if not isBackpackItem(child) then
				return
			end
			onItemAdded(child :: BackpackItem)
		end

		local function onChildRemoved(child: Instance)
			if not isBackpackItem(child) then
				return
			end
			onItemRemoved(child :: BackpackItem)
		end

		effect(function()
			local tool = states.equippedItem()
			local character = player.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return
			end
			if tool then
				if tool.Parent == character then
					return
				end

				if tool:IsA("HopperBin") then -- NOTE: HopperBin
					warn(`Cannot select '{tool.Name}' hopper. HopperBin is deprecated and not supported.`)
					task.defer(function()
						states.equippedItem(nil)
					end)
					return
				end

				humanoid:EquipTool(tool)
			else
				humanoid:UnequipTools()
			end
		end)

		local lastEquipped: BackpackItem? = nil
		effect(function()
			local currentEquipped = states.equippedItem()
			if currentEquipped ~= lastEquipped then
				if lastEquipped then
					for _, listener in events.backpackUnequipped.callbacks do
						task.spawn(listener, lastEquipped)
					end
				end
				if currentEquipped then
					for _, listener in events.backpackEquipped.callbacks do
						task.spawn(listener, currentEquipped)
					end
				end
				lastEquipped = currentEquipped
			end
		end)

		local connections: { RBXScriptConnection } = {}

		local function disconnectCharacter()
			for _, conn in connections do
				conn:Disconnect()
			end
			table.clear(connections)
			states.equippedItem(nil)
			states.items({})
		end

		local function connectCharacter(char: Model)
			disconnectCharacter()

			character = char
			backpack = player:WaitForChild("Backpack")

			for _, child in character:GetChildren() do
				if isBackpackItem(child) then
					onItemAdded(child :: BackpackItem)
				end
			end
			table.insert(connections, character.ChildAdded:Connect(onChildAdded))
			table.insert(connections, character.ChildRemoved:Connect(onChildRemoved))

			for _, child in backpack:GetChildren() do
				onItemAdded(child :: BackpackItem)
			end
			table.insert(connections, backpack.ChildAdded:Connect(onChildAdded))
			table.insert(connections, backpack.ChildRemoved:Connect(onChildRemoved))
		end

		if player.Character then
			connectCharacter(player.Character)
		end

		useEventListener(player.CharacterAdded, connectCharacter)

		cleanup(disconnectCharacter)
	end

	local preferredInput = usePreferredInput()
	effect(function()
		states.keyboardHint(preferredInput() == Enum.PreferredInput.KeyboardAndMouse)
		states.gamepadHint(preferredInput() == Enum.PreferredInput.Gamepad)
	end)

	effect(function()
		local categories = states.categories()
		states.selectedCategory(if #categories > 0 then categories[1].category else "")
	end)

	createCategory("All", function()
		return true
	end)

	effect(function()
		print(states.items())
	end)
end

return useBackpack
