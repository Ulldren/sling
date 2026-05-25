local vide = require("../../vide")
local types = require("../types")
local tooltip = require("./tooltip")

local SLOT_SIZE = 60

local create = vide.create
local show = vide.show
local source = vide.source
local effect = vide.effect
local cleanup = vide.cleanup
local action = vide.action

type Props = {
	opened: vide.Source<boolean>,
	item: vide.Source<types.InventoryItem?>,
	equippedItem: vide.Source<types.InventoryItem?>,
	order: number,
	keyboardHint: vide.Source<boolean>?,
	unlocked: vide.Source<boolean>?,
	attributes: types.Attributes,
}

local function slot(props: Props): Frame
	local itemName = source("")
	local itemImage = source("")
	local tooltipText = source("")

	local isHovering = source(false)
	local isDragging = source(false)

	local slotRef = source(nil :: TextButton?)

	effect(function()
		local i = props.item()

		if i == nil then
			itemName("")
			itemImage("")
			tooltipText("")
			return
		end

		itemName(i.Name)
		cleanup(i:GetPropertyChangedSignal("Name"):Connect(function()
			itemName(i.Name)
		end))

		if i:IsA("Tool") then
			local tool = i :: Tool
			itemImage(tool.TextureId)
			tooltipText(tool.ToolTip)
			cleanup(tool:GetPropertyChangedSignal("TextureId"):Connect(function()
				itemImage(tool.TextureId)
			end))
			cleanup(tool:GetPropertyChangedSignal("ToolTip"):Connect(function()
				tooltipText(tool.ToolTip)
			end))
		else
			itemImage("")
			tooltipText("")
		end
	end)

	local slotNumber = ""
	if props.order >= 1 and props.order < 10 then
		slotNumber = tostring(props.order)
	elseif props.order == 10 then
		slotNumber = "0"
	end

	local slotSize = UDim2.fromOffset(SLOT_SIZE, SLOT_SIZE)

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = slotSize,

		create("TextButton")({
			BackgroundColor3 = props.attributes.BackgroundColor3,
			BackgroundTransparency = function()
				return if props.unlocked and props.unlocked() then 0 else props.attributes.BackgroundTransparency()
			end,
			Size = slotSize,
			Text = function()
				return if itemImage() == "" then itemName() else ""
			end,
			FontFace = props.attributes.FontFace,
			TextColor3 = props.attributes.TextColor3,
			TextScaled = true,
			TextStrokeTransparency = props.attributes.TextStrokeTransparency,
			TextTruncate = Enum.TextTruncate.SplitWord,
			LayoutOrder = props.order,
			Draggable = function()
				return props.opened() and props.item() ~= nil
			end,

			action(function(inst)
				slotRef(inst :: TextButton)
			end) :: any,

			MouseButton1Click = function()
				local i = props.item()
				if i then
					props.equippedItem(if i == props.equippedItem() then nil else i)
				end
			end,
			MouseEnter = function()
				isHovering(true)
			end,
			MouseLeave = function()
				isHovering(false)
				isDragging(false)
			end,
			DragBegin = function(dragPoint: UDim2)
				isDragging(true)
			end,
			DragStopped = function(x: number, y: number)
				isDragging(false)

				local slot = slotRef()
				if not slot then
					return
				end

				slot.Position = UDim2.new()

				--[[if FakeSlotFrame then
					FakeSlotFrame:Destroy()
				end

				local now: number = os.clock()

				SlotFrame.Position = startPoint
				SlotFrame.Parent = startParent

				SlotFrame.BorderSizePixel = 0
				inventoryIcon:unlock()

				-- Restore height
				SlotFrame.ZIndex = 1
				ToolIcon.ZIndex = 1
				ToolName.ZIndex = 1
				startParent.ZIndex = 1

				if SlotNumber then
					SlotNumber.ZIndex = 1
				end
				-- if HighlightFrame then
				-- 	HighlightFrame.ZIndex = 1
				-- 	for _, child in pairs(HighlightFrame:GetChildren()) do
				-- 		child.ZIndex = 1
				-- 	end
				-- end

				Dragging[SlotFrame] = nil

				-- Make sure the tool wasn't dropped
				if not slot.Tool then
					return
				end

				-- Check where we were dropped
				if CheckBounds(InventoryFrame, x, y) then
					if slot.Index <= NumberOfHotbarSlots then
						slot:MoveToInventory()
					end
					-- Check for double clicking on an inventory slot, to move into empty hotbar slot
					if slot.Index > NumberOfHotbarSlots and now - lastUpTime < DOUBLE_CLICK_TIME then
						if LowestEmptySlot then
							local myTool: any = slot.Tool
							slot:Clear()
							LowestEmptySlot:Fill(myTool)
							slot:Delete()
						end
						now = 0 -- Resets the timer
					end
				elseif CheckBounds(HotbarFrame, x, y) then
					local closest: { number } = { math.huge, nil :: any }
					for i: number = 1, NumberOfHotbarSlots do
						local otherSlot: any = Slots[i]
						local offset: number = GetOffset(otherSlot.Frame, Vector2.new(x, y))
						if offset < closest[1] then
							closest = { offset, otherSlot }
						end
					end
					local closestSlot: any = closest[2]
					if closestSlot ~= slot then
						slot:Swap(closestSlot)
						if slot.Index > NumberOfHotbarSlots then
							local tool: Tool = slot.Tool
							if not tool then -- Clean up after ourselves if we're an inventory slot that's now empty
								slot:Delete()
							else -- Moved inventory slot to hotbar slot, and gained a tool that needs to be unequipped
								if IsEquipped(tool) then --NOTE: HopperBin
									UnequipAllTools()
								end
								-- Also hide the inventory slot if we're showing results right now
								if ViewingSearchResults then
									slot.Frame.Visible = false
									slot.Frame.Parent = InventoryFrame
								end
							end
						end
					end
				else
					-- local tool = slot.Tool
					-- if tool.CanBeDropped then --TODO: HopperBins
					-- tool.Parent = workspace
					-- --TODO: Move away from character
					-- end
					if slot.Index <= NumberOfHotbarSlots then
						slot:MoveToInventory() --NOTE: Temporary
					end
				end

				lastUpTime = now]]
			end,

			create("UIPadding")({
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			}),

			create("UITextSizeConstraint")({
				MaxTextSize = props.attributes.TextSize,
				MinTextSize = 12,
			}),

			create("UICorner")({
				CornerRadius = props.attributes.CornerRadius,
			}),

			show(function()
				return props.keyboardHint and props.keyboardHint()
			end, function()
				return create("TextLabel")({
					Name = "Number",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					Text = slotNumber,
					TextColor3 = props.attributes.TextColor3,
					TextSize = props.attributes.TextSize,
					FontFace = function()
						return Font.new(
							props.attributes.FontFace().Family,
							Enum.FontWeight.Heavy,
							Enum.FontStyle.Normal
						)
					end,
					TextStrokeColor3 = props.attributes.TextStrokeColor3,
					TextStrokeTransparency = props.attributes.TextStrokeTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
				})
			end),
			create("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = itemImage,
				Size = UDim2.fromScale(1, 1),
				Visible = function()
					return itemImage() ~= ""
				end,

				create("UICorner")({
					CornerRadius = props.attributes.CornerRadius,
				}),
			}),
			show(function()
				return tooltipText() ~= "" and isHovering()
			end, function()
				return tooltip({
					text = tooltipText,
					attributes = props.attributes,
				})
			end),
			show(function()
				return props.item() ~= nil and props.equippedItem() == props.item()
			end, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = props.attributes.EquipBorderColor3,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = props.attributes.EquipBorderSizePixel,
				})
			end),
			show(function()
				return props.item() ~= nil and isDragging()
			end, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner,
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = 2,
				})
			end),
		}),
	})
end

return slot
