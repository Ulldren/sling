local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local config = require("../constants/config")
local px = require("../utils/px")
local states = require("../states")
local theme = require("../theme")
local tooltip = require("./tooltip")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local useSlot = require("../hooks/backpack/useSlot")
local vide = require("../../vide")

local create = vide.create
local show = vide.show
local action = vide.action
local derive = vide.derive
local source = vide.source

type Props = {
	item: () -> BackpackItem?,
	visible: (() -> boolean)?,
	order: number,
	inHotbar: boolean?,
}

local function slot(props: Props): Frame
	local item = props.item
	local preferredTransparency = usePreferredTransparency()
	local backgroundTransparency = derive(function()
		return theme.theme.slotBackgroundTransparency() * preferredTransparency()
	end)
	local isHovering = source(false)
	local slot = useSlot({
		item = item,
		order = props.order,
		inHotbar = props.inHotbar,
	})

	local unlocked = cond.ifelse(props.inHotbar, cond.all(states.opened, item), true)
	local showEquipStroke = cond.all(item, cond.eq(states.equippedItem, item))
	local showDraggingStroke =
		cond.any(cond.all(item, slot.isDragging), cond.eq(states.gamepadSwapIndex, slot.getIndex))
	local showItemName = cond.eq(slot.itemImage, "")
	local showIcon = cond.neq(slot.itemImage, "")
	local showSlotNumber = cond.all(props.inHotbar, states.keyboardHint)
	local showTooltip = cond.all(props.inHotbar, cond.neq(slot.tooltipText, ""), isHovering)

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = px.offset(config.slotSize, config.slotSize),
		LayoutOrder = props.order,
		Visible = props.visible,

		action(slot.slotFrameRef :: any),

		create("TextButton")({
			BackgroundColor3 = colorSpring(function()
				return theme.theme
					.slotBackgroundColor()
					:Lerp(Color3.fromHex("#ffffff"), item() ~= nil and 0 or ((1 - preferredTransparency()) * 0.15))
			end),
			BackgroundTransparency = cond.ifelse(unlocked, 0, backgroundTransparency),
			Size = slot.slotSize,
			Text = "",
			ZIndex = slot.zindex,

			action(slot.slotRef :: any),

			slot.useDrag(),

			MouseButton1Click = slot.onClick,
			MouseEnter = function()
				isHovering(true)
			end,
			MouseLeave = function()
				isHovering(false)
			end,

			create("UIPadding")({
				PaddingBottom = px.udim(0, 5),
				PaddingLeft = px.udim(0, 5),
				PaddingRight = px.udim(0, 5),
				PaddingTop = px.udim(0, 5),
			}),
			create("UICorner")({
				CornerRadius = theme.theme.slotCornerRadius,
			}),
			show(showEquipStroke, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = cond.ifelse(
						theme.theme.slotEquipStrokeOutline,
						Enum.BorderStrokePosition.Outer,
						Enum.BorderStrokePosition.Inner
					),
					Color = theme.theme.slotEquipStrokeColor,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = theme.theme.slotEquipStrokeThickness,
				})
			end),
			show(showDraggingStroke, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = cond.ifelse(
						theme.theme.slotEquipStrokeOutline,
						Enum.BorderStrokePosition.Inner,
						Enum.BorderStrokePosition.Outer
					),
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = px.scale(2),
					Transparency = cond.ifelse(item, 0, 0.5),
				})
			end),
			create("TextLabel")({
				Name = "ItemName",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = slot.itemName,
				FontFace = theme.theme.slotFontFace,
				TextSize = px.scale(theme.theme.textSize),
				TextColor3 = colorSpring(theme.theme.slotTextColor),
				TextStrokeTransparency = theme.theme.textStrokeTransparency,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = slot.zindex,
				Visible = showItemName,
			}),
			create("ImageLabel")({
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = slot.itemImage,
				Size = UDim2.fromScale(1, 1),
				ZIndex = slot.zindex,
				Visible = showIcon,

				create("UICorner")({
					CornerRadius = theme.theme.slotCornerRadius,
				}),
			}),
			create("TextLabel")({
				Name = "Number",
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = slot.slotNumber,
				TextColor3 = colorSpring(theme.theme.textColor),
				TextSize = px.scale(theme.theme.smallTextSize),
				FontFace = theme.theme.fontFace,
				TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
				TextStrokeTransparency = theme.theme.textStrokeTransparency,
				ZIndex = slot.zindex,
				Visible = showSlotNumber,
			}),
			show(showTooltip, function(_, present)
				return tooltip({
					text = slot.tooltipText,
					visible = present,
				}), 0.2
			end),
		}),
	})
end

return slot
