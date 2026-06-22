local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local theme = require("../theme")
local tooltip = require("./tooltip")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local useSlot = require("../hooks/backpack/useSlot")
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

local function slot(props: Props)
	local item = props.item
	local isHovering = source(false)
	local slot = useSlot({
		item = item,
		order = props.order,
		inHotbar = props.inHotbar,
	})

	local customProps = derive(function()
		local currentItem = item()
		-- triggers
		slot.itemName()
		slot.itemImage()
		slot.tooltipText()

		local renderCallback = states.onSlotRender().callback
		if renderCallback and currentItem then
			return renderCallback({ item = currentItem, inHotbar = props.inHotbar, order = props.order })
		end
		return {}
	end)

	local unlocked = cond.ifelse(props.inHotbar, cond.all(states.opened, item), true)
	local showEquipStroke = cond.all(item, cond.eq(states.equippedItem, item))
	local showDraggingStroke =
		cond.any(cond.all(item, slot.isDragging), cond.eq(states.gamepadSwapIndex, slot.getIndex))
	local showItemName = cond.eq(slot.itemImage, "")
	local showIcon = cond.neq(slot.itemImage, "")
	local showSlotNumber = cond.all(props.inHotbar, states.keyboardHint)
	local showTooltip = cond.all(props.inHotbar, cond.neq(slot.tooltipText, ""), isHovering)

	local preferredTransparency = usePreferredTransparency()
	local backgroundTransparency = derive(function()
		return (customProps().BackgroundTransparency or theme.slotBackgroundTransparency()) * preferredTransparency()
	end)

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = px.offset(config.slotSize, config.slotSize),
		LayoutOrder = props.order,
		Visible = props.visible,

		action(slot.slotFrameRef :: any),

		create("TextButton")({
			BackgroundColor3 = function()
				local defaultColor = theme.slotBackgroundColor():Lerp(
					Color3.fromHex("#ffffff"),
					item() ~= nil and 0 or ((1 - preferredTransparency()) * 0.15)
				)
				return customProps().BackgroundColor or defaultColor
			end,
			BackgroundTransparency = cond.ifelse(unlocked, 0, backgroundTransparency),
			Size = px.offset(config.slotSize, config.slotSize),
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
				PaddingBottom = px.udim(0, SLOT_PADDING),
				PaddingLeft = px.udim(0, SLOT_PADDING),
				PaddingRight = px.udim(0, SLOT_PADDING),
				PaddingTop = px.udim(0, SLOT_PADDING),
			}),
			create("UICorner")({
				CornerRadius = theme.slotCornerRadius,
			}),
			show(showEquipStroke, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = cond.ifelse(
						theme.slotEquipStrokeOutline,
						Enum.BorderStrokePosition.Outer,
						Enum.BorderStrokePosition.Inner
					),
					Color = theme.slotEquipStrokeColor,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = px.scale(theme.slotEquipStrokeThickness),
				})
			end),
			show(showDraggingStroke, function()
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					BorderStrokePosition = cond.ifelse(
						theme.slotEquipStrokeOutline,
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
				Text = function()
					return customProps().ItemName or slot.itemName()
				end,
				FontFace = theme.slotFontFace,
				TextSize = px.scale(theme.textSize),
				TextColor3 = colorSpring(theme.slotTextColor),
				TextStrokeTransparency = theme.textStrokeTransparency,
				TextWrapped = true,
				RichText = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = slot.zindex,
				Visible = showItemName,
			}),
			create("ImageLabel")({
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = function()
					return customProps().ItemImage or slot.itemImage()
				end,
				Size = UDim2.fromScale(1, 1),
				ZIndex = slot.zindex,
				Visible = showIcon,

				create("UICorner")({
					CornerRadius = theme.slotCornerRadius,
				}),
			}),
			create("TextLabel")({
				Name = "Number",
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = slot.slotNumber,
				TextColor3 = colorSpring(theme.textColor),
				TextSize = px.scale(theme.smallTextSize),
				FontFace = theme.fontFace,
				TextStrokeColor3 = colorSpring(theme.textStrokeColor),
				TextStrokeTransparency = theme.textStrokeTransparency,
				ZIndex = slot.zindex,
				Visible = showSlotNumber,
			}),
			show(showTooltip, function(_, present)
				return tooltip({
					text = function()
						return customProps().TooltipText or slot.tooltipText()
					end,
					visible = present,
				}),
					0.2
			end),
		}),
	})
end

return slot
