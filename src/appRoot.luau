local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local vide = require("../vide")
local app = require("./components/app")
local usePreferredInput = require("./hooks/usePreferredInput")
local mainController = require("./lib/mainController")
local settings = require("./settings")
local states = require("./states")
local types = require("./types")

local cleanup = vide.cleanup

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local targetScript = script.Parent

local function appRoot()
	return vide.mount(function()
		cleanup(GuiService.MenuOpened:Connect(function()
			states.enabled(false)
		end))
		cleanup(GuiService.MenuClosed:Connect(function()
			states.enabled(true)
		end))
		cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				local inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
					states.opened(false)
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

		local function refreshItems()
			local list: { types.InventoryItem } = {}
			local character = player.Character
			if character then
				for _, child in character:GetChildren() do
					if isItem(child) then
						table.insert(list, child :: types.InventoryItem)
						states.equippedItem(child)
					end
				end
			end
			local backpack = player:WaitForChild("Backpack")
			for _, child in backpack:GetChildren() do
				if isItem(child) then
					table.insert(list, child :: types.InventoryItem)
				end
			end
			states.items(list)
		end

		local function onChildAdded(child: Instance)
			if isItem(child) then
				refreshItems()
			end
		end

		local function onChildRemoved(child: Instance)
			if isItem(child) then
				if states.equippedItem() == child then
					states.equippedItem(nil)
				end
				refreshItems()
			end
		end

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
			refreshItems()
			connectCharacter(character)
		end))

		cleanup(disconnectCharacter)

		local preferredInput = usePreferredInput()

		local keyboardHint = vide.derive(function()
			return preferredInput() == Enum.PreferredInput.KeyboardAndMouse
		end)
		local gamepadHint = vide.derive(function()
			return preferredInput() == Enum.PreferredInput.Gamepad
		end)

		mainController.createCategory("All", function()
			return true
		end)

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

		return vide.show(states.enabled, function()
			return vide.create("ScreenGui")({
				Name = "InventoryPlus",
				DisplayOrder = 120,
				IgnoreGuiInset = true,
				ResetOnSpawn = false,

				app({
					slots = states.slots,
					rows = states.rows,
					opened = states.opened,
					equippedItem = states.equippedItem,
					items = states.items,
					keyboardHint = keyboardHint,
					gamepadHint = gamepadHint,
					categories = states.categories,
					selectedCategory = states.selectedCategory,
				}),
			})
		end)
	end)
end

return appRoot
