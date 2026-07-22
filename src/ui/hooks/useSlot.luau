local GuiService = game:GetService("GuiService")

local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local events = require("../../core/events")
local slotManager = require("../../core/slotManager")
local states = require("../../core/states")
local useEventListener = require("./useEventListener")
local vide = require("../../../vide")

local effect = vide.effect
local untrack = vide.untrack
local source = vide.source
local derive = vide.derive

local function checkBounds(x: number, y: number, target: GuiObject): boolean
	local absPos = target.AbsolutePosition
	local absSize = target.AbsoluteSize
	return x >= absPos.X and x <= absPos.X + absSize.X and y >= absPos.Y and y <= absPos.Y + absSize.Y
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
	item: () -> BackpackItem?,
	order: number,
	inHotbar: boolean?,
})
	local item = props.item
	local itemName = source("")
	local itemImage = source("")
	local tooltipText = source("")

	local slotRef = source((nil :: any) :: TextButton)
	local slotFrameRef = source((nil :: any) :: Frame)

	local slotNumber = ""
	if props.order >= 1 and props.order < 10 then
		slotNumber = tostring(props.order)
	elseif props.order == 10 then
		slotNumber = "0"
	end

	local isDragging = source(false)

	local zindex = derive(cond.ifelse(isDragging, 2, 1))

	effect(function()
		local currentItem = item()
		if not currentItem then
			itemName("")
			itemImage("")
			tooltipText("")
			return
		end

		itemName(currentItem.Name)
		useEventListener(currentItem:GetPropertyChangedSignal("Name"), function()
			itemName(currentItem.Name)
		end)
		itemImage(currentItem.TextureId)
		useEventListener(currentItem:GetPropertyChangedSignal("TextureId"), function()
			itemImage(currentItem.TextureId)
		end)
		if currentItem:IsA("Tool") then
			tooltipText(currentItem.ToolTip)
			useEventListener(currentItem:GetPropertyChangedSignal("ToolTip"), function()
				tooltipText(currentItem.ToolTip)
			end)
		end
	end)

	local getIndex = derive(function()
		local currentItem = item()
		return currentItem ~= nil and slotManager.getItemIndex(currentItem)
			or (if props.inHotbar then props.order else states.slots() + props.order)
	end)

	local function saveHotbar()
		events.hotbarChanged.fire(slotManager.getHotbarItems())
	end

	local function swap(targetIndex: number, force: boolean?)
		local index = untrack(getIndex)
		local items = untrack(states.items)
		local slots = untrack(states.slots)
		if items[index] or force then
			local moved = slotManager.swap(index, targetIndex)
			if moved and (index <= slots or targetIndex <= slots) then
				saveHotbar()
			end
		end
	end

	local function moveToInventory()
		local moved = slotManager.moveToInventory(untrack(getIndex))
		if moved then
			saveHotbar()
		end
	end

	local function moveToHotbar()
		local moved = slotManager.moveToHotbar(untrack(getIndex))
		if moved then
			saveHotbar()
		end
	end

	local lastClickTime = 0
	local doubleClickTime = 0.5

	local function onClick()
		if states.equipMovesToInventory then
			local currentItem = item()
			if currentItem and currentItem:GetAttribute("HotbarOnly") ~= true then
				moveToInventory()
				return
			end
		end

		local index = getIndex()

		local isGamepadInput = states.preferredInput() == Enum.PreferredInput.Gamepad
		if states.opened() and isGamepadInput and not states.vrEnabled() then
			local activeSwapIndex = states.gamepadSwapIndex()
			if activeSwapIndex then
				states.gamepadSwapIndex(nil :: any)
				if activeSwapIndex ~= index then
					swap(activeSwapIndex, true)
				end
				return
			else
				states.gamepadSwapIndex(index)
				return
			end
		end

		local currentItem = item()
		if not currentItem then
			return
		end

		local currentEquipped = states.equippedItem()
		states.equippedItem(if currentItem == currentEquipped then nil :: any else currentItem)

		local now = os.clock()
		if now - lastClickTime < doubleClickTime and not props.inHotbar then
			lastClickTime = 0
			moveToHotbar()
		else
			lastClickTime = now
		end
	end

	local function onDragBegin()
		isDragging(true)

		local slot = slotRef()
		local app = states.appRef()
		if slot and app and not props.inHotbar then
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
		if not (slot and slotFrame) then
			return
		end

		if not props.inHotbar then
			slot.Parent = slotFrame
		end
		slot.Position = UDim2.new()

		local hotbar = states.hotbarRef()
		local insideHotbar = hotbar and checkBounds(x, y, hotbar)

		if insideHotbar then
			local closest = getClosestFrame(Vector2.new(x, y), hotbar, config.slotSize / 2)
			if closest and closest ~= slotFrame then
				swap(closest.LayoutOrder)
			end
		elseif props.inHotbar then
			moveToInventory()
		end
	end

	local function useDrag()
		return {
			Draggable = cond.all(states.opened, item),
			DragBegin = onDragBegin,
			DragStopped = onDragStopped,
		}
	end

	effect(function()
		local pressedRemoveFromHotbar = states.inputs.removeFromHotbar()
		if not pressedRemoveFromHotbar or not props.inHotbar then
			return
		end

		local slotBtn = untrack(slotRef)
		if slotBtn and GuiService.SelectedObject == slotBtn then
			moveToInventory()
		end
	end)

	return {
		itemName = itemName,
		itemImage = itemImage,
		tooltipText = tooltipText,
		slotRef = slotRef,
		slotFrameRef = slotFrameRef,
		slotNumber = slotNumber,
		zindex = zindex,
		isDragging = isDragging,
		useDrag = useDrag,
		onClick = onClick,
		getIndex = getIndex,
	}
end

export type Slot = typeof(useSlot(...))

return useSlot
