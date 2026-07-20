local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local px = require("../../core/utils/px")
local slotRender = require("../../api/onSlotRender")()
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

local function slot(props: Props)
	local item = props.item
	local isHovering = source(false)
	local slot = useSlot({
		item = item,
		order = props.order,
		inHotbar = props.inHotbar,
	})

	local customProps = derive(function()
		local renderCallback = slotRender().callback
		local currentItem = item()
		if renderCallback and currentItem then
			-- triggers
			slot.itemName()
			slot.itemImage()
			slot.tooltipText()

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

	local backgroundTransparency = derive(function()
		return (customProps().BackgroundTransparency or theme.slotBackgroundTransparency())
			* states.preferredTransparency()
	end)

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = px.offset(config.slotSize, config.slotSize),
		LayoutOrder = props.order,
		Visible = props.visible,

		action(slot.slotFrameRef :: any),

		create("TextButton")({
			Active = true,
			BackgroundColor3 = function()
				local defaultColor = theme.slotBackgroundColor():Lerp(
					Color3.fromHex("#ffffff"),
					item() ~= nil and 0 or ((1 - states.preferredTransparency()) * 0.15)
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
					Color = theme.slotDragStrokeColor,
					Thickness = px.scale(theme.slotDragStrokeThickness),
					Transparency = cond.ifelse(item, 0, 0.5),
				})
			end),
			create("TextLabel")({
				Name = "ItemName",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = function()
					return customProps().ItemNameText or slot.itemName()
				end,
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

				function()
					return customProps().ItemNameChildren
				end,
			}),
			create("ImageLabel")({
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = slot.itemImage,
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
				TextColor3 = colorSpring(theme.slotNumberTextColor),
				TextSize = px.scale(theme.slotNumberTextSize),
				FontFace = theme.slotNumberFontFace,
				TextStrokeColor3 = colorSpring(theme.textStrokeColor),
				TextStrokeTransparency = theme.textStrokeTransparency,
				ZIndex = slot.zindex,
				Visible = showSlotNumber,
			}),
			show(showTooltip, function(_, present)
				return tooltip({
					text = slot.tooltipText,
					visible = present,
				})
			end),
			function()
				return customProps().Children
			end,
		}),
	})
end

return slot
