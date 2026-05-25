local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local vide = require("../../vide")
local app = require("../components/app")
local events = require("../events")
local types = require("../types")
local attributesController = require("./attributesController")
local mainController = require("./mainController")

local KEYBOARD_INPUT_TYPES = {
	[Enum.UserInputType.Keyboard] = true,
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.MouseMovement] = true,
	[Enum.UserInputType.MouseWheel] = true,
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

local mount = vide.mount
local source = vide.source
local cleanup = vide.cleanup

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local function isItem(instance: Instance): boolean
	return instance:IsA("Tool") or instance:IsA("HopperBin")
end

local function backpackApp()
	local enabled = source(true)
	local opened = source(false)

	cleanup(events.backpackEnabled.on(function(value: boolean)
		enabled(value)
	end))
	cleanup(events.inventoryOpened.on(function()
		opened(true)
	end))
	cleanup(events.inventoryClosed.on(function()
		opened(false)
	end))
	cleanup(GuiService.MenuOpened:Connect(function()
		mainController.setEnabled(false)
	end))
	cleanup(GuiService.MenuClosed:Connect(function()
		mainController.setEnabled(true)
	end))
	cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent then
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
				mainController.closeInventory()
			end
		end
	end))

	local slots = source(10)
	local rows = source(4)

	local function updateBackpackSize()
		local screenOrientation = playerGui.CurrentScreenOrientation
		local viewportSize = GuiService.ViewportDisplaySize

		if screenOrientation == Enum.ScreenOrientation.Portrait then
			slots(3)
			rows(3)
		elseif viewportSize == Enum.DisplaySize.Small then
			slots(5)
			rows(2)
		else
			slots(10)
			rows(4)
		end
	end

	updateBackpackSize()
	cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(updateBackpackSize))
	cleanup(playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(updateBackpackSize))

	local items = source({} :: { types.InventoryItem })
	local equippedItem = source(nil :: types.InventoryItem?)

	local function refreshItems()
		local list: { types.InventoryItem } = {}
		local character = player.Character
		if character then
			for _, child in character:GetChildren() do
				if isItem(child) then
					table.insert(list, child :: types.InventoryItem)
					equippedItem(child)
				end
			end
		end
		local backpack = player:WaitForChild("Backpack")
		for _, child in backpack:GetChildren() do
			if isItem(child) then
				table.insert(list, child :: types.InventoryItem)
			end
		end
		items(list)
	end

	local function onChildAdded(child: Instance)
		if isItem(child) then
			refreshItems()
		end
	end

	local function onChildRemoved(child: Instance)
		if isItem(child) then
			if equippedItem() == child then
				equippedItem(nil)
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
				equippedItem(child :: types.InventoryItem)
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
		equippedItem(nil)
		refreshItems()
		connectCharacter(character)
	end))

	cleanup(disconnectCharacter)

	local keyboardHint = source(false)
	local gamepadHint = source(false)

	local function updateInputHints()
		local inputType = UserInputService:GetLastInputType()
		keyboardHint(KEYBOARD_INPUT_TYPES[inputType] or false)
		gamepadHint(GAMEPAD_INPUT_TYPES[inputType] or false)
	end

	updateInputHints()
	cleanup(UserInputService.LastInputTypeChanged:Connect(updateInputHints))

	local preferredTransparency = source(GuiService.PreferredTransparency)

	cleanup(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		preferredTransparency(GuiService.PreferredTransparency)
	end))

	local attributes = attributesController.generateAttributes(preferredTransparency)

	local categories = source({} :: { types.Category })
	local selectedCategory = source("")

	events.categoryAdded.on(function(category)
		local current = categories()
		table.insert(current, category)
		categories(current)
	end)

	mainController.createCategory("All", function()
		return true
	end)

	return vide.create("ScreenGui")({
		Name = "BackpackGui",
		DisplayOrder = 120,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Enabled = enabled,

		app({
			slots = slots,
			rows = rows,
			opened = opened,
			equippedItem = equippedItem,
			items = items,
			keyboardHint = keyboardHint,
			gamepadHint = gamepadHint,
			categories = categories,
			selectedCategory = selectedCategory,
			attributes = attributes,
		}),
	})
end

local appController = {}

function appController:mount()
	return mount(backpackApp, playerGui)
end

return appController
