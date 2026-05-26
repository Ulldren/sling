local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local UserInputService = game:GetService("UserInputService")

local app = require("./components/app")
local closeInventory = require("./api/closeInventory")
local createCategory = require("./api/createCategory")
local px = require("./utils/px")
local setEnabled = require("./api/setEnabled")
local settings = require("./settings")
local states = require("./states")
local types = require("./types")
local usePreferredInput = require("./hooks/usePreferredInput")
local vide = require("../vide")

local cleanup = vide.cleanup

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local targetScript = script.Parent

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

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

local function appRoot()
	return vide.mount(function()
		px.usePx()

		cleanup(GuiService.MenuOpened:Connect(function()
			setEnabled(false)
		end))
		cleanup(GuiService.MenuClosed:Connect(function()
			setEnabled(true)
		end))

		cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				local inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
					closeInventory()
				elseif inputType == Enum.UserInputType.Keyboard then
					local slotNum = KEY_TO_SLOT[input.KeyCode]
					if slotNum and slotNum <= states.slots() then
						local items = states.items()
						local item = items[slotNum]
						if item then
							states.equippedItem(if item == states.equippedItem() then nil else item)
						end
					end
				elseif GAMEPAD_INPUT_TYPES[inputType] then
					if input.KeyCode == Enum.KeyCode.ButtonR1 or input.KeyCode == Enum.KeyCode.ButtonL1 then
						local moveDirection = if input.KeyCode == Enum.KeyCode.ButtonR1 then 1 else -1
						local slots = states.slots()
						local items = states.items()
						local equipped = states.equippedItem()

						local equippedIdx = nil
						if equipped then
							for idx = 1, slots do
								if items[idx] == equipped then
									equippedIdx = idx
									break
								end
							end
						end

						if equippedIdx then
							local newPos = equippedIdx + moveDirection
							local hitEdge = false
							if newPos > slots then
								newPos = 1
								hitEdge = true
							elseif newPos < 1 then
								newPos = slots
								hitEdge = true
							end

							local origNewPos = newPos
							while items[newPos] == nil do
								newPos = newPos + moveDirection
								if newPos > slots then
									newPos = 1
									hitEdge = true
								elseif newPos < 1 then
									newPos = slots
									hitEdge = true
								end

								if newPos == origNewPos then
									return
								end
							end

							if hitEdge then
								states.equippedItem(nil)
							else
								states.equippedItem(items[newPos])
							end
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
					elseif
						input.KeyCode == settings.gamepadCloseKey
						or input.KeyCode == settings.gamepadCloseSecondaryKey
					then
						if states.opened() then
							closeInventory()
						end
					end
				end
			end
		end))

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
		cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(updateBackpackSize))
		cleanup(playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(updateBackpackSize))

		local function isItem(instance: Instance): boolean
			return instance:IsA("Tool") or instance:IsA("HopperBin")
		end

		local savedLayout = {}
		local lastRespawnTime = 0

		local function refreshItems()
			local current = states.items()
			local active = {}
			local equipped = nil

			local character = player.Character
			if character then
				for _, child in character:GetChildren() do
					if isItem(child) then
						active[child] = true
						equipped = child :: types.InventoryItem
					end
				end
			end
			local backpack = player:FindFirstChildOfClass("Backpack")
			if backpack then
				for _, child in backpack:GetChildren() do
					if isItem(child) then
						active[child] = true
					end
				end
			end

			local newList = {}
			for i, item in current do
				if active[item] then
					newList[i] = item
					active[item] = nil
				end
			end

			for item in active do
				local targetIdx = nil
				local isStarterTool = false
				local starterGear = player:FindFirstChild("StarterGear")
				if (starterGear and starterGear:FindFirstChild(item.Name)) or StarterPack:FindFirstChild(item.Name) then
					isStarterTool = true
				end

				if isStarterTool and os.clock() - lastRespawnTime < 3.0 and savedLayout[item.Name] then
					local indices = savedLayout[item.Name]
					for k, savedIdx in indices do
						if newList[savedIdx] == nil then
							targetIdx = savedIdx
							table.remove(indices, k)
							break
						end
					end
				end

				if not targetIdx then
					targetIdx = 1
					while newList[targetIdx] ~= nil do
						targetIdx = targetIdx + 1
					end
				end
				newList[targetIdx] = item
			end

			states.equippedItem(equipped)
			states.items(newList)
		end

		local function onChildAdded(child: Instance)
			if isItem(child) then
				refreshItems()
			end
		end

		local function onChildRemoved(child: Instance)
			if isItem(child) then
				refreshItems()
			end
		end

		vide.effect(function()
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

				if tool:IsA("HopperBin") then
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

		local characterConnections: { RBXScriptConnection } = {}

		local function disconnectCharacter()
			for _, conn in characterConnections do
				conn:Disconnect()
			end
			table.clear(characterConnections)
		end

		local function connectCharacter(character: Model)
			for _, child in character:GetChildren() do
				if isItem(child) then
					states.equippedItem(child :: types.InventoryItem)
					break
				end
			end

			table.insert(characterConnections, character.ChildAdded:Connect(onChildAdded))
			table.insert(characterConnections, character.ChildRemoved:Connect(onChildRemoved))

			local backpack = player:WaitForChild("Backpack")
			table.insert(characterConnections, backpack.ChildAdded:Connect(onChildAdded))
			table.insert(characterConnections, backpack.ChildRemoved:Connect(onChildRemoved))
		end

		if player.Character then
			connectCharacter(player.Character)
		end

		cleanup(player.CharacterAdded:Connect(function(character)
			disconnectCharacter()
			states.equippedItem(nil)

			table.clear(savedLayout)
			for index, item in states.items() do
				if item then
					local name = item.Name
					if not savedLayout[name] then
						savedLayout[name] = {}
					end
					table.insert(savedLayout[name], index)
				end
			end
			lastRespawnTime = os.clock()

			refreshItems()
			connectCharacter(character)
		end))

		cleanup(disconnectCharacter)

		local attributeConnections: { RBXScriptConnection } = {}
		for attributeName, source in states.attributes :: { [string]: vide.Source<any> } do
			if targetScript:GetAttribute(attributeName) then
				source(targetScript:GetAttribute(attributeName))
			end
			table.insert(
				attributeConnections,
				targetScript:GetAttributeChangedSignal(attributeName):Connect(function()
					source(targetScript:GetAttribute(attributeName))
				end)
			)
		end
		cleanup(function()
			for _, conn in attributeConnections do
				conn:Disconnect()
			end
			table.clear(attributeConnections)
		end)

		createCategory("All", function()
			return true
		end)

		local preferredInput = usePreferredInput()
		vide.effect(function()
			states.keyboardHint(preferredInput() == Enum.PreferredInput.KeyboardAndMouse)
			states.gamepadHint(preferredInput() == Enum.PreferredInput.Gamepad)
		end)

		return vide.show(states.enabled, function()
			return vide.create("ScreenGui")({
				Name = "BackpackGui",
				DisplayOrder = 120,
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Global,

				app(),
			})
		end)
	end, playerGui)
end

return appRoot()
