local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local cond = require("../../utils/cond")
local px = require("../../utils/px")
local settings = require("../../settings")
local slotUtils = require("../../utils/slotUtils")
local states = require("../../states")
local useEventListener = require("../useEventListener")
local usePreferredInput = require("../usePreferredInput")
local vide = require("../../../vide")

local effect = vide.effect
local untrack = vide.untrack
local source = vide.source
local derive = vide.derive

local function checkBounds(pos: Vector2, target: GuiObject): boolean
	local absPos = target.AbsolutePosition
	local absSize = target.AbsoluteSize
	return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

local function getClosestFrame(pos: Vector2, parent: Instance, maxDistance: number?): (GuiObject?, number?)
	local closestFrame: GuiObject? = nil
	local minDistance: number = maxDistance or math.huge

	for _, frame in parent:GetChildren() do
		if not frame:IsA("GuiObject") then
			continue
		end

		local center = frame.AbsolutePosition + frame.AbsoluteSize / 2
		local distance = (pos - center).Magnitude

		if distance < minDistance then
			minDistance = distance
			closestFrame = frame
		end
	end

	if closestFrame then
		return closestFrame, minDistance
	else
		return nil, nil
	end
end

local function useSlot(props: {
	item: vide.Source<BackpackItem?>,
	order: number,
	inHotbar: boolean?,
})
	local item = props.item

	local isHovering = source(false)
	local isDragging = source(false)

	local slotRef = source(nil :: TextButton?)
	local slotFrameRef = source(nil :: Frame?)

	local slotSize = px.offset(settings.slotSize, settings.slotSize)
	local preferredInput = usePreferredInput()
	local zindex = derive(cond.ifelse(isDragging, 2, 1))

	local itemName = source("")
	local itemImage = source("")
	local tooltipText = source("")

	local getSourceIdx = derive(function()
		local currentItem = item()
		if currentItem then
			for i, v in untrack(states.items) do
				if v == currentItem then
					return i
				end
			end
		end
		return if props.inHotbar then props.order else states.slots() + props.order
	end)

	local function getSlotNumber(): string
		if props.order >= 1 and props.order < 10 then
			return tostring(props.order)
		elseif props.order == 10 then
			return "0"
		end
		return ""
	end

	local function swap(targetIdx: number)
		local sourceIdx = untrack(getSourceIdx)
		local items = untrack(states.items)
		if not items[sourceIdx] then
			return
		end
		slotUtils.swap(sourceIdx, targetIdx)
	end

	local lastClickTime = 0
	local function onClick()
		local sourceIdx = untrack(getSourceIdx)
		if preferredInput() == Enum.PreferredInput.Gamepad and untrack(states.opened) then
			local activeSwapIdx = untrack(states.gamepadSwapIdx)
			if activeSwapIdx then
				states.gamepadSwapIdx(nil)
				if activeSwapIdx ~= sourceIdx then
					slotUtils.swap(sourceIdx, activeSwapIdx)
				end
				return
			else
				states.gamepadSwapIdx(sourceIdx)
				return
			end
		end

		local i = untrack(item)
		if not i then
			return
		end
		local now = os.clock()
		if now - lastClickTime < settings.doubleClickTime then
			lastClickTime = 0

			if not props.inHotbar then
				slotUtils.moveToHotbar(untrack(getSourceIdx))
			end
		else
			lastClickTime = now
			states.equippedItem(if i == untrack(states.equippedItem) then nil else i)
		end
	end

	local function onMouseEnter()
		isHovering(true)
	end

	local function onMouseLeave()
		isHovering(false)
	end

	local function onDragBegin()
		isDragging(true)

		local slot = slotRef()
		local app = states.appRef()
		if not slot or not app then
			return
		end
		if not props.inHotbar then
			local newPosition = UDim2.new(
				0,
				slot.AbsolutePosition.X - app.AbsolutePosition.X,
				0,
				slot.AbsolutePosition.Y - app.AbsolutePosition.Y
			)
			slot.Parent = app
			slot.Position = newPosition
		end
	end

	local function onDragStopped(x: number, y: number)
		isDragging(false)

		local slot = slotRef()
		local slotFrame = slotFrameRef()
		if not slot or not slotFrame then
			return
		end

		if not props.inHotbar then
			slot.Parent = slotFrame
		end
		slot.Position = UDim2.new()

		local abpos = Vector2.new(x, y)
		local hotbar = states.hotbarRef()

		local insideHotbar = false

		if hotbar then
			insideHotbar = checkBounds(abpos, hotbar)
			if insideHotbar then
				local closest = getClosestFrame(abpos, hotbar, settings.slotSize / 2)
				if closest and closest ~= slotFrame then
					local targetOrder = closest.LayoutOrder
					swap(targetOrder)
					return
				end
			end
		end

		if props.inHotbar and not insideHotbar then
			local sourceIdx = untrack(getSourceIdx)
			slotUtils.moveToInventory(sourceIdx)
		end
	end

	effect(function()
		local i = item()
		if not i then
			itemName("")
			itemImage("")
			tooltipText("")
			return
		end

		itemName(i.Name)
		useEventListener(i:GetPropertyChangedSignal("Name"), function()
			itemName(i.Name)
		end)

		if i:IsA("Tool") then
			local tool = i :: Tool
			itemImage(tool.TextureId)
			tooltipText(tool.ToolTip)
			useEventListener(tool:GetPropertyChangedSignal("TextureId"), function()
				itemImage(tool.TextureId)
			end)
			useEventListener(tool:GetPropertyChangedSignal("ToolTip"), function()
				tooltipText(tool.ToolTip)
			end)
		else
			itemImage("")
			tooltipText("")
		end
	end)

	useEventListener(UserInputService.InputBegan, function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end
		if not untrack(states.opened) then
			return
		end
		if not props.inHotbar then
			return
		end

		if input.KeyCode == settings.gamepadRemoveKey then
			local slotBtn = slotRef()
			if slotBtn and GuiService.SelectedObject == slotBtn then
				local sourceIdx = untrack(getSourceIdx)
				slotUtils.moveToInventory(sourceIdx)
			end
		end
	end)

	return {
		slotSize = slotSize,
		zindex = zindex,

		item = item,
		itemName = itemName,
		itemImage = itemImage,
		tooltipText = tooltipText,

		slotRef = slotRef,
		slotFrameRef = slotFrameRef,

		isHovering = isHovering,
		isDragging = isDragging,

		getSourceIdx = getSourceIdx,

		getSlotNumber = getSlotNumber,

		onClick = onClick,
		onMouseEnter = onMouseEnter,
		onMouseLeave = onMouseLeave,
		onDragBegin = onDragBegin,
		onDragStopped = onDragStopped,
	}
end

return useSlot
