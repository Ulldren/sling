const GuiService = game:GetService("GuiService")
const UserInputService = game:GetService("UserInputService")

const checkBounds = require("../utils/checkBounds")
const getClosestFrame = require("../utils/getClosestFrame")
const px = require("../utils/px")
const settings = require("../settings")
const states = require("../states")
const tooltip = require("./tooltip")
const types = require("../types")
const usePreferredInput = require("../hooks/usePreferredInput")
const vide = require("../../vide")
const theme = require("../theme")
const usePreferredTransparency = require("../hooks/usePreferredTransparency")
const colorSpring = require("../utils/colorSpring")
const cond = require("../utils/cond")
const slotUtils = require("../utils/slotUtils")

const create = vide.create
const show = vide.show
const source = vide.source
const effect = vide.effect
const cleanup = vide.cleanup
const action = vide.action
const untrack = vide.untrack
const derive = vide.derive

type Props = {
	entry: vide.Source<types.ItemEntry>,
	order: number,
	visible: vide.Source<boolean>?,
	unlocked: vide.Source<boolean>?,
	inHotbar: boolean?,
}

const function slot(props: Props): Frame
	const entry = props.entry
	const item = vide.derive(function()
		return entry().item
	end)

	const isHovering = source(false)
	const isDragging = source(false)

	const slotRef = source(nil :: TextButton?)
	const slotFrameRef = source(nil :: Frame?)

	const slotSize = px.offset(settings.slotSize, settings.slotSize)
	const preferredInput = usePreferredInput()
	const preferredTransparency = usePreferredTransparency()
	const backgroundTransparency = vide.derive(function()
		return theme.theme.slotBackgroundTransparency() * preferredTransparency()
	end)
	const zindex = vide.derive(cond.ifelse(isDragging, 2, 1))

	const itemName = source("")
	const itemImage = source("")
	const tooltipText = source("")

	effect(function()
		const i = item()
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

	const getSourceIdx = derive(function()
		const e = props.entry()
		return table.find(states.items(), e) :: number
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

	const function swap(targetIdx: number)
		const sourceIdx = untrack(getSourceIdx)
		const currentItems = untrack(states.items)
		const itemA = currentItems[sourceIdx]
		if not itemA or itemA.item == nil then
			return
		end
		slotUtils.swap(sourceIdx, targetIdx)
	end

	const function moveToInventory()
		slotUtils.moveToInventory(getSourceIdx())
	end

	const function moveToHotbar()
		slotUtils.moveToHotbar(getSourceIdx())
	end

	cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
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
		Visible = props.visible,

		action(slotFrameRef),

		create("TextButton")({
			AutoButtonColor = true,
			BackgroundColor3 = colorSpring(theme.theme.slotBackgroundColor),
			BackgroundTransparency = cond.ifelse(props.unlocked, 0, backgroundTransparency),
			Size = slotSize,
			Text = cond.ifelse(cond.eq(itemImage, ""), itemName, ""),
			FontFace = theme.theme.slotFontFace,
			TextColor3 = colorSpring(theme.theme.slotTextColor),
			TextScaled = true,
			TextStrokeTransparency = theme.theme.textStrokeTransparency,
			TextTruncate = Enum.TextTruncate.SplitWord,
			Draggable = cond.all(states.opened, item),
			ZIndex = zindex,

			action(slotRef) :: any,

			MouseButton1Click = function()
				const sourceIdx = untrack(getSourceIdx)
				if preferredInput() == Enum.PreferredInput.Gamepad and untrack(states.opened) then
					const activeSwapIdx = untrack(states.gamepadSwapIdx)
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

				const i = untrack(item)
				if not i then
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
					states.equippedItem(if i == untrack(states.equippedItem) then nil else i)
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

			create("UITextSizeConstraint")({
				MaxTextSize = px.scale(theme.theme.slotTextSize),
				MinTextSize = px.scale(12),
			}),

			create("UIPadding")({
				PaddingBottom = px.udim(0, 5),
				PaddingLeft = px.udim(0, 5),
				PaddingRight = px.udim(0, 5),
				PaddingTop = px.udim(0, 5),
			}),

			create("UICorner")({
				CornerRadius = theme.theme.slotCornerRadius,
			}),

			show(cond.all(props.inHotbar, states.keyboardHint), function()
				return create("TextLabel")({
					Name = "Number",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = getSlotNumber(),
					TextColor3 = colorSpring(theme.theme.slotTextColor),
					TextSize = px.scale(theme.theme.slotTextSize),
					FontFace = function()
						return Font.new(theme.theme.slotFontFace().Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
					end,
					TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
					TextStrokeTransparency = theme.theme.textStrokeTransparency,
					ZIndex = function()
						return zindex() + 1
					end,
				})
			end),
			show(cond.neq(itemImage, ""), function()
				return create("ImageLabel")({
					Name = "Icon",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = itemImage,
					Size = UDim2.fromScale(1, 1),
					ZIndex = zindex,

					create("UICorner")({
						CornerRadius = theme.theme.slotCornerRadius,
					}),
				})
			end),
			show(cond.all(item, cond.eq(states.equippedItem, item)), function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = theme.theme.slotEquipStrokeColor,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = px.scale(theme.theme.slotEquipStrokeThickness),
				})
			end),
			show(cond.all(item, cond.any(isDragging, cond.eq(states.gamepadSwapIdx, getSourceIdx))), function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner,
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = px.scale(2),
				})
			end),
			show(cond.all(props.inHotbar, cond.neq(tooltipText, ""), isHovering), function(_, present)
				return tooltip({
					text = tooltipText,
					visible = present,
				}), 0.2
			end),
		}),
	})
end

return slot
