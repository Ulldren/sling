const GuiService = game:GetService("GuiService")
const Players = game:GetService("Players")
const StarterGui = game:GetService("StarterGui")
const UserInputService = game:GetService("UserInputService")

const vide = require("../../vide")
const app = require("./app")
const closeInventory = require("../api/closeInventory")
const createCategory = require("../api/createCategory")
const events = require("../events")
const px = require("../utils/px")
const setEnabled = require("../api/setEnabled")
const settings = require("../settings")
const states = require("../states")
const types = require("../types")
const usePreferredInput = require("../hooks/usePreferredInput")

const mount = vide.mount
const cleanup = vide.cleanup
const create = vide.create
const effect = vide.effect
const untrack = vide.untrack

const player = Players.LocalPlayer
const playerGui = player:WaitForChild("PlayerGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

const KEY_TO_SLOT = {
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

const GAMEPAD_INPUT_TYPES = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
}

const function render()
	return mount(function()
		cleanup(GuiService.MenuOpened:Connect(function()
			setEnabled(false)
		end))
		cleanup(GuiService.MenuClosed:Connect(function()
			setEnabled(true)
		end))

		const function handleKeyboardControls(input: InputObject)
			-- Change slot selection
			const slotNum = KEY_TO_SLOT[input.KeyCode]
			if slotNum and slotNum <= states.slots() then
				const entry = untrack(states.items)[slotNum]
				if entry and entry.item then
					states.equippedItem(if entry.item == untrack(states.equippedItem) then nil else entry.item)
				end
			end
		end

		const function handleGamepadControls(input: InputObject)
			-- Change slot selection
			if input.KeyCode == Enum.KeyCode.ButtonR1 or input.KeyCode == Enum.KeyCode.ButtonL1 then
				const moveDirection = if input.KeyCode == Enum.KeyCode.ButtonR1 then 1 else -1
				const slots = untrack(states.slots)
				const items = untrack(states.items)
				const equipped = untrack(states.equippedItem)

				local equippedIdx = nil
				if equipped then
					for idx = 1, slots do
						const entry = items[idx]
						if entry and entry.item == equipped then
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
						if items[newPos] and items[newPos].item then
							break
						end
					end
					states.equippedItem(if hitEdge then nil else items[newPos].item)
				else
					const startIdx = if moveDirection == 1 then 1 else slots
					const endIdx = if moveDirection == 1 then slots else 1
					for idx = startIdx, endIdx, moveDirection do
						const entry = items[idx]
						if entry and entry.item then
							states.equippedItem(entry.item)
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

		cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				const inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
					closeInventory()
				elseif inputType == Enum.UserInputType.Keyboard then
					handleKeyboardControls(input)
				elseif GAMEPAD_INPUT_TYPES[inputType] then
					handleGamepadControls(input)
				end
			end
		end))

		const function updateBackpackSize()
			const screenOrientation = playerGui.CurrentScreenOrientation
			const viewportSize = GuiService.ViewportDisplaySize

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
		cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(updateBackpackSize))
		cleanup(playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(updateBackpackSize))

		const function isItem(instance: Instance): boolean
			return instance:IsA("Tool") or instance:IsA("HopperBin")
		end

		const function refreshItems()
			const currentItems = untrack(states.items)
			const activeItems = {}
			local equipped = nil

			-- Find all items in character and backpack
			const character = player.Character
			if character then
				for _, child in character:GetChildren() do
					if isItem(child) then
						activeItems[child] = true
						equipped = child
					end
				end
			end
			const backpack = player:FindFirstChildOfClass("Backpack")
			if backpack then
				for _, child in backpack:GetChildren() do
					if isItem(child) then
						activeItems[child] = true
					end
				end
			end

			local newCount = 0
			const newList = {}
			for i, entry in currentItems do
				const item = entry.item
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

			const slots = untrack(states.slots)
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
		end

		const function onChildAdded(child: Instance)
			if isItem(child) then
				refreshItems()
			end
		end

		const function onChildRemoved(child: Instance)
			if isItem(child) then
				refreshItems()
			end
		end

		effect(function()
			const tool = states.equippedItem()
			const character = player.Character
			if not character then
				return
			end
			const humanoid = character:FindFirstChildOfClass("Humanoid")
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

		local lastEquipped: types.InventoryItem? = nil
		effect(function()
			const currentEquipped = states.equippedItem()
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

		const characterConnections: { RBXScriptConnection } = {}

		const function disconnectCharacter()
			for _, conn in characterConnections do
				conn:Disconnect()
			end
			table.clear(characterConnections)
		end

		const function connectCharacter(character: Model)
			for _, child in character:GetChildren() do
				if isItem(child) then
					states.equippedItem(child :: types.InventoryItem)
					break
				end
			end

			table.insert(characterConnections, character.ChildAdded:Connect(onChildAdded))
			table.insert(characterConnections, character.ChildRemoved:Connect(onChildRemoved))

			const backpack = player:WaitForChild("Backpack")
			table.insert(characterConnections, backpack.ChildAdded:Connect(onChildAdded))
			table.insert(characterConnections, backpack.ChildRemoved:Connect(onChildRemoved))
		end

		if player.Character then
			connectCharacter(player.Character)
		end

		cleanup(player.CharacterAdded:Connect(function(character)
			disconnectCharacter()
			states.equippedItem(nil)
			refreshItems()
			connectCharacter(character)
		end))

		cleanup(disconnectCharacter)

		const preferredInput = usePreferredInput()
		effect(function()
			states.keyboardHint(preferredInput() == Enum.PreferredInput.KeyboardAndMouse)
			states.gamepadHint(preferredInput() == Enum.PreferredInput.Gamepad)
		end)

		createCategory("All", function()
			return true
		end)

		px.usePx()

		return create("ScreenGui")({
			Name = "BackpackGui",
			DisplayOrder = 120,
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			Enabled = states.enabled,

			app(),
		})
	end, playerGui)
end

return render
