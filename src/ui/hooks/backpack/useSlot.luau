local GuiService = game:GetService("GuiService")

local cond = require("../../../core/utils/cond")
local config = require("../../../core/config")
local events = require("../../../core/events")
local px = require("../../../core/utils/px")
local slotManager = require("../../../core/slotManager")
local states = require("../../../core/states")
local useEventListener = require("../useEventListener")
local usePreferredInput = require("../usePreferredInput")
local vide = require("../../../../vide")

local cleanup = vide.cleanup
local effect = vide.effect
local untrack = vide.untrack
local source = vide.source
local derive = vide.derive
local spring = vide.spring

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
	item: () -> BackpackItem?,
	order: number,
	inHotbar: boolean?,
})
	local item = props.item

	local slotRef = source(nil :: TextButton?)
	local slotFrameRef = source(nil :: Frame?)

	local isDragging = source(false)

	local slotSizePixel = source(config.slotSize)
	local slotSize = spring(px.offset(slotSizePixel, slotSizePixel), 0.1)
	local preferredInput = usePreferredInput()
	local zindex = derive(cond.ifelse(isDragging, 2, 1))

	local itemName = source("")
	local itemImage = source("")
	local tooltipText = source("")

	local slotNumber = ""
	if props.order >= 1 and props.order < 10 then
		slotNumber = tostring(props.order)
	elseif props.order == 10 then
		slotNumber = "0"
	end

	effect(function()
		local i = item()
		if i then
			itemName(i.Name)
			itemImage(i.TextureId)
			useEventListener(i:GetPropertyChangedSignal("Name"), function()
				itemName(i.Name)
			end)
			useEventListener(i:GetPropertyChangedSignal("TextureId"), function()
				itemImage(i.TextureId)
			end)

			if i:IsA("Tool") then
				tooltipText(i.ToolTip)
				useEventListener(i:GetPropertyChangedSignal("ToolTip"), function()
					tooltipText(i.ToolTip)
				end)
			else
				tooltipText("")
			end
		else
			itemName("")
			itemImage("")
			tooltipText("")
		end
	end)

	local getIndex = derive(function()
		local currentItem = item()
		return currentItem ~= nil and slotManager.getItemIndex(currentItem)
			or (if props.inHotbar then props.order else states.slots() + props.order)
	end)

	local function swap(targetIndex: number)
		local index = untrack(getIndex)
		local items = untrack(states.items)
		if not items[index] then
			return
		end
		slotManager.swap(index, targetIndex)
	end

	local function saveHotbar()
		events.hotbarChanged.fire(slotManager.getHotbarItems())
	end

	local lastClickTime = 0

	local function onClick()
		local index = untrack(getIndex)
		local slots = untrack(states.slots)

		if preferredInput() == Enum.PreferredInput.Gamepad and untrack(states.opened) then
			local activeSwapIndex = untrack(states.gamepadSwapIndex)
			if activeSwapIndex then
				states.gamepadSwapIndex(nil)
				if activeSwapIndex ~= index then
					slotManager.swap(index, activeSwapIndex)
					if index <= slots or activeSwapIndex <= slots then
						saveHotbar()
					end
				end
				return
			else
				states.gamepadSwapIndex(index)

				slotSizePixel(config.slotSize * 1.2)
				task.delay(0.1, function()
					slotSizePixel(config.slotSize)
				end)

				return
			end
		end

		local i = untrack(item)
		if not i then
			return
		end
		local now = os.clock()
		if now - lastClickTime < config.doubleClickTime and not props.inHotbar then
			lastClickTime = 0
			local moved = slotManager.moveToHotbar(untrack(getIndex))
			if moved then
				saveHotbar()
			end
		else
			lastClickTime = now
			states.equippedItem(if i == untrack(states.equippedItem) then nil else i)
		end
	end

	local function onDragBegin()
		isDragging(true)

		local slot = untrack(slotRef)
		local app = untrack(states.appRef)
		if not (slot and app) then
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

		local slot = untrack(slotRef)
		local slotFrame = untrack(slotFrameRef)
		if not (slot and slotFrame) then
			return
		end

		if not props.inHotbar then
			slot.Parent = slotFrame
		end
		slot.Position = UDim2.new()

		local abpos = Vector2.new(x, y)
		local hotbar = untrack(states.hotbarRef)

		local insideHotbar = false

		if hotbar then
			insideHotbar = checkBounds(abpos, hotbar)
			if insideHotbar then
				local closest = getClosestFrame(abpos, hotbar, config.slotSize / 2)
				if closest and closest ~= slotFrame then
					local targetOrder = closest.LayoutOrder
					swap(targetOrder)
					saveHotbar()
					return
				end
			end
		end

		if props.inHotbar and not insideHotbar then
			local index = untrack(getIndex)
			local moved = slotManager.moveToInventory(index)
			if moved then
				saveHotbar()
			end
		end
	end

	local function useDrag()
		return {
			Draggable = cond.all(states.opened, item),
			DragBegin = onDragBegin,
			DragStopped = onDragStopped,
		}
	end

	cleanup(events.gamepadRemove.on(function()
		if not untrack(states.opened) then
			return
		end
		if not props.inHotbar then
			return
		end

		local slotBtn = untrack(slotRef)
		if slotBtn and GuiService.SelectedObject == slotBtn then
			local index = untrack(getIndex)
			local moved = slotManager.moveToInventory(index)
			if moved then
				saveHotbar()
			end
		end
	end))

	return {
		slotRef = slotRef,
		slotFrameRef = slotFrameRef,

		itemName = itemName,
		itemImage = itemImage,
		tooltipText = tooltipText,
		slotNumber = slotNumber,

		isDragging = isDragging,

		slotSize = slotSize,
		zindex = zindex,

		onClick = onClick,

		useDrag = useDrag,

		getIndex = getIndex,
	}
end

return useSlot
