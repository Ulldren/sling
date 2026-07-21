local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local theme = require("../theme")
local tooltip = require("./tooltip")
local useSlot = require("../hooks/useSlot")
local vide = require("../../../vide")

local create = vide.create
local show = vide.show
local action = vide.action
local derive = vide.derive
local source = vide.source

local SLOT_PADDING = 5

type Props = {
	item: () -> BackpackItem?,
	visible: (() -> boolean)?,
	order: number,
	inHotbar: boolean?,
}

export type SlotFrameProps = {
	item: () -> BackpackItem?,
	visible: (() -> boolean)?,
	order: number,
	inHotbar: boolean?,

	slot: useSlot.Slot,
	isHovering: vide.Source<boolean>,
	scale: vide.Source<number>,

	children: { any }?,
	[number]: any,
}

local function defaultSlotFrame(props: SlotFrameProps)
	local item = props.item
	local slot = props.slot
	local isHovering = props.isHovering

	local showEquipStroke = cond.all(item, cond.eq(states.equippedItem, item))
	local showDraggingStroke =
		cond.any(cond.all(item, slot.isDragging), cond.eq(states.gamepadSwapIndex, slot.getIndex))
	local showTooltip = cond.all(props.inHotbar, cond.neq(slot.tooltipText, ""), isHovering)

	local showItemName = cond.eq(slot.itemImage, "")
	local showIcon = cond.neq(slot.itemImage, "")
	local showSlotNumber = cond.all(props.inHotbar, states.keyboardHint)

	local unlocked = cond.ifelse(props.inHotbar, cond.all(states.opened, item), true)
	local backgroundTransparency = derive(function()
		return theme.slotBackgroundTransparency() * states.preferredTransparency()
	end)

	return create "Frame" {
		BackgroundColor3 = function()
			local defaultColor = theme.slotBackgroundColor():Lerp(
				Color3.fromHex("#ffffff"),
				item() ~= nil and 0 or ((1 - states.preferredTransparency()) * 0.15)
			)
			return defaultColor
		end,
		BackgroundTransparency = function()
			return unlocked() and 0 or backgroundTransparency()
		end,
		Size = UDim2.fromScale(1, 1),

		create "UIPadding" {
			PaddingBottom = px.udim(0, SLOT_PADDING),
			PaddingLeft = px.udim(0, SLOT_PADDING),
			PaddingRight = px.udim(0, SLOT_PADDING),
			PaddingTop = px.udim(0, SLOT_PADDING),
		},
		create "UICorner" {
			CornerRadius = theme.slotCornerRadius,
		},

		create "TextLabel" {
			Name = "ItemName",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = slot.itemName,
			FontFace = theme.slotFontFace,
			TextSize = px.scale(theme.slotTextSize),
			TextColor3 = colorSpring(theme.slotTextColor),
			TextStrokeColor3 = colorSpring(theme.textStrokeColor),
			TextStrokeTransparency = theme.textStrokeTransparency,
			TextWrapped = true,
			RichText = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = slot.zindex,
			Visible = showItemName,
		},
		create "ImageLabel" {
			Name = "Icon",
			BackgroundTransparency = 1,
			Image = slot.itemImage,
			Size = UDim2.fromScale(1, 1),
			ZIndex = slot.zindex,
			Visible = showIcon,

			create "UICorner" {
				CornerRadius = theme.slotCornerRadius,
			},
		},
		create "TextLabel" {
			Name = "Number",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = slot.slotNumber,
			TextColor3 = colorSpring(theme.slotNumberTextColor),
			TextSize = px.scale(theme.slotNumberTextSize),
			FontFace = theme.slotNumberFontFace,
			TextStrokeColor3 = colorSpring(theme.textStrokeColor),
			TextStrokeTransparency = theme.textStrokeTransparency,
			ZIndex = slot.zindex,
			Visible = showSlotNumber,
		},

		show(showEquipStroke, function()
			return create "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				BorderStrokePosition = cond.ifelse(
					theme.slotEquipStrokeOutline,
					Enum.BorderStrokePosition.Outer,
					Enum.BorderStrokePosition.Inner
				),
				Color = theme.slotEquipStrokeColor,
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = px.scale(theme.slotEquipStrokeThickness),
			}
		end),
		show(showDraggingStroke, function()
			return create "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				BorderStrokePosition = cond.ifelse(
					theme.slotEquipStrokeOutline,
					Enum.BorderStrokePosition.Inner,
					Enum.BorderStrokePosition.Outer
				),
				Color = theme.slotDragStrokeColor,
				Thickness = px.scale(theme.slotDragStrokeThickness),
				Transparency = cond.ifelse(item, 0, 0.5),
			}
		end),

		show(showTooltip, function(_, present)
			return tooltip({
				text = slot.tooltipText,
				visible = present,
			})
		end),

		props.children,
		table.unpack(props),
	}
end

local function slot(props: Props)
	local item = props.item
	local isHovering = source(false)
	local slot = useSlot {
		item = item,
		order = props.order,
		inHotbar = props.inHotbar,
	}
	local scale = source(1)

	local slotFrameProps: SlotFrameProps = {
		item = props.item,
		visible = props.visible,
		order = props.order,
		inHotbar = props.inHotbar,

		slot = slot,
		isHovering = isHovering,
		scale = scale,
	}
	local slotDisplayFrame = config.customSlotComponent and config.customSlotComponent(slotFrameProps) or defaultSlotFrame(slotFrameProps)

	return create "Frame" {
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = config.customSlotSize or px.offset(config.slotSize, config.slotSize),
		LayoutOrder = props.order,
		Visible = props.visible,
		Active = false,

		action(slot.slotFrameRef :: any),

		-- Allow for resizing buttons like when tool is equipped
		create "UIScale" {
			Scale = scale,
		},

		-- Events here
		create "TextButton" {
			Active = true,
			BackgroundTransparency = 1,
			ZIndex = 1e9,
			Size = UDim2.fromScale(1, 1),
			Text = "",

			action(slot.slotRef :: any),

			create "UICorner" {
				CornerRadius = config.customSlotCornerRadius or UDim.new(0, 0),
			},

			slot.useDrag(),

			MouseButton1Click = slot.onClick,
			MouseEnter = function()
				isHovering(true)
			end,
			MouseLeave = function()
				isHovering(false)
			end,
		},

		slotDisplayFrame,
	}
end

return slot
