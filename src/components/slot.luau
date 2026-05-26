const GuiService = game:GetService("GuiService")
const UserInputService = game:GetService("UserInputService")

const checkBounds = require("../utils/checkBounds")
const getClosestFrame = require("../utils/getClosestFrame")
const px = require("../utils/px")
const settings = require("../settings")
const states = require("../states")
const tooltip = require("./tooltip")
const types = require("../types")
const useBackgroundTransparency = require("../hooks/useBackgroundTransparency")
const usePreferredInput = require("../hooks/usePreferredInput")
const vide = require("../../vide")

const create = vide.create
const show = vide.show
const source = vide.source
const effect = vide.effect
const cleanup = vide.cleanup
const action = vide.action

type Props = {
	item: vide.Source<types.InventoryItem?>,
	order: number,
	unlocked: vide.Source<boolean>?,
	inHotbar: boolean?,
}

const function slot(props: Props): Frame
	const isHovering = source(false)
	const isDragging = source(false)

	const slotRef = source(nil :: TextButton?)
	const slotFrameRef = source(nil :: Frame?)

	const slotSize = px.offset(settings.slotSize, settings.slotSize)
	const backgroundTransparency = useBackgroundTransparency()
	const preferredInput = usePreferredInput()
	const zindex = vide.derive(function()
		return if isDragging() then 2 else 1
	end)

	const itemName = source("")
	const itemImage = source("")
	const tooltipText = source("")

	effect(function()
		const i = props.item()
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
			const tool = i :: Tool
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

	local lastClickTime = 0

	const function getSlotNumber(): string
		if props.order >= 1 and props.order < 10 then
			return tostring(props.order)
		elseif props.order == 10 then
			return "0"
		end
		return ""
	end

	const function getSourceIdx(): number?
		const item = props.item()
		if not item then
			return nil
		end
		const currentItems = states.items()
		for idx, it in currentItems do
			if it == item then
				return idx
			end
		end
		return nil
	end

	const function swap(targetSlot: number)
		const slots = states.slots()
		const sourceIdx = getSourceIdx() or (if props.inHotbar then props.order else slots + props.order)
		const currentItems = table.clone(states.items())
		const itemA = currentItems[sourceIdx]
		if not itemA then
			return
		end
		const targetIdx = targetSlot
		const itemB = currentItems[targetIdx]
		if props.inHotbar then
			currentItems[sourceIdx], currentItems[targetIdx] = currentItems[targetIdx], currentItems[sourceIdx]
		else
			if itemB then
				currentItems[sourceIdx] = itemB
				currentItems[targetIdx] = itemA
			else
				currentItems[sourceIdx] = nil
				currentItems[targetIdx] = itemA

				local maxIdx = slots
				for idx in currentItems do
					if idx > maxIdx then
						maxIdx = idx
					end
				end

				local invIndex = slots + 1
				for i = slots + 1, maxIdx do
					const item = currentItems[i]
					if item ~= nil then
						currentItems[i] = nil
						currentItems[invIndex] = item
						invIndex = invIndex + 1
					end
				end
			end
		end
		states.items(currentItems)
	end

	const function moveToInventory()
		const slots = states.slots()
		const sourceIdx = getSourceIdx() or props.order
		const currentItems = table.clone(states.items())
		const itemToMove = currentItems[sourceIdx]
		if not itemToMove then
			return
		end
		currentItems[sourceIdx] = nil
		local maxIdx = slots
		for idx in currentItems do
			if idx > maxIdx then
				maxIdx = idx
			end
		end
		currentItems[maxIdx + 1] = itemToMove
		states.items(currentItems)
	end

	const function moveToHotbar()
		const slots = states.slots()
		const currentItems = states.items()
		local targetIdx = nil
		for idx = 1, slots do
			if currentItems[idx] == nil then
				targetIdx = idx
				break
			end
		end
		if targetIdx then
			swap(targetIdx)
		end
	end

	cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end
		if not states.opened() then
			return
		end
		if not props.inHotbar then
			return
		end

		if input.KeyCode == settings.gamepadRemoveKey then
			const slotBtn = slotRef()
			if slotBtn and GuiService.SelectedObject == slotBtn then
				moveToInventory()
			end
		end
	end))

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = slotSize,
		LayoutOrder = props.order,

		action(slotFrameRef),

		create("TextButton")({
			AutoButtonColor = true,
			BackgroundColor3 = states.attributes.BackgroundColor3,
			BackgroundTransparency = function()
				return if props.unlocked and props.unlocked() then 0 else backgroundTransparency()
			end,
			Size = slotSize,
			Text = function()
				return if itemImage() == "" then itemName() else ""
			end,
			FontFace = states.attributes.FontFace,
			TextColor3 = states.attributes.TextColor3,
			TextScaled = true,
			TextStrokeTransparency = states.attributes.TextStrokeTransparency,
			TextTruncate = Enum.TextTruncate.SplitWord,
			Draggable = function()
				return states.opened() and props.item() ~= nil
			end,
			ZIndex = zindex,

			action(slotRef) :: any,

			MouseButton1Click = function()
				const slots = states.slots()
				const sourceIdx = getSourceIdx() or (if props.inHotbar then props.order else slots + props.order)

				if preferredInput() == Enum.PreferredInput.Gamepad and states.opened() then
					const activeSwapIdx = states.gamepadSwapIdx()
					if activeSwapIdx then
						states.gamepadSwapIdx(nil)
						if activeSwapIdx ~= sourceIdx then
							const currentItems = table.clone(states.items())
							currentItems[sourceIdx], currentItems[activeSwapIdx] =
								currentItems[activeSwapIdx], currentItems[sourceIdx]
							states.items(currentItems)
						end
						return
					end
				end

				const i = props.item()
				if not i then
					return
				end

				if preferredInput() == Enum.PreferredInput.Gamepad and states.opened() then
					states.gamepadSwapIdx(sourceIdx)
					return
				end

				const now = os.clock()
				if now - lastClickTime < settings.doubleClickTime then
					lastClickTime = 0

					if not props.inHotbar then
						moveToHotbar()
					end
				else
					lastClickTime = now
					states.equippedItem(if i == states.equippedItem() then nil else i)
				end
			end,
			MouseEnter = function()
				isHovering(true)
			end,
			MouseLeave = function()
				isHovering(false)
			end,
			DragBegin = function()
				isDragging(true)

				const slot = slotRef()
				const app = states.appRef()
				if not slot or not app then
					return
				end
				if not props.inHotbar then
					const newPosition = UDim2.new(
						0,
						slot.AbsolutePosition.X - app.AbsolutePosition.X,
						0,
						slot.AbsolutePosition.Y - app.AbsolutePosition.Y
					)
					slot.Parent = app
					slot.Position = newPosition
				end
			end,
			DragStopped = function(x: number, y: number)
				isDragging(false)

				const slot = slotRef()
				const slotFrame = slotFrameRef()
				if not slot or not slotFrame then
					return
				end

				if not props.inHotbar then
					slot.Parent = slotFrame
				end
				slot.Position = UDim2.new()

				const abpos = Vector2.new(x, y)
				const hotbar = states.hotbarRef()

				local insideHotbar = false

				if hotbar then
					insideHotbar = checkBounds(abpos, hotbar)
					if insideHotbar then
						const closest = getClosestFrame(abpos, hotbar, settings.slotSize / 2)
						if closest and closest ~= slotFrame then
							const targetOrder = closest.LayoutOrder
							swap(targetOrder)
							return
						end
					end
				end

				if props.inHotbar and not insideHotbar then
					moveToInventory()
				end
			end,

			create("UIPadding")({
				PaddingBottom = px.udim(0, 5),
				PaddingLeft = px.udim(0, 5),
				PaddingRight = px.udim(0, 5),
				PaddingTop = px.udim(0, 5),
			}),

			create("UITextSizeConstraint")({
				MaxTextSize = px.scale(states.attributes.TextSize),
				MinTextSize = px.scale(12),
			}),

			create("UICorner")({
				CornerRadius = states.attributes.CornerRadius,
			}),

			show(function()
				return props.inHotbar and states.keyboardHint()
			end, function()
				return create("TextLabel")({
					Name = "Number",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = getSlotNumber(),
					TextColor3 = states.attributes.TextColor3,
					TextSize = px.scale(states.attributes.TextSize),
					FontFace = function()
						return Font.new(
							states.attributes.FontFace().Family,
							Enum.FontWeight.Heavy,
							Enum.FontStyle.Normal
						)
					end,
					TextStrokeColor3 = states.attributes.TextStrokeColor3,
					TextStrokeTransparency = states.attributes.TextStrokeTransparency,
					ZIndex = function()
						return zindex() + 1
					end,
				})
			end),
			show(function()
				return itemImage() ~= ""
			end, function()
				return create("ImageLabel")({
					Name = "Icon",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = itemImage,
					Size = UDim2.fromScale(1, 1),
					ZIndex = zindex,

					create("UICorner")({
						CornerRadius = states.attributes.CornerRadius,
					}),
				})
			end),
			show(function()
				return props.item() ~= nil and states.equippedItem() == props.item()
			end, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = states.attributes.EquipBorderColor3,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = px.scale(states.attributes.EquipBorderSizePixel),
				})
			end),
			show(function()
				const slots = states.slots()
				const sourceIdx = if props.inHotbar then props.order else slots + props.order
				return props.item() ~= nil and (isDragging() or states.gamepadSwapIdx() == sourceIdx)
			end, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner,
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = px.scale(2),
				})
			end),
			show(function()
				return props.inHotbar and tooltipText() ~= "" and isHovering()
			end, function()
				return tooltip({
					text = tooltipText,
				})
			end),
		}),
	})
end

return slot
