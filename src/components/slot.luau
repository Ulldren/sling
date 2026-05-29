local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local checkBounds = require("../utils/checkBounds")
local getClosestFrame = require("../utils/getClosestFrame")
local px = require("../utils/px")
local settings = require("../settings")
local states = require("../states")
local tooltip = require("./tooltip")
local types = require("../types")
local usePreferredInput = require("../hooks/usePreferredInput")
local vide = require("../../vide")
local theme = require("../theme")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local slotUtils = require("../utils/slotUtils")

local create = vide.create
local show = vide.show
local source = vide.source
local effect = vide.effect
local cleanup = vide.cleanup
local action = vide.action
local untrack = vide.untrack
local derive = vide.derive

type Props = {
	entry: vide.Source<types.ItemEntry>,
	order: number,
	visible: vide.Source<boolean>?,
	unlocked: vide.Source<boolean>?,
	inHotbar: boolean?,
}

local function slot(props: Props): Frame
	local entry = props.entry
	local item = vide.derive(function()
		return entry().item
	end)

	local isHovering = source(false)
	local isDragging = source(false)

	local slotRef = source(nil :: TextButton?)
	local slotFrameRef = source(nil :: Frame?)

	local slotSize = px.offset(settings.slotSize, settings.slotSize)
	local preferredInput = usePreferredInput()
	local preferredTransparency = usePreferredTransparency()
	local backgroundTransparency = vide.derive(function()
		return theme.theme.slotBackgroundTransparency() * preferredTransparency()
	end)
	local zindex = vide.derive(cond.ifelse(isDragging, 2, 1))

	local itemName = source("")
	local itemImage = source("")
	local tooltipText = source("")

	effect(function()
		local i = item()
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

	local getSourceIdx = derive(function()
		local e = props.entry()
		return table.find(states.items(), e) :: number
	end)

	local lastClickTime = 0

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
		local currentItems = untrack(states.items)
		local itemA = currentItems[sourceIdx]
		if not itemA or itemA.item == nil then
			return
		end
		slotUtils.swap(sourceIdx, targetIdx)
	end

	local function moveToInventory()
		slotUtils.moveToInventory(getSourceIdx())
	end

	local function moveToHotbar()
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
			local slotBtn = slotRef()
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
			end,
			DragStopped = function(x: number, y: number)
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
