local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local px = require("../utils/px")
local states = require("../states")
local theme = require("../theme")
local tooltip = require("./tooltip")
local types = require("../types")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local useSlot = require("../hooks/backpack/useSlot")
local vide = require("../../vide")

local create = vide.create
local show = vide.show
local action = vide.action
local derive = vide.derive

type Props = {
	entry: vide.Source<types.ItemEntry>,
	order: number,
	visible: vide.Source<boolean>?,
	unlocked: vide.Source<boolean>?,
	inHotbar: boolean?,
}

local function slot(props: Props): Frame
	local s = useSlot({
		entry = props.entry,
		order = props.order,
		inHotbar = props.inHotbar,
	})

	local slotSize = s.slotSize
	local zindex = s.zindex
	local item = s.item
	local itemName = s.itemName
	local itemImage = s.itemImage
	local tooltipText = s.tooltipText
	local slotRef = s.slotRef
	local slotFrameRef = s.slotFrameRef
	local isHovering = s.isHovering
	local isDragging = s.isDragging
	local getSourceIdx = s.getSourceIdx
	local getSlotNumber = s.getSlotNumber
	local onClick = s.onClick
	local onMouseEnter = s.onMouseEnter
	local onMouseLeave = s.onMouseLeave
	local onDragBegin = s.onDragBegin
	local onDragStopped = s.onDragStopped

	local preferredTransparency = usePreferredTransparency()
	local backgroundTransparency = derive(function()
		return theme.theme.slotBackgroundTransparency() * preferredTransparency()
	end)

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

			MouseButton1Click = onClick,
			MouseEnter = onMouseEnter,
			MouseLeave = onMouseLeave,
			DragBegin = onDragBegin,
			DragStopped = onDragStopped,

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
					Text = getSlotNumber,
					TextColor3 = colorSpring(theme.theme.slotTextColor),
					TextSize = px.scale(theme.theme.slotTextSize),
					FontFace = function()
						return Font.new(theme.theme.slotFontFace().Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
					end,
					TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
					TextStrokeTransparency = theme.theme.textStrokeTransparency,
					ZIndex = zindex,
				})
			end),
			create("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = itemImage,
				Size = UDim2.fromScale(1, 1),
				ZIndex = zindex,
				Visible = cond.neq(itemImage, ""),

				create("UICorner")({
					CornerRadius = theme.theme.slotCornerRadius,
				}),
			}),
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
