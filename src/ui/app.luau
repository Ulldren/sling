local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local backpack = require("./components/backpack")
local closeInventory = require("../api/closeInventory")
local config = require("../core/config")
local events = require("../core/events")
local inputs = require("./components/inputs")
local px = require("../core/utils/px")
local states = require("../core/states")
local useBackpack = require("./hooks/useBackpack")
local useEventListener = require("./hooks/useEventListener")
local vide = require("../../vide")

local mount = vide.mount
local create = vide.create
local action = vide.action
local show = vide.show
local effect = vide.effect
local untrack = vide.untrack

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local function sling()
	local b = useBackpack()
	local itemsIndex = b.itemsIndex

	useEventListener(GuiService.MenuOpened, closeInventory)

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

	states.preferredInput(UserInputService.PreferredInput)
	useEventListener(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		states.preferredInput(UserInputService.PreferredInput)
	end)

	states.preferredTransparency(GuiService.PreferredTransparency)
	useEventListener(GuiService:GetPropertyChangedSignal("PreferredTransparency"), function()
		states.preferredTransparency(GuiService.PreferredTransparency)
	end)

	states.vrEnabled(VRService.VREnabled)
	useEventListener(VRService:GetPropertyChangedSignal("VREnabled"), function()
		states.vrEnabled(VRService.VREnabled)
	end)

	effect(function()
		local vr = states.vrEnabled()
		local prefInput = states.preferredInput()
		states.keyboardHint(not vr and prefInput == Enum.PreferredInput.KeyboardAndMouse)
		states.gamepadHint(not vr and prefInput == Enum.PreferredInput.Gamepad)
	end)

	local lastPressedLeft = false
	local lastPressedRight = false
	effect(function()
		local pressedSlotLeft = states.inputs.slotLeft()
		local pressedSlotRight = states.inputs.slotRight()

		local becamePressedLeft = pressedSlotLeft and not lastPressedLeft
		local becamePressedRight = pressedSlotRight and not lastPressedRight

		lastPressedLeft = pressedSlotLeft
		lastPressedRight = pressedSlotRight

		if pressedSlotLeft and pressedSlotRight then
			states.equippedItem(nil)
			return
		end

		if not becamePressedLeft and not becamePressedRight then
			return
		end

		local moveDirection = if becamePressedRight then 1 else -1
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

		local startIndex = if equippedIndex then equippedIndex + moveDirection else (moveDirection == 1 and 1 or slots)
		local endIndex = moveDirection == 1 and slots or 1

		for index = startIndex, endIndex, moveDirection do
			local item = items[index]
			if item then
				states.equippedItem(item)
				return
			end
		end

		states.equippedItem(nil)
	end)

	effect(function()
		local pressedCloseInventory = states.inputs.closeInventory()
		if pressedCloseInventory then
			closeInventory()
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
			local inputNum = tonumber(UserInputService:GetStringForKeyCode(input.KeyCode))
			if inputNum and inputNum <= states.slots() then
				local item = states.items()[inputNum == 0 and 10 or inputNum]
				if item then
					states.equippedItem(if item == states.equippedItem() then nil else item)
				end
			end
		end
	end)

	px.usePx()

	return create("ScreenGui")({
		Name = "BackpackGui",
		DisplayOrder = 120,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,

		action(states.appRef :: any),

		backpack(),
	})
end

local function app()
	mount(function()
		return show(states.enabled, sling)
	end, playerGui)
	mount(inputs, script.Parent.Parent)
end

return app
